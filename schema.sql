-- db creation
CREATE DATABASE company_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- user creation
CREATE USER 'company_user'@'localhost' IDENTIFIED BY 'placeholderPW';

-- grant access for user on db
GRANT CREATE, ALTER, DROP, INDEX, REFERENCES,
SELECT, INSERT, UPDATE, DELETE
ON company_db.* TO 'company_user'@'localhost';

USE company_db;

-- Table creation
CREATE TABLE departments (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    location    VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    employed_at   DATE,
    department_id INT NOT NULL,
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE access_cards (
    card_number         INT PRIMARY KEY,
    date_of_issue       DATE NOT NULL,
    final_validity_date DATE NOT NULL,
    employee_id         INT NOT NULL UNIQUE,
    CONSTRAINT fk_access_card_employee
        FOREIGN KEY (employee_id) REFERENCES employees(id)
);



-- data population
-- departments we make sure legal will have no employees later
INSERT INTO departments(name,location) VALUES
    ('IT',      'Stockholm'),
    ('HR',      'Göteborg'),
    ('Sales',   'Malmö'),
    ('Finance', 'Stockholm'),
    ('Legal',   'Uppsala');

-- employees population
-- we use a select for the department id based on name. This works right now as we dont have the same department on multiple locations currently. If this was the case we would have to use an AND where location = "location"
INSERT INTO employees (first_name, last_name, email, employed_at, department_id) VALUES
    ('Anna',   'Svensson',  'anna.svensson@company.test',  '2022-03-14', (SELECT id FROM departments WHERE name = 'IT')),
    ('Erik',   'Lindberg',  'erik.lindberg@company.test',  '2023-01-09', (SELECT id FROM departments WHERE name = 'IT')),
    ('Maja',   'Karlsson',  'maja.karlsson@company.test',  '2024-06-01', (SELECT id FROM departments WHERE name = 'IT')),
    ('Johan',  'Nilsson',   'johan.nilsson@company.test',  '2021-09-20', (SELECT id FROM departments WHERE name = 'HR')),
    ('Sara',   'Berg',      'sara.berg@company.test',      '2025-02-03', (SELECT id FROM departments WHERE name = 'HR')),
    ('Oskar',  'Holm',      'oskar.holm@company.test',     '2020-11-16', (SELECT id FROM departments WHERE name = 'Sales')),
    ('Lina',   'Ek',        'lina.ek@company.test',        '2023-08-28', (SELECT id FROM departments WHERE name = 'Sales')),
    ('Viktor', 'Dahl',      'viktor.dahl@company.test',    '2024-10-07', (SELECT id FROM departments WHERE name = 'Sales')),
    ('Emma',   'Wallin',    'emma.wallin@company.test',    '2022-05-30', (SELECT id FROM departments WHERE name = 'Finance'));

-- Access card population
-- Only some employees will get a card here
-- finding employee_id based on the email that is unique for each employee
INSERT INTO access_cards (card_number, date_of_issue, final_validity_date, employee_id) VALUES
    (1001, '2022-03-14', '2027-03-14', (SELECT id FROM employees WHERE email = 'anna.svensson@company.test')),
    (1002, '2023-01-09', '2028-01-09', (SELECT id FROM employees WHERE email = 'erik.lindberg@company.test')),
    (1003, '2021-09-20', '2026-09-20', (SELECT id FROM employees WHERE email = 'johan.nilsson@company.test')),
    (1004, '2020-11-16', '2025-11-16', (SELECT id FROM employees WHERE email = 'oskar.holm@company.test')),
    (1005, '2022-05-30', '2027-05-30', (SELECT id FROM employees WHERE email = 'emma.wallin@company.test'));

-- Join frågor för G

-- G1
SELECT e.first_name, e.last_name, d.name AS departments  FROM employees AS e
    INNER JOIN departments d ON d.id = e.department_id;

-- G2
-- concat name into one column
-- legal returns a null value for name as there is no employees linked to this department
SELECT CONCAT(e.first_name, ' ', e.last_name) as name, d.name as department from departments AS d
    LEFT JOIN employees e ON d.id = e.department_id;


-- VG tables
CREATE TABLE qualifications(
    id               INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL UNIQUE,
    description text NOT NULL
);

CREATE TABLE employee_qualifications(
    employee_id INT NOT NULL,
    qualification_id INT NOT NULL,
    PRIMARY KEY (employee_id, qualification_id),
    CONSTRAINT fk_empqual_employee
        FOREIGN KEY (employee_id) REFERENCES employees(id),
    CONSTRAINT fk_empqual_qualification
        FOREIGN KEY (qualification_id) REFERENCES qualifications(id)
)


-- VG data population
INSERT INTO qualifications (name, description) VALUES
    ('Java',         'Programming in Java, including object-oriented design'),
    ('SQL',          'Designing and querying relational databases'),
    ('Project lead', 'Leading projects, planning and following up on teams'),
    ('Python',       'Scripting and application development in Python');

-- get the employee id based on email as its unique and we can select the id on qualification based on name as name is unique.
-- We also make sure that we have one qualification that is never used (Python)
INSERT INTO employee_qualifications (employee_id, qualification_id) VALUES
    ((SELECT id FROM employees WHERE email = 'anna.svensson@company.test'), (SELECT id FROM qualifications WHERE name = 'Java')),
    ((SELECT id FROM employees WHERE email = 'anna.svensson@company.test'), (SELECT id FROM qualifications WHERE name = 'SQL')),
    ((SELECT id FROM employees WHERE email = 'anna.svensson@company.test'), (SELECT id FROM qualifications WHERE name = 'Project lead')),

    ((SELECT id FROM employees WHERE email = 'erik.lindberg@company.test'), (SELECT id FROM qualifications WHERE name = 'Java')),
    ((SELECT id FROM employees WHERE email = 'erik.lindberg@company.test'), (SELECT id FROM qualifications WHERE name = 'SQL')),

    ((SELECT id FROM employees WHERE email = 'maja.karlsson@company.test'), (SELECT id FROM qualifications WHERE name = 'Java')),

    ((SELECT id FROM employees WHERE email = 'johan.nilsson@company.test'), (SELECT id FROM qualifications WHERE name = 'SQL')),

    ((SELECT id FROM employees WHERE email = 'oskar.holm@company.test'), (SELECT id FROM qualifications WHERE name = 'Project lead'));


-- VG1
SELECT CONCAT(e.first_name, ' ', e.last_name) as name, d.name as department, ac.card_number FROM employees AS e
    INNER JOIN departments d ON e.department_id = d.id
    LEFT JOIN access_cards ac ON e.id = ac.employee_id;

-- VG2
SELECT d.name as department, CONCAT(e.first_name, ' ', e.last_name) as name, ac.card_number FROM departments AS d
    LEFT JOIN employees e ON d.id = e.department_id
    LEFT JOIN access_cards ac ON e.id = ac.employee_id;

-- VG3 samlade uppgifter
SELECT * FROM employees AS e
LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN access_cards ac ON e.id = ac.employee_id
    LEFT JOIN employee_qualifications eq ON e.id = eq.employee_id
    LEFT JOIN qualifications q ON eq.qualification_id = q.id
    WHERE email = 'anna.svensson@company.test'

-- VG3 kontroll av valfria kopplingar part 1
SELECT * FROM employees AS e
    LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN access_cards ac ON e.id = ac.employee_id
    LEFT JOIN employee_qualifications eq ON e.id = eq.employee_id
    LEFT JOIN qualifications q ON eq.qualification_id = q.id
    WHERE e.email = 'maja.karlsson@company.test';

--VG3 kontroll av valfria kopplingar part 2
SELECT * FROM employees AS e
    LEFT JOIN departments d ON e.department_id = d.id
    LEFT JOIN access_cards ac ON e.id = ac.employee_id
    LEFT JOIN employee_qualifications eq ON e.id = eq.employee_id
    LEFT JOIN qualifications q ON eq.qualification_id = q.id
    WHERE e.email = 'emma.wallin@company.test';

-- VG4 part 1
SELECT d.name as department, CONCAT(e.first_name, ' ', e.last_name) as name FROM departments AS d
    INNER JOIN employees e ON d.id = e.department_id

-- VG4 part 2
SELECT d.name as department, CONCAT(e.first_name, ' ', e.last_name) as name FROM departments AS d
    LEFT JOIN employees e ON d.id = e.department_id
