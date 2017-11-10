
CREATE TABLE term (
    semester VARCHAR PRIMARY KEY
);

CREATE TABLE subject (
    name VARCHAR PRIMARY KEY
);

CREATE TABLE subject_term (
    semester VARCHAR,
    subject VARCHAR,
    PRIMARY KEY(semester, subject)
);

CREATE TABLE course_term (
    semester VARCHAR,
    course INT,
    PRIMARY KEY(semester, course)
);

CREATE TABLE course(
     crn INT PRIMARY KEY,
     course_number INT,
     name VARCHAR,
     subsection INT,
     credits INT,
     subject VARCHAR
);

CREATE TABLE course_subject(
     course INT,
     subject INT,
     UNIQUE (course, subject)
);


CREATE TABLE class (
    rowid INTEGER PRIMARY KEY AUTOINCREMENT,
    days VARCHAR,
    start_date VARCHAR,
    end_date VARCHAR,
    start_time VARCHAR,
    end_time VARCHAR,
    location VARCHAR,
    type VARCHAR,
    course VARCHAR,
    UNIQUE (days, start_time, end_time, location, course)
    -- We'll be using the rowid for the primary key
);

CREATE TABLE class_course(
    class INT,
    course INT
);

CREATE TABLE student (
    rhodes_id INT,
    password VARCHAR
);

CREATE TABLE student_course (
   student INT,
   course INT
);
