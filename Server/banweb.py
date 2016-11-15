# Blog Flask application

import os
import sqlite3
from flask import Flask, request, render_template, g
import json

# Create the application
app = Flask(__name__)

####################################################
# Routes

@app.route("/")
def index():
    return render_template("index.html", step="incorrect_password")


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
    with app.open_resource('courseInfo.json', mode='r') as f:
        class_data = json.load(f)
        for semester in class_data.keys():
            #print "Semester:", semester
            # Insert Semester if it doesn't exitst
            db.execute("INSERT OR REPLACE INTO term (semester) VALUES (?)", (semester,))

            subjects = class_data[semester]['subjects']
            for subject in subjects.keys():
                #print "  Subject:", subject
                # Insert Subject
                db.execute("INSERT OR REPLACE INTO subjects (name) VALUES (?)", (subject,))
                db.execute("INSERT OR REPLACE INTO subject_term (semester, subject) VALUES (?, ?)", (semester, subject))


                for course in subjects[subject]:
                    if ('crn' in course and 'classes' in course):
                        #print "    CRN:", course['crn']
                        # Insert Course
                        db.execute("INSERT OR REPLACE INTO course (course_number, crn, name, subsection, credits, subject) VALUES (?, ?, ?, ?, ?, ?)",
                                       (course['courseNumber'], course['crn'], course['name'], course['courseSubNum'], course['credits'], subject))


                        for c in course['classes']:
                            #print "      Class Location:", c['location']
                            #Insert Classes
                            db.execute("""INSERT OR REPLACE INTO class (days, start_date, end_date, start_time, end_time, location, type, course)
                                              VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                                           (c['days'], c['startDate'], course['endDate'], c['startTime'], c['endTime'], c['location'], c['type'], course['crn']))



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