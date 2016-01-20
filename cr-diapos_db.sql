CREATE TABLE if not exists box (
	box_id			INTEGER PRIMARY KEY		NOT NULL,
	box_name		TEXT					NULL
);

CREATE TABLE if not exists event (
	box_id			INTEGER				 	NOT NULL,
	event_id 		TEXT 				NOT NULL, 
  	event_year 		TEXT 					NULL, 
	event_month 	TEXT 					NULL,
  	event_name 		TEXT 					NOT NULL,
  	event_nb		INTEGER					NOT NULL,
  	FOREIGN KEY(box_id) REFERENCES box(box_id),
  	PRIMARY KEY (box_id, event_id)
);

CREATE TABLE if not exists sub (
	box_id			INTEGER				NOT NULL,
	event_id 		TEXT 			NOT NULL, 
	sub_range		TEXT 				NOT NULL, 
	sub_name		TEXT				NOT NULL,
	FOREIGN KEY (box_id) REFERENCES box(box_id),
  	FOREIGN KEY (event_id) REFERENCES event(event_id),
  	PRIMARY KEY (box_id, event_id, sub_range)
);





