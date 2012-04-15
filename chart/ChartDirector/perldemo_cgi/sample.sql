# phpMyAdmin MySQL-Dump
# version 2.2.6
# http://phpwizard.net/phpMyAdmin/
# http://www.phpmyadmin.net/ (download page)
#
# Host: localhost
# Generation Time: Jun 03, 2002 at 10:16 PM
# Server version: 3.23.49
# PHP Version: 4.2.0
# Database : `sample`
# --------------------------------------------------------

#
# Table structure for table `revenue`
#

CREATE TABLE revenue (
  ID int(11) NOT NULL auto_increment,
  TimeStamp date NOT NULL default '0000-00-00',
  Software double NOT NULL default '0',
  Hardware double NOT NULL default '0',
  Services double NOT NULL default '0',
  PRIMARY KEY  (ID),
  KEY TimeStamp (TimeStamp)
) TYPE=MyISAM;

#
# Dumping data for table `revenue`
#

INSERT INTO revenue VALUES (949, '1990-01-01', '121', '103', '108');
INSERT INTO revenue VALUES (950, '1990-02-01', '126', '131', '121');
INSERT INTO revenue VALUES (951, '1990-03-01', '87', '146', '137');
INSERT INTO revenue VALUES (952, '1990-04-01', '127', '55', '109');
INSERT INTO revenue VALUES (953, '1990-05-01', '76', '78', '133');
INSERT INTO revenue VALUES (954, '1990-06-01', '73', '120', '148');
INSERT INTO revenue VALUES (955, '1990-07-01', '118', '52', '108');
INSERT INTO revenue VALUES (956, '1990-08-01', '55', '80', '88');
INSERT INTO revenue VALUES (957, '1990-09-01', '78', '66', '66');
INSERT INTO revenue VALUES (958, '1990-10-01', '83', '113', '71');
INSERT INTO revenue VALUES (959, '1990-11-01', '141', '76', '129');
INSERT INTO revenue VALUES (960, '1990-12-01', '113', '93', '60');
INSERT INTO revenue VALUES (961, '1991-01-01', '63', '125', '170');
INSERT INTO revenue VALUES (962, '1991-02-01', '116', '102', '109');
INSERT INTO revenue VALUES (963, '1991-03-01', '67', '107', '104');
INSERT INTO revenue VALUES (964, '1991-04-01', '135', '125', '79');
INSERT INTO revenue VALUES (965, '1991-05-01', '73', '154', '115');
INSERT INTO revenue VALUES (966, '1991-06-01', '85', '69', '73');
INSERT INTO revenue VALUES (967, '1991-07-01', '139', '125', '159');
INSERT INTO revenue VALUES (968, '1991-08-01', '103', '78', '145');
INSERT INTO revenue VALUES (969, '1991-09-01', '108', '115', '119');
INSERT INTO revenue VALUES (970, '1991-10-01', '80', '171', '72');
INSERT INTO revenue VALUES (971, '1991-11-01', '93', '141', '91');
INSERT INTO revenue VALUES (972, '1991-12-01', '96', '88', '118');
INSERT INTO revenue VALUES (973, '1992-01-01', '102', '196', '157');
INSERT INTO revenue VALUES (974, '1992-02-01', '84', '163', '131');
INSERT INTO revenue VALUES (975, '1992-03-01', '122', '93', '141');
INSERT INTO revenue VALUES (976, '1992-04-01', '122', '151', '205');
INSERT INTO revenue VALUES (977, '1992-05-01', '169', '176', '216');
INSERT INTO revenue VALUES (978, '1992-06-01', '98', '133', '150');
INSERT INTO revenue VALUES (979, '1992-07-01', '105', '161', '143');
INSERT INTO revenue VALUES (980, '1992-08-01', '114', '94', '148');
INSERT INTO revenue VALUES (981, '1992-09-01', '141', '99', '171');
INSERT INTO revenue VALUES (982, '1992-10-01', '188', '101', '210');
INSERT INTO revenue VALUES (983, '1992-11-01', '139', '89', '89');
INSERT INTO revenue VALUES (984, '1992-12-01', '153', '103', '139');
INSERT INTO revenue VALUES (985, '1993-01-01', '215', '102', '196');
INSERT INTO revenue VALUES (986, '1993-02-01', '134', '257', '225');
INSERT INTO revenue VALUES (987, '1993-03-01', '148', '161', '250');
INSERT INTO revenue VALUES (988, '1993-04-01', '118', '100', '161');
INSERT INTO revenue VALUES (989, '1993-05-01', '124', '152', '155');
INSERT INTO revenue VALUES (990, '1993-06-01', '253', '183', '244');
INSERT INTO revenue VALUES (991, '1993-07-01', '217', '207', '172');
INSERT INTO revenue VALUES (992, '1993-08-01', '95', '176', '217');
INSERT INTO revenue VALUES (993, '1993-09-01', '203', '243', '238');
INSERT INTO revenue VALUES (994, '1993-10-01', '207', '156', '89');
INSERT INTO revenue VALUES (995, '1993-11-01', '105', '134', '198');
INSERT INTO revenue VALUES (996, '1993-12-01', '151', '142', '220');
INSERT INTO revenue VALUES (997, '1994-01-01', '230', '181', '184');
INSERT INTO revenue VALUES (998, '1994-02-01', '172', '284', '157');
INSERT INTO revenue VALUES (999, '1994-03-01', '258', '278', '161');
INSERT INTO revenue VALUES (1000, '1994-04-01', '194', '120', '189');
INSERT INTO revenue VALUES (1001, '1994-05-01', '135', '227', '302');
INSERT INTO revenue VALUES (1002, '1994-06-01', '235', '228', '291');
INSERT INTO revenue VALUES (1003, '1994-07-01', '195', '261', '155');
INSERT INTO revenue VALUES (1004, '1994-08-01', '224', '147', '120');
INSERT INTO revenue VALUES (1005, '1994-09-01', '152', '301', '279');
INSERT INTO revenue VALUES (1006, '1994-10-01', '183', '144', '171');
INSERT INTO revenue VALUES (1007, '1994-11-01', '146', '247', '208');
INSERT INTO revenue VALUES (1008, '1994-12-01', '192', '164', '260');
INSERT INTO revenue VALUES (1009, '1995-01-01', '127', '162', '218');
INSERT INTO revenue VALUES (1010, '1995-02-01', '306', '160', '189');
INSERT INTO revenue VALUES (1011, '1995-03-01', '207', '237', '263');
INSERT INTO revenue VALUES (1012, '1995-04-01', '215', '267', '210');
INSERT INTO revenue VALUES (1013, '1995-05-01', '261', '176', '364');
INSERT INTO revenue VALUES (1014, '1995-06-01', '325', '371', '189');
INSERT INTO revenue VALUES (1015, '1995-07-01', '297', '152', '152');
INSERT INTO revenue VALUES (1016, '1995-08-01', '198', '325', '201');
INSERT INTO revenue VALUES (1017, '1995-09-01', '305', '288', '226');
INSERT INTO revenue VALUES (1018, '1995-10-01', '269', '311', '238');
INSERT INTO revenue VALUES (1019, '1995-11-01', '194', '216', '128');
INSERT INTO revenue VALUES (1020, '1995-12-01', '275', '191', '251');
INSERT INTO revenue VALUES (1021, '1996-01-01', '273', '171', '284');
INSERT INTO revenue VALUES (1022, '1996-02-01', '443', '326', '308');
INSERT INTO revenue VALUES (1023, '1996-03-01', '155', '195', '275');
INSERT INTO revenue VALUES (1024, '1996-04-01', '270', '167', '242');
INSERT INTO revenue VALUES (1025, '1996-05-01', '421', '379', '321');
INSERT INTO revenue VALUES (1026, '1996-06-01', '222', '376', '433');
INSERT INTO revenue VALUES (1027, '1996-07-01', '386', '294', '211');
INSERT INTO revenue VALUES (1028, '1996-08-01', '154', '347', '437');
INSERT INTO revenue VALUES (1029, '1996-09-01', '323', '391', '161');
INSERT INTO revenue VALUES (1030, '1996-10-01', '302', '368', '284');
INSERT INTO revenue VALUES (1031, '1996-11-01', '377', '323', '344');
INSERT INTO revenue VALUES (1032, '1996-12-01', '356', '368', '207');
INSERT INTO revenue VALUES (1033, '1997-01-01', '473', '258', '245');
INSERT INTO revenue VALUES (1034, '1997-02-01', '435', '417', '456');
INSERT INTO revenue VALUES (1035, '1997-03-01', '500', '259', '307');
INSERT INTO revenue VALUES (1036, '1997-04-01', '405', '229', '201');
INSERT INTO revenue VALUES (1037, '1997-05-01', '246', '357', '528');
INSERT INTO revenue VALUES (1038, '1997-06-01', '421', '193', '411');
INSERT INTO revenue VALUES (1039, '1997-07-01', '456', '307', '327');
INSERT INTO revenue VALUES (1040, '1997-08-01', '241', '279', '210');
INSERT INTO revenue VALUES (1041, '1997-09-01', '485', '293', '464');
INSERT INTO revenue VALUES (1042, '1997-10-01', '341', '393', '190');
INSERT INTO revenue VALUES (1043, '1997-11-01', '404', '524', '476');
INSERT INTO revenue VALUES (1044, '1997-12-01', '293', '394', '393');
INSERT INTO revenue VALUES (1045, '1998-01-01', '326', '451', '434');
INSERT INTO revenue VALUES (1046, '1998-02-01', '633', '438', '466');
INSERT INTO revenue VALUES (1047, '1998-03-01', '496', '281', '300');
INSERT INTO revenue VALUES (1048, '1998-04-01', '404', '396', '359');
INSERT INTO revenue VALUES (1049, '1998-05-01', '234', '412', '533');
INSERT INTO revenue VALUES (1050, '1998-06-01', '588', '571', '391');
INSERT INTO revenue VALUES (1051, '1998-07-01', '449', '446', '484');
INSERT INTO revenue VALUES (1052, '1998-08-01', '333', '628', '356');
INSERT INTO revenue VALUES (1053, '1998-09-01', '307', '306', '397');
INSERT INTO revenue VALUES (1054, '1998-10-01', '474', '249', '234');
INSERT INTO revenue VALUES (1055, '1998-11-01', '339', '575', '601');
INSERT INTO revenue VALUES (1056, '1998-12-01', '285', '492', '637');
INSERT INTO revenue VALUES (1057, '1999-01-01', '552', '571', '573');
INSERT INTO revenue VALUES (1058, '1999-02-01', '683', '396', '608');
INSERT INTO revenue VALUES (1059, '1999-03-01', '371', '635', '722');
INSERT INTO revenue VALUES (1060, '1999-04-01', '528', '594', '494');
INSERT INTO revenue VALUES (1061, '1999-05-01', '447', '285', '519');
INSERT INTO revenue VALUES (1062, '1999-06-01', '758', '265', '593');
INSERT INTO revenue VALUES (1063, '1999-07-01', '420', '764', '408');
INSERT INTO revenue VALUES (1064, '1999-08-01', '564', '620', '396');
INSERT INTO revenue VALUES (1065, '1999-09-01', '387', '676', '655');
INSERT INTO revenue VALUES (1066, '1999-10-01', '327', '758', '350');
INSERT INTO revenue VALUES (1067, '1999-11-01', '639', '660', '481');
INSERT INTO revenue VALUES (1068, '1999-12-01', '471', '319', '333');
INSERT INTO revenue VALUES (1069, '2000-01-01', '567', '601', '349');
INSERT INTO revenue VALUES (1070, '2000-02-01', '417', '623', '522');
INSERT INTO revenue VALUES (1071, '2000-03-01', '707', '535', '648');
INSERT INTO revenue VALUES (1072, '2000-04-01', '345', '377', '400');
INSERT INTO revenue VALUES (1073, '2000-05-01', '336', '738', '832');
INSERT INTO revenue VALUES (1074, '2000-06-01', '352', '697', '514');
INSERT INTO revenue VALUES (1075, '2000-07-01', '437', '852', '403');
INSERT INTO revenue VALUES (1076, '2000-08-01', '386', '511', '314');
INSERT INTO revenue VALUES (1077, '2000-09-01', '900', '427', '568');
INSERT INTO revenue VALUES (1078, '2000-10-01', '636', '393', '866');
INSERT INTO revenue VALUES (1079, '2000-11-01', '893', '599', '758');
INSERT INTO revenue VALUES (1080, '2000-12-01', '595', '712', '784');
INSERT INTO revenue VALUES (1081, '2001-01-01', '777', '1083', '540');
INSERT INTO revenue VALUES (1082, '2001-02-01', '1003', '422', '470');
INSERT INTO revenue VALUES (1083, '2001-03-01', '549', '864', '837');
INSERT INTO revenue VALUES (1084, '2001-04-01', '492', '557', '823');
INSERT INTO revenue VALUES (1085, '2001-05-01', '1085', '940', '672');
INSERT INTO revenue VALUES (1086, '2001-06-01', '400', '641', '681');
INSERT INTO revenue VALUES (1087, '2001-07-01', '488', '1093', '576');
INSERT INTO revenue VALUES (1088, '2001-08-01', '959', '1018', '1102');
INSERT INTO revenue VALUES (1089, '2001-09-01', '743', '1029', '797');
INSERT INTO revenue VALUES (1090, '2001-10-01', '486', '947', '867');
INSERT INTO revenue VALUES (1091, '2001-11-01', '723', '920', '791');
INSERT INTO revenue VALUES (1092, '2001-12-01', '1015', '657', '1089');

