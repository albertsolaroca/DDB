DROP SCHEMA public CASCADE;
CREATE SCHEMA public
    AUTHORIZATION postgres;

CREATE TABLE students(
	id SERIAL NOT NULL PRIMARY KEY,
	snum TEXT NOT NULL,
	grade float NOT NULL,
	date_of_grading DATE NOT NULL,
	/*UNIQUE(snum,grade,date_of_grading)*/
);

INSERT INTO students VALUES(
	0,
	'S1234567',
	3.3,
	'2019-02-02'
);

INSERT INTO students VALUES(
	1,
	'S2468101',
	9.5,
	'2019-02-02'
);

INSERT INTO students VALUES(
	2,
	'S3432894',
	5.5,
	'2019-02-02'
);

INSERT INTO students VALUES(
	3,
	'S2468101',
	6.7,
	'2019-02-19'
);

INSERT INTO students VALUES(
	4,
	'S1234567',
	8.0,
	'2019-02-19'
);

INSERT INTO students VALUES(
	5,
	'S1234567',
	5.0,
	'2019-02-25'
);

INSERT INTO students VALUES(
	6,
	'S3432894',
	3.9,
	'2019-02-25'
);

SELECT snum,AVG(grade) AS average FROM students GROUP BY snum HAVING AVG(grade) > 5.5;