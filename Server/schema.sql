CREATE TABLE term (
  semester VARCHAR PRIMARY KEY
);


CREATE TABLE subjects (
    name VARCHAR PRIMARY KEY,
    semester VARCHAR
);

CREATE TABLE course(
     crn INT PRIMARY KEY,
     course_number INT,
     name VARCHAR,
     subsection INT,
     credits INT,
     subject VARCHAR
);

CREATE TABLE class (
    days VARCHAR,
    start_date VARCHAR,
    end_date VARCHAR,
    start_time VARCHAR,
    end_time VARCHAR,
    location VARCHAR,
    type VARCHAR,
    course VARCHAR,
    PRIMARY KEY (days, start_time, end_time, location)
);
