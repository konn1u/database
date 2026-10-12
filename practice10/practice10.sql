CREATE DATABASE practice10;

-- Задание 1
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL
);

CREATE TABLE Project_Members (
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE CASCADE
);

-- Задание 2
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL
);

CREATE TABLE Equipment (
    equipment_id INT PRIMARY KEY,
    equipment_name VARCHAR(255) NOT NULL
);

CREATE TABLE EquipmentRentals (
    client_id INT NOT NULL,
    equipment_id INT NOT NULL,
    rental_date DATE NOT NULL,
    PRIMARY KEY (client_id, equipment_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE CASCADE
);

-- Задание 3
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_professor VARCHAR(255) NOT NULL
);

CREATE TABLE Grades (
    grade_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    assignment_name VARCHAR(100) NOT NULL,
    grade NUMERIC(4, 2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    CONSTRAINT uq_student_course_assignment UNIQUE (student_id, course_id, assignment_name)
);