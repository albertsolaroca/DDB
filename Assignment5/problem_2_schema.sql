CREATE TABLE employees (
	id SERIAL NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	salary REAL NOT NULL DEFAULT 25000.0
);

CREATE TABLE employee_audit_log (
	employee_id INTEGER NOT NULL,
	occurred_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees(name, salary)
VALUES
('Arnold Schwarznegger', 35000),
('Yuri Gargarin', 27000),
('Anakin Skywalker', 450000),
('Said Faroghi', 15000),
('Zino Holwerda', 8500);

CREATE OR REPLACE FUNCTION 	process_employee_audit_log() RETURNS TRIGGER AS 	$employee_audit_log$
		BEGIN
				--log the employee and the current time after each modification on the employee TABLE
				INSERT INTO employee_audit_log SELECT NEW.id, now();
				RETURN NEW;
		END;
$employee_audit_log$ LANGUAGE plpgsql;

CREATE TRIGGER emp_audit AFTER INSERT OR UPDATE ON employees
		FOR EACH ROW EXECUTE PROCEDURE process_employee_audit_log();

INSERT INTO employees(name, salary) VALUES ('Poopy Harlow', 75000);

UPDATE employees SET salary=25000 WHERE salary < 25000;

SELECT E.name, LOGS.occurred_at AS time_stamp
		FROM 	employees AS E, employee_audit_log AS LOGS WHERE E.id = LOGS.employee_id;
