------------------------------------------------------------------
--				INSERT statements					            --
------------------------------------------------------------------

INSERT INTO PHARMACY(name, address, phone) VALUES ('Rite Aid', '318 Fifth Ave', 4124346603);
INSERT INTO PHARMACY(name, address, phone) VALUES ('Revco','242 5th Ave',4125662619);
INSERT INTO PHARMACY(name, address, phone) VALUES ('Mercy Health Center', '412 E.Commons', 4123234500);


INSERT INTO PHARMACEUTICAL_CO VALUES ('LIC1234', 'Johnson and Johnson', 4122217889);
INSERT INTO PHARMACEUTICAL_CO VALUES ('LIC2019', 'Pfizer', 6518900071);
INSERT INTO PHARMACEUTICAL_CO VALUES ('LIC1904', 'Roche', 4518764902);

INSERT INTO DRUG(name,formula,manufacturer_registration) VALUES('Tylenol', 'Tylenol Formula', 'LIC1234');
INSERT INTO DRUG(name,formula,manufacturer_registration) VALUES('Aspirin', 'Aspirin Formula', 'LIC2019');
INSERT INTO DRUG(name,formula,manufacturer_registration) VALUES('AspirinB', 'AspirinB Formula', 'LIC2019');
INSERT INTO DRUG(name,formula,manufacturer_registration) VALUES('Motrin', 'Motrin Formula', 'LIC1904');
INSERT INTO DRUG(name,formula,manufacturer_registration) VALUES('Allegra', 'Allegra Formula', 'LIC2019');

INSERT INTO DOCTOR VALUES (1200, 'PA', 'John', 'K.','Steward', 'Internal Medicine',	10);
INSERT INTO DOCTOR VALUES (1201, 'PA', 'Amber','T.', 'Calvin',	'Dermatology', 5);
INSERT INTO DOCTOR VALUES (1202, 'OH', 'Alicia',        'A.',         'Johnson',	 'Immunology',		20);
INSERT INTO DOCTOR VALUES (1203, 'PA', 'Thomas',        'J.',         'Kurt',       'Ophthalmology',	        15) ;
INSERT INTO DOCTOR VALUES (1204, 'PA', 'Daniel',        null,          'Robinson',   'Pediatrics',              9);


INSERT INTO PATIENT VALUES (765765666, 'Michael', 'F', 'Cao', '320 Fifth Avenue', TO_DATE('01-JAN-1940', 'DD-MON-YYYY'), 1203, 'PA' );
INSERT INTO PATIENT VALUES (888424247, 'Tom', 'J', 'Louis', '310 Fifth Avenue', TO_DATE('05-FEB-1921', 'DD-MON-YYYY'), 1203, 'PA' );
INSERT INTO PATIENT VALUES (546746535, 'Bill', 'T', 'Newton', '330 Fifth Avenue', TO_DATE('11-DEC-1920','DD-MON-YYYY'),  NULL, NULL );
INSERT INTO PATIENT VALUES (246577767, 'Richard', 'A', 'Kates', '340 Fifth Avenue', TO_DATE('03-OCT-1928','DD-MON-YYYY'),  1201, 'PA' );
INSERT INTO PATIENT VALUES (246345645, 'Mary', 'F', 'Missy', '350 Fifth Avenue', TO_DATE('04-MAR-1988','DD-MON-YYYY'),  NULL, NULL );
INSERT INTO PATIENT VALUES (343344645, 'Marian', 'F', 'Johnson', '10 Forbes Ave', '04-MAR-1974',  1200, 'PA' );
INSERT INTO PATIENT VALUES (746692837, 'Michael', 'M', 'Johnson', '100 Craig St.', '09-MAR-1981',  1202, 'OH' );
INSERT INTO PATIENT VALUES (927464820, 'Adrian', 'T', 'Newman', '100 Craig St.', '20-JUL-1980',  1200, 'PA' );

INSERT INTO PRESCRIPTION VALUES (1203,		'PA', 			888424247, 'Tylenol',  			20,      '01-JAN-2016');
INSERT INTO PRESCRIPTION VALUES (1200,      'PA', 		    765765666, 'Aspirin',           20,      '03-MAR-2016');
INSERT INTO PRESCRIPTION VALUES (1203,      'PA', 		    246577767, 'AspirinB',          20,      '11-FEB-2016');
INSERT INTO PRESCRIPTION VALUES (1202,      'OH', 	        546746535, 'Motrin',            10,      '12-JAN-2016');
INSERT INTO PRESCRIPTION VALUES (1201,      'PA', 		    765765666, 'Tylenol',           15,      '14-FEB-2016');
INSERT INTO PRESCRIPTION VALUES (1203,      'PA', 		    246577767, 'Allegra',            5,      '23-JAN-2016');
INSERT INTO PRESCRIPTION VALUES (1204,      'PA', 		    246345645, 'Motrin',             5,      '13-FEB-2016');
INSERT INTO PRESCRIPTION VALUES (1202,      'OH', 		    546746535, 'Aspirin',           10,      '15-JUL-2016');
INSERT INTO PRESCRIPTION VALUES (1200,      'PA', 		    246345645, 'Aspirin',           20,      '09-JUN-2016');
INSERT INTO PRESCRIPTION VALUES (1200,      'PA', 		    765765666, 'Aspirin',           10,      '11-JAN-2016');
INSERT INTO PRESCRIPTION VALUES (1200, 		'PA', 			765765666, 'Tylenol',			 2,		 '14-JAN-2015');
INSERT INTO PRESCRIPTION VALUES (1203, 		'PA', 			765765666, 'Tylenol',			 2,		 '14-JAN-2015');
INSERT INTO PRESCRIPTION VALUES (1203, 		'PA', 			927464820, 'Aspirin',			20,		 '20-JUL-2015');
INSERT INTO PRESCRIPTION VALUES (1202, 		'OH', 			927464820, 'Aspirin',			20,		 '01-JUL-2015');
INSERT INTO PRESCRIPTION VALUES (1202, 		'OH', 			746692837, 'Motrin',			 5,		 '20-SEP-2015');
INSERT INTO PRESCRIPTION VALUES (1204, 		'PA', 			343344645, 'Motrin',			 5,		 '20-OCT-2015');


INSERT INTO CONTRACT(store, manufacturer_registration,startdate, enddate) values ( 'Rite Aid',	'LIC1234',	TO_DATE('01-01-1999','MM-DD-YYYY'),TO_DATE('10-01-2018','MM-DD-YYYY'));
INSERT INTO CONTRACT(store, manufacturer_registration,startdate, enddate) values ( 'Revco', 'LIC1904', TO_DATE('02-03-2010','MM-DD-YYYY'),TO_DATE('01-01-2020','MM-DD-YYYY'));
INSERT INTO CONTRACT(store, manufacturer_registration,startdate, enddate) values ( 'Mercy Health Center', 'LIC1234', CURRENT_DATE, TO_DATE('12-31-2023', 'MM-DD-YYYY'));


INSERT INTO SELL VALUES ('Rite Aid', 8.29, 'Tylenol');
INSERT INTO SELL VALUES ('Rite Aid', 3.00, 'AspirinB');


commit;
