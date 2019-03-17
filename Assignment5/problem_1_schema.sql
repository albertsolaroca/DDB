DROP SCHEMA public CASCADE;

CREATE SCHEMA public;

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

INSERT INTO fields
(number, land_area, type)
VALUES
(1, 2.5, 0),
(2, 40.0, 1),
(3, 3.2, 0),
(4, 0.75, 0),
(5, 1.75, 1);

INSERT INTO crops
(id, variety, species, genus, avg_yield, germination_period_days)
VALUES
(1, 'SS2742', 'mays', 'Zea', 0.5, 14),
(2, 'calabrese', 'oleracea', 'Brassica', 0.25, 21),
(3, 'concord', 'labrusca', 'Vitis', 1.25, 31),
(4, 'atlantic', 'tuberosum', 'Solanum', 2.0, 12);

INSERT INTO annual_crops
(crop_id, growth_period_days)
VALUES
(1, 75),
(2, 55),
(4, 70);

INSERT INTO perennial_crops
(crop_id, age)
VALUES
(3, 6);

INSERT INTO crop_field
(id, field_number, crop_id, planting_date, harvest_date)
VALUES
(1, 1, 1, 'March 4, 2019', NULL),
(2, 3, 2, 'February 3, 2019', 'March 14, 2019'),
(3, 4, 3, 'April 24, 2012', NULL),
(4, 3, 4, 'March 17, 2019', NULL);

INSERT INTO fertilizer_mixes
(crop_field_id, nitrogen_percent, phosphorus_percent, potassium_percent, usage_per_sqkm)
VALUES
(1, 0.50, 0.30, 0.20, 2000.0),
(2, 0.45, 0.25, 0.30, 1245.0),
(3, 0.60, 0.15, 0.25, 630.0),
(4, 0.55, 0.10, 0.35, 3200.0);

INSERT INTO fertilizer_applications
(crop_field_id, application_date, volume)
VALUES
(1, 'March 4, 2019', 2500.0),
(1, 'March 25, 2019', 1800.0),
(2, 'February 8, 2019', 1245.0),
(2, 'February 25, 2019', 3127.0),
(3, 'March 5, 2013', 630.0),
(3, 'March 5, 2014', 640.0),
(3, 'March 5, 2015', 621.0),
(3, 'March 5, 2016', 550.0),
(3, 'March 5, 2017', 711.0),
(3, 'March 5, 2018', 420.0),
(4, 'March 15, 2019', 3345.2);

INSERT INTO animal_species
(id, genus, species)
VALUES
(1, 'Bos', 'taurus'),
(2, 'Sus', 'scrofa domesticus'),
(3, 'Bos', 'grunniens');

INSERT INTO animals
(tag_number, pasture_id, animal_species_id, weight)
VALUES
('SF2483', 2, 1, 272.0),
('SF2484', 2, 1, 315.0),
('RB1175', 2, 1, 195.0),
('PS0001', 2, 2, 95.0),
('PS0341', 2, 2, 123.0),
('RF7822', 2, 2, 204.1),
('JS0020', 2, 2, 157.5),
('YK01', 5, 3, 367.0),
('YK02', 5, 3, 435.0),
('YK03', 5, 3, 562.0),
('YK04', 5, 3, 255.0);

INSERT INTO animal_crop_diet
(animal_species_id, crop_id)
VALUES
(1, 1),
(2, 1),
(2, 4),
(3, 4);

SELECT genus,species,variety,growth_period_days
		FROM (crops JOIN annual_crops ON crops.id=annual_crops.crop_id);

SELECT animal_species.genus, animal_species.species, crops.genus,crops.species,crops.variety 
	FROM ((animal_species JOIN animal_crop_diet ON animal_species.id = animal_crop_diet.animal_species_id)
	JOIN crops ON animal_crop_diet.crop_id = crops.id);

SELECT tag_number,  species, weight
	FROM (animals JOIN animal_species ON animals.animal_species_id = animal_species.id)
	WHERE weight > 200;

SELECT COUNT(*), SUM(volume)
	FROM fertilizer_applications
	GROUP BY crop_field_id
	HAVING SUM(volume) > 4000;
	
SELECT AVG(avg_yield)
	FROM (crops JOIN crop_field ON crops.id = crop_field.crop_id)
	WHERE crop_field.field_number = 3;
	
SELECT AVG(weight)
	FROM (animals JOIN animal_species ON animals.animal_species_id = animal_species.id)
	WHERE animal_species.genus = 'Bos';

SELECT SUM(nitrogen_percent*volume)
	FROM (fertilizer_mixes JOIN fertilizer_applications ON fertilizer_mixes.crop_field_id = fertilizer_applications.crop_field_id);