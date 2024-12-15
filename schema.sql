DROP TABLE IF EXISTS teaches CASCADE;
DROP TABLE IF EXISTS advisor CASCADE;
DROP TABLE IF EXISTS takes CASCADE;
DROP TABLE IF EXISTS section CASCADE;
DROP TABLE IF EXISTS course CASCADE;
DROP TABLE IF EXISTS instructor CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS department CASCADE;

-- Create Department table
CREATE TABLE IF NOT EXISTS Department (
    dept_name VARCHAR(50) PRIMARY KEY
);

-- Create Student table
CREATE TABLE IF NOT EXISTS Student (
    ID VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    tot_cred INT,
    FOREIGN KEY (dept_name) REFERENCES Department(dept_name)
);

-- Create Course table
CREATE TABLE IF NOT EXISTS Course (
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(100),
    dept_name VARCHAR(50),
    credits INT,
    FOREIGN KEY (dept_name) REFERENCES Department(dept_name)
);

-- Create Section table
CREATE TABLE IF NOT EXISTS Section (
    course_id VARCHAR(10),
    sec_id INT,
    semester VARCHAR(10),
    year INT,
    building VARCHAR(50),
    room_number VARCHAR(10),
    time_slot_id VARCHAR(10),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Create Takes table
CREATE TABLE IF NOT EXISTS Takes (
    ID VARCHAR(10),
    course_id VARCHAR(10),
    sec_id INT,
    semester VARCHAR(10),
    year INT,
    grade CHAR(1),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (ID) REFERENCES Student(ID),
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

-- Create Instructor table
CREATE TABLE IF NOT EXISTS Instructor (
    ID INT PRIMARY KEY,
    name VARCHAR(50),
    dept_name VARCHAR(50),
    salary DECIMAL(10, 2),
    FOREIGN KEY (dept_name) REFERENCES Department(dept_name)
);

-- Insert data into Department table
INSERT INTO Department (dept_name) VALUES
('Comp. Sci.'),
('Math'),
('Physics');

-- Insert data into Student table
INSERT INTO Student (ID, name, dept_name, tot_cred) VALUES
('1', 'Alice', 'Comp. Sci.', 32),
('2', 'Bob', 'Math', 20),
('3', 'Charlie', 'Comp. Sci.', 28),
('4', 'David', 'Physics', 25),
('5', 'Eve', 'Comp. Sci.', 15);

-- Insert data into Course table
INSERT INTO Course (course_id, title, dept_name, credits) VALUES
('CS101', 'Intro to Computer Science', 'Comp. Sci.', 4),
('CS102', 'Data Structures', 'Comp. Sci.', 4),
('MATH101', 'Calculus I', 'Math', 3),
('PHYS101', 'Physics I', 'Physics', 4);

-- Insert data into Takes table
INSERT INTO Takes (ID, course_id, sec_id, semester, year, grade) VALUES
('1', 'CS101', 1, 'Fall', 2008, 'A'),
('2', 'MATH101', 1, 'Spring', 2009, 'B'),
('3', 'CS102', 1, 'Fall', 2009, 'A'),
('4', 'PHYS101', 1, 'Fall', 2008, 'B'),
('5', 'CS101', 1, 'Spring', 2009, 'A');

-- Insert data into Instructor table
INSERT INTO Instructor (ID, name, dept_name, salary) VALUES
(101, 'Prof. Smith', 'Comp. Sci.', 90000.00),
(102, 'Prof. Johnson', 'Math', 85000.00),
(103, 'Prof. Lee', 'Physics', 92000.00),
(104, 'Prof. White', 'Comp. Sci.', 88000.00);

-- a. Create a new course CS-001, titled "Weekly Seminar" with 0 credits

INSERT INTO Course (course_id, title, dept_name, credits) VALUES
('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);


-- b. Create a section of this course in Autumn 2009, with sec_id of 1
INSERT INTO Section (course_id, sec_id, semester, year, building, room_number, time_slot_id)
VALUES ('CS-001', 1, 'Autumn', 2009, 'CompSciBldg', '101', 'T1');

-- c. Enroll every student in the above section
INSERT INTO Takes (ID, course_id, sec_id, semester, year, grade)
SELECT ID, 'CS-001', 1, 'Autumn', 2009, NULL
FROM Student;

-- d. Delete enrollments in the above section where the student's name is "Chavez"
DELETE FROM Takes
WHERE course_id = 'CS-001'
  AND sec_id = 1
  AND semester = 'Autumn'
  AND year = 2009
  AND ID IN (SELECT ID FROM Student WHERE name = 'Chavez');

-- e. Delete the course CS-001 without first deleting offerings (sections) of this course
DELETE FROM Course WHERE course_id = 'CS-001';

-- f. Delete all takes tuples corresponding to any section of any course with the word "database" in the title
DELETE FROM Takes
WHERE course_id IN (
    SELECT course_id
    FROM Course
    WHERE LOWER(title) LIKE '%database%'
);