# Blog Flask application
# Using python 2.7.10
import os
import sqlite3
from flask import Flask, request, render_template, g, redirect, url_for, make_response
import json
import random
import hashlib

# Create the application
app = Flask(__name__)

####################################################
# Routes

@app.route("/", methods=['get', 'post'])
def index():
    if "action" not in request.form:
        return render_template("index.html")
    elif request.form["action"] == "login":
        print "Logging in"

        db = get_db()
        rhodes_id = request.form["rhodes_id"]
        password = request.form["password"]
        password_hash = hashlib.sha1(password).hexdigest()

        try:
            int(rhodes_id)
        except:
            return render_template("index.html", step="invalid_login_id")

        rows= db.execute('SELECT password FROM student WHERE rhodes_id=?', (rhodes_id,))
        stored_hash = rows.fetchone()
        if (stored_hash and password_hash == stored_hash['password']):
            response = make_response(redirect(url_for("home"), code=301))
            response.set_cookie('id', value=str(rhodes_id))
            return response
        else:
            return render_template("index.html", step="invalid_login")

    elif request.form["action"] == "register":
        rhodes_id = request.form["rhodes_id"]
        password = request.form["password"]

        if len(password) < 1:
            return render_template("index.html", step="invalid_register")

        try:
            int(rhodes_id)
        except:
            return render_template("index.html", step="invalid_register")

        db = get_db()

        # Make sure username doesn't already exist
        rows= db.execute('SELECT COUNT(*) FROM student WHERE rhodes_id=?', (rhodes_id,))
        if (rows.fetchone()[0] == 0):
            print rhodes_id, "Registered"
            db.execute('INSERT INTO student (rhodes_id, password) VALUES (?, ?)', (rhodes_id, hashlib.sha1(password).hexdigest()))
            db.commit()

            response = make_response(redirect(url_for("home"), code=301))
            response.set_cookie('id', value=rhodes_id)
            return response
        else:
            return render_template("index.html", step="register_id_taken")

# Shows the classes you plan to take this semester
# Also lets you select each one to delete
# Will also have a link to search for classes
@app.route("/home", methods=['get', 'post'])
def home():
    if 'id' not in request.cookies:
        print "Error, user tried to access protected page without logging in"
        return redirect(url_for("error"), code=301)
    rhodes_id = request.cookies['id']

    db = get_db()
    rows = db.execute('SELECT * FROM course JOIN student_course ON course.crn=student_course.course WHERE student=?', (rhodes_id,))# JOIN student ON student.rhodes_id=student_course.student')#
    rowlist = rows.fetchall()
    print rowlist
    return render_template('home.html', courses=rowlist)

# A page to search for classes. Can add them using "/add"
@app.route("/search", methods=['get', 'post'])
def search():
    if 'id' not in request.cookies:
        print "Error, user tried to access protected page without logging in"
        return redirect(url_for("error"), code=301)
    rhodes_id = request.cookies['id']

    ### Get the terms and subjects a user can select ###
    db = get_db()
    rows = db.execute('SELECT * FROM term')
    terms = rows.fetchall()
    # Order the terms
    def compare_terms(a, b):
        # Extract term out of it's single item tuple
        a = a[0]
        b = b[0]
        seasons_ranked = ['Fall', 'Summer', 'Spring']
        a_season, a_year = a.split(' ')
        b_season, b_year = b.split(' ')
        if a_year == b_year:
            if seasons_ranked.index(a_season) < seasons_ranked.index(b_season):
                return -1
            return seasons_ranked.index(a_season) > seasons_ranked.index(b_season)
        elif int(a_year) > int(b_year):
            return -1
        return int(a_year) < int(b_year)
    terms = sorted(terms, cmp=compare_terms)

    if 'action' in request.form:
        ### Get parameters and build a sql statement ###
        # These are the searchable parameters.
        # We'll look for them in the form data and if one is used we'll add it to the sql query
        valid_parameters = ['crn', 'course_number', 'name', 'subject']
        search_items = [request.form['term']]
        selectString = ""
        for key in request.form.keys():
            if key in valid_parameters and request.form[key] != "": #Search parameter wasnt null
                if selectString != "":
                    selectString += " AND "
                selectString += "course." + key + " LIKE ?"
                search_items.append("%"+request.form[key]+"%") # % means match anything

        if len(search_items) <= 1:
            return render_template('search.html', courses=[], terms=terms, step='show_results')
        else:
            sql_statement = "SELECT * FROM course JOIN course_term ON course.crn=course_term.course NATURAL JOIN term WHERE semester=? AND "+selectString
            print "Full Search SQL Statement:", sql_statement
            rows = db.execute(sql_statement, search_items)
            rowlist = rows.fetchall()
            return render_template('search.html', courses=rowlist, terms=terms, step='show_results')
    else:
        return render_template('search.html', courses=[], terms=terms, step='show_results')

# After searching for a class, you click a link here to add it
@app.route("/add", methods=['get', 'post'])
def add():
    if 'id' not in request.cookies:
        print "Error, user tried to access protected page without logging in"
        return redirect(url_for("error"), code=301)
    rhodes_id = request.cookies['id']

    db = get_db()
    db.execute('INSERT INTO student_course (student, course) VALUES (?, ?)', (rhodes_id, request.form['crn']))
    db.commit()

    return redirect(url_for("home"), code=301)

# Delete a class
@app.route("/delete", methods=['get', 'post'])
def delete():
    if 'id' not in request.cookies:
        print "Error, user tried to access protected page without logging in"
        return redirect(url_for("error"), code=301)
    rhodes_id = request.cookies['id']

    return redirect(url_for("home"), code=301)


#####################################################
# Database handling 

def connect_db():
    """Connects to the database."""
    debug("Connecting to DB.")
    conn = sqlite3.connect(os.path.join(app.root_path, 'banweb.db'))
    conn.row_factory = sqlite3.Row
    return conn

def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'db_connection'):
        g.db_connection = connect_db()
    return g.db_connection

@app.teardown_appcontext
def close_db(error):
    """Closes the database automatically when the application
    context ends."""
    debug("Disconnecting FROM DB.")
    if hasattr(g, 'db_connection'):
        g.db_connection.close()

def last_inserted_row():
    pass

######################################################
# Command line utilities 

def init_db():
    db = get_db()
    with app.open_resource('schema.sql', mode='r') as f:
        db.cursor().executescript(f.read())
    db.commit()

@app.cli.command('initdb')
def init_db_command():
    """Initializes the database."""
    print("Initializing DB.")
    init_db()
    print "Done"

def populate_db():
    db = get_db()

    # Add Class data
    with app.open_resource('courseInfo.json', mode='r') as f:
        class_data = json.load(f)
        for semester in class_data.keys():
            #print "Semester:", semester
            # Insert Semester if it doesn't exitst
            query = db.execute("INSERT OR REPLACE INTO term (semester) VALUES (?)", (semester,))
            semester_id = query.lastrowid

            subjects = class_data[semester]['subjects']
            for subject in subjects.keys():
                #print "  Subject:", subject
                # Insert Subject
                db.execute("INSERT OR REPLACE INTO subject (name) VALUES (?)", (subject,))
                db.execute("INSERT OR REPLACE INTO subject_term (semester, subject) VALUES (?, ?)", (semester, subject))


                for course in subjects[subject]:
                    if ('crn' in course and 'classes' in course):
                        #print "    CRN:", course['crn']
                        # Insert Course
                        db.execute("INSERT OR REPLACE INTO course (course_number, crn, name, subsection, credits, subject) VALUES (?, ?, ?, ?, ?, ?)",
                                       (course['courseNumber'], course['crn'], course['name'], course['courseSubNum'], course['credits'], subject))
                        db.execute("INSERT OR REPLACE INTO course_subject (course, subject) VALUES (?, ?)", (course['crn'], subject))
                        db.execute("INSERT OR REPLACE INTO course_term (course, semester) VALUES (?, ?)", (course['crn'], semester))

                        for c in course['classes']:
                            #print "      Class Location:", c['location']
                            #Insert Classes
                            query = db.execute("""INSERT OR REPLACE INTO class (days, start_date, end_date, start_time, end_time, location, type, course)
                                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                                           (c['days'], c['startDate'], course['endDate'], c['startTime'], c['endTime'], c['location'], c['type'], course['crn']))
                            db.execute("INSERT OR REPLACE INTO class_course (class, course) VALUES (?, ?)", (query.lastrowid, course['crn']))


    db.commit()

@app.cli.command('populate')
def populate_db_command():
    """Populates the database with sample data."""
    print("Populating DB with sample data.")
    populate_db()
    print "Done"


#####################################################
# Debugging

def debug(s):
    """Prints a message to the screen (not web browser) 
    if FLASK_DEBUG is set."""
    if app.config['DEBUG']:
        print(s)