CREATE TABLE fields (
	number SERIAL NOT NULL PRIMARY KEY,
	land_area REAL NOT NULL,
	type INTEGER NOT NULL /* 0 = crop field, 1 = pasture */
);

CREATE TABLE crops (
	id SERIAL NOT NULL PRIMARY KEY,
	variety TEXT NOT NULL,
	species TEXT NOT NULL,
	genus TEXT NOT NULL,
	avg_yield REAL NOT NULL,
	germination_period_days INTEGER NOT NULL,
	UNIQUE (variety, species, genus)
);

CREATE TABLE annual_crops (
	crop_id INTEGER NOT NULL PRIMARY KEY,
	growth_period_days INTEGER NOT NULL,
	FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

CREATE TABLE perennial_crops (
	crop_id INTEGER NOT NULL PRIMARY KEY,
	age INTEGER NOT NULL,
	FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

CREATE TABLE crop_field (
	id SERIAL NOT NULL PRIMARY KEY,
	field_number INTEGER NOT NULL,
	crop_id INTEGER NOT NULL,
	planting_date DATE NOT NULL DEFAULT CURRENT_DATE,
	harvest_date DATE,
	FOREIGN KEY (field_number) REFERENCES fields(number) ON DELETE CASCADE,
	FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

CREATE TABLE fertilizer_mixes (
	crop_field_id INTEGER NOT NULL PRIMARY KEY,
	nitrogen_percent REAL NOT NULL,
	phosphorus_percent REAL NOT NULL,
	potassium_percent REAL NOT NULL,
	usage_per_sqkm REAL NOT NULL,
	UNIQUE (nitrogen_percent, phosphorus_percent, potassium_percent),
	FOREIGN KEY (crop_field_id) REFERENCES crop_field(id) ON DELETE CASCADE
);

CREATE TABLE fertilizer_applications (
	id SERIAL NOT NULL PRIMARY KEY,
	crop_field_id INTEGER NOT NULL,
	application_date DATE NOT NULL DEFAULT CURRENT_DATE,
	volume REAL NOT NULL,
	FOREIGN KEY (crop_field_id) REFERENCES crop_field(id) ON DELETE CASCADE
);

CREATE TABLE animal_species (
	id SERIAL NOT NULL PRIMARY KEY,
	genus TEXT NOT NULL,
	species TEXT NOT NULL,
	UNIQUE (genus, species)
);

CREATE TABLE animals (
	tag_number TEXT NOT NULL PRIMARY KEY,
	pasture_id INTEGER NOT NULL,
	animal_species_id INTEGER NOT NULL,
	weight REAL NOT NULL,
	FOREIGN KEY (pasture_id) REFERENCES fields(number) ON DELETE CASCADE,
	FOREIGN KEY (animal_species_id) REFERENCES animal_species(id) ON DELETE CASCADE
);

CREATE TABLE animal_crop_diet (
	id SERIAL NOT NULL PRIMARY KEY,
	animal_species_id INTEGER NOT NULL,
	crop_id INTEGER NOT NULL,
	FOREIGN KEY (animal_species_id) REFERENCES animal_species(id) ON DELETE CASCADE,
	FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

INSERT INTO crops VALUES(
	0,
	'SS2742',
	'Zea',
	'Mays',
	0.5,
	14
);

INSERT INTO annual_crops VALUES(
	0,
	75
);

INSERT INTO fields VALUES(
	1,
	2.5,
	0
);
INSERT INTO crop_field VALUES(
	1,
	1,
	0,
	'2019-03-04',
	'2019-05-18'
);

INSERT INTO fertilizer_mixes VALUES(
	1,
	50,
	30,
	20,
	2000
);

INSERT INTO fertilizer_applications VALUES(
	0,
	1,
	'2019-03-04',
	2500
);

INSERT INTO fertilizer_applications VALUES(
	1,
	1,
	'2019-03-25',
	1800
);

INSERT INTO fields VALUES(
	2,
	40,
	1
);

INSERT INTO animal_species VALUES(
	0,
	'Bovinae',
	'taurus'
);

INSERT INTO animals VALUES(
	'SF2483',
	2,
	0,
	272
);

INSERT INTO animals VALUES(
	'SF2484',
	2,
	0,
	315
);

INSERT INTO animals VALUES(
	'RB1175',
	2,
	0,
	195
);

INSERT INTO animal_crop_diet VALUES(
	0,
	0,
	0
);

INSERT INTO fields VALUES(
	3,
	3.2,
	0
);

INSERT INTO crops VALUES(
	1,
	'calabrese',
	'Brassica',
	'oleracea',
	0.25,
	21
);

INSERT INTO annual_crops VALUES(
	1,
	55
);

INSERT INTO crop_field VALUES(
	3,
	3,
	1,
	'2019-02-03',
	'2019-03-14'
);

INSERT INTO fertilizer_mixes VALUES(
	3,
	45,
	25,
	30,
	1245
);

INSERT INTO fertilizer_applications VALUES(
	2,
	3,
	'2019-02-08',
	750
);

INSERT INTO fertilizer_applications VALUES(
	3,
	3,
	'2019-02-25',
	3127
);

SELECT species,genus,variety FROM crops;
SELECT species,genus,variety FROM crops WHERE avg_yield > 0.3;
SELECT SUM(volume) FROM fertilizer_applications WHERE crop_field_id=3;
UPDATE animals SET weight=253 WHERE tag_number = 'RB1175';
UPDATE crop_field SET harvest_date='2019-04-17' WHERE crop_id=0;
DELETE FROM animals WHERE tag_number='SF2484';