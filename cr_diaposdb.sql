CREATE TABLE box (
	box_id			INTEGER PRIMARY KEY		NOT NULL,
	box_name		TEXT					NULL,
);

CREATE TABLE event (
	box_id			INTEGER				 	NOT NULL,
	event_id 		INTEGER 				NOT NULL, 
  	event_year 		TEXT	 				NULL, 
	event_month 	TEXT 					NULL,
  	event_name 		TEXT 					NOT NULL,
  	event_nb		INTEGER					NOT NULL,
  	FOREIGN KEY(box_id) REFERENCES box(box_id),
  	PRIMARY KEY (box _id, event_id)
); 
  	
  	
CREATE TABLE sub (
	box_id			INTEGER				 	NOT NULL,
	event_id 		INTEGER 				NOT NULL, 
	sub_range		TEXT 	PRIMARY KEY 	NOT NULL, 
	sub_name		TEXT					NOT NULL,
	FOREIGN KEY(box_id) REFERENCES box(box_id),
  	FOREIGN KEY(event_id) REFERENCES event(event_id),
  	PRIMARY KEY (box _id, event_id, sub_range)
);  	
  				


