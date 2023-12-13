CREATE TABLE Professor (
    SSN INT PRIMARY KEY,
    name VARCHAR(100),
    title VARCHAR(50),
    sex ENUM('F', 'M'),
    salary INT,
    area_code VARCHAR(5),
    phone_number VARCHAR(7),
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zipcode VARCHAR(10)
);

INSERT INTO Professor
VALUES
(12345, 'Shawn Wang', 'Professor', 'M', 80000, '562', '2567894', '123 Main St', 'Fullerton', 'CA', '92805'),
(98761, 'Harin Khaki', 'Associate Professor', 'M', 70000, '544', '7654321', '456 Elm St', 'Stateville', 'FLO', '54321'),
(11122, 'Bob Johnson', 'Assistant Professor', 'M', 60000, '678', '9876543', '789 Oak St', 'Stateville', 'WA', '67890');



CREATE TABLE Degrees (
    PSSN INT PRIMARY KEY,
    degree VARCHAR(100),
    FOREIGN KEY (PSSN) REFERENCES Professor(SSN)
);


CREATE TABLE Department (
    `Department_#` INT PRIMARY KEY,
    name VARCHAR(100),
    telephone VARCHAR(15),
    PSSN INT,
    Office_Location VARCHAR(25),

    FOREIGN KEY (PSSN) REFERENCES Professor(SSN)
);


INSERT INTO Department VALUES 
(1, 'Computer Science', 5555555555, 12345, 'ECS Building'), 
(2, 'Engineering', 5555555555, 11122, 'ECS Building');




CREATE TABLE Student (
    CWID INT PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50),
    address VARCHAR(255),
    telephone INT,
    DNO INT,
    FOREIGN KEY (DNO) REFERENCES Department(`Department_#`)
);


INSERT INTO Student VALUES (886292088, 'Vamsi', 'Mannava', '1511 Daphne Drive', 3087590434, 1),
(886292099, 'Hyndavi', 'Teegala', '1512 Daphne Drive', 4086455326, 1),
(886292188, 'Hamzah', 'Deejay', '1513 Daphne Drive', 4085219999,1),
(886292299, 'Connie', 'Zhu', '1514 Daphne Drive', 6590435326,1),
 (886293713, 'Archaela', 'Tadiosa', '1515 Daphne Drive', 7248436591,2),
(886292054, 'Brock', 'Nguyen', '1516 Daphne Drive', 5347540434,2),
(886292323, 'Anjali', 'Patel', '1517 Daphne Drive', 6742341111, 1),
(886292421, 'Vamsi', 'Mannava', '1518 Daphne Drive', 6666666966, 1);




CREATE TABLE Minor (
    STUDENT_NO INT,
    DNO INT,
    PRIMARY KEY (STUDENT_NO, DNO),
    FOREIGN KEY (STUDENT_NO) REFERENCES Student(CWID),
    FOREIGN KEY (DNO) REFERENCES Department(`Department_#`)
);


CREATE TABLE Course( 
   course_number VARCHAR(10) PRIMARY KEY,
   Title VARCHAR(60),
   unit INT, 
   DNO INT, -- assuming this is the department number
   textbook VARCHAR(30),

   FOREIGN KEY (DNO) REFERENCES Department(`Department_#`)
);

Courses: 332, 240, 335, 258
INSERT INTO Course (course_number, Title, unit, DNO, textbook) VALUES
('EGCE 120', 'Assembly', 3, 2, 'Intro to x86'),
('CPSC 335', 'Intro to Cybersecurity', 3, 1, 'Intro to Alg'),
(‘CPSC 332’, ‘Intro to Databases’, 3, 1, ‘Database for All’),
('EGCE 258', 'Circuits', 3, 2, 'Intro to Engineering');




CREATE TABLE Section(
    section_number INT PRIMARY KEY,
    CNO VARCHAR(10),
    start_time TIME,
    end_time TIME, 
    meeting_days VARCHAR(20), 
    seats INT,
    PSSN INT,
    FOREIGN KEY (CNO) REFERENCES Course(course_number),
    FOREIGN KEY (PSSN) REFERENCES Professor(SSN)
);
INSERT INTO Section VALUES
(01, 'CPSC 332', '16:00', '17:50', 'MW', 32, 12345),
(03, 'CPSC 335', '12:00', '13:15', 'MW', 32, 98761),
(02, 'EGCE 258', '10:00', '11:50', 'TTH', 32, 11122),
(04, 'EGCE 120', '10:00', '10:50', 'MWF', 32, 11122),
(05, 'CPSC 332', '08:00', '09:50', 'TTH', 32, 12345),
(06, 'CPSC 332', '16:00', '17:00', 'MW', 32, 12345);







CREATE TABLE Enrollment_record (
    CNO VARCHAR(10),
    SNO INT, 
    CWID INT,
    Grade VARCHAR(3),
    FOREIGN KEY (CNO) REFERENCES Section(CNO),
    FOREIGN KEY (SNO) REFERENCES Section(section_number),
    FOREIGN KEY (CWID) REFERENCES Student(CWID)
);
INSERT INTO Enrollment_record VALUES
('CPSC 332', 01, 886292088, 'A'),
('CPSC 335', 03, 886292088, 'B+'),
('EGCE 258', 02, 886292088, 'C'),
('EGCE 120', 04, 886292088, 'D'),
('CPSC 332', 01, 886292099, 'A-'),
('CPSC 335', 01, 886292099, 'A'),
('EGCE 258', 02, 886292099, 'C+'),
('CPSC 332', 01, 886292188, 'B-'),
('EGCE 258', 02, 886292188, 'A'),
('EGCE 120', 04, 886292188, 'A'),
('CPSC 332', 05, 886292188, 'C'),
('EGCE 258', 02, 886293713, 'A'),
('EGCE 120', 04, 886293713, 'C+'),
('CPSC 332', 01, 886292323, 'A'),
('CPSC 335', 03, 886292323, 'B'),
('EGCE 120', 04, 886292323, 'C'),
('CPSC 332', 01, 886292299, 'A'),
('CPSC 335', 03, 886292299, 'B+'),
('EGCE 120', 04, 886292054, 'B-'),
('EGCE 258', 02, 886292054, 'C+');




CREATE TABLE Prerequisite(
   CNO VARCHAR(10),
    PCNO VARCHAR(10),
    FOREIGN KEY (CNO) REFERENCES Section(CNO),
    FOREIGN KEY (PCNO) REFERENCES Section(CNO)
);


