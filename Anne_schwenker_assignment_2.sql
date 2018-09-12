drop table if exists moviereviews;
drop table if exists movie_reviews;
Create Table movie_reviews(  
movie_title varchar(225),
rating integer,
review varchar(225),
reviewer_name varchar(50)
);

INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('The Incredibles 2', 5, 'It was funny','Charlotte');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('The Incredibles 2', 5, 'It was awesome. exciting. action packed. funny','Ruby');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('The Incredibles 2', 4, 'Clever, humopr for adults and Kids','Sarah');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('The Incredibles 2', 3, 'Action packed, entertaining','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('The Incredibles 2', 2, 'Pales in comparison to the first','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Baby Driver', 5, 'Great Plot. Clever Story Telling. Beautiful Action Sequences. Great Soundtract','Sarah' );
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Baby Driver', 4, 'Funny. Suspenseful.','Kate');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Baby Driver', 5, 'Great chase sequences.','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Baby Driver', 4, 'A nontraditional love story.','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Baby Driver', 4, 'Amazing soundtrack. I would watch this over and over.','Iris');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('My Cousin Vinny', 5, 'I wore a ridiculous suit for you','Kate');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('MY Cousin Vinny', 4, 'It is a great movie. Marisa Tomei came into her own in that movie','Kesha');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('My Cousin Vinny', 5, 'So funny, I laugh out loud every time','Sarah');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('My Cousin Vinny', 5, 'Marisa Tomei is amazing','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('My Cousin Vinny', 5, 'funny and endearing','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Breakfast Club', 5, 'Sound Track is epic','Kesha');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Breakfast Club', 5, 'When I first went to see this movie, I asked if we could go see if again. like right now','Sarah');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Breakfast Club', 4, 'set the stage for many movies to come','Kate');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Breakfast Club', 3, 'A classic','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Breakfast Club', 4, 'Sweet coming of age story','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Mama Mia', 5, 'Sweet mother daughter tale','Kesha');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Mama Mia', 5, 'A definite classic','Sarah');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Mama Mia', 3, 'Catchy songs','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Mama Mia', 3, 'Beautifully set','Kate');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Mama Mia', 4, 'A love story for everyone','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Oceans 11', 3, 'Everybody loves a good heist','Alice');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Oceans 11', 4, 'makes me want to rob a bank','Kesha');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Oceans 11', 4, 'Not enough strong female leads','Rosie');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Oceans 11', 3, 'Entertaining and engaging','Kate');
INSERT INTO movie_reviews (movie_title,rating,review,reviewer_name)
VALUES ('Oceans 11', 5, 'Funny and Fast paced','Sarah');