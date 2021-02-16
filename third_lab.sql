CREATE DATABASE IF NOT EXISTS spotify
CHARACTER SET utf8
COLLATE utf8_general_ci;
USE spotify;

DROP TABLE IF EXISTS user_has_playlist;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS subscription;
DROP TABLE IF EXISTS credentials;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS label;
DROP TABLE IF EXISTS band;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS podcast;
DROP TABLE IF EXISTS playlist;


CREATE TABLE label (
	id INT  AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) UNIQUE NOT NULL,
    trademark_year DATE 
)ENGINE = INNODB;
CREATE TABLE band (
	id INT  AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    num_of_artists INT 
)ENGINE = INNODB;
CREATE TABLE artist (
	id INT  AUTO_INCREMENT PRIMARY KEY,
    label_id INT,
    band_id INT,
    name VARCHAR(100) NOT NULL,
    monthly_listens INT NOT NULL,
    followers INT NOT NULL
)ENGINE = INNODB;
CREATE TABLE album (
    id INT AUTO_INCREMENT PRIMARY KEY,
    artist_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    number_of_songs INT NOT NULL
)ENGINE = INNODB;
CREATE TABLE genre (
	id INT  AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) UNIQUE NOT NULL
)ENGINE = INNODB;
CREATE TABLE song (
    id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
    album_id INT NOT NULL,
    artist_id INT NOT NULL,
    playlist_id INT,
    genre_id INT NOT NULL,
    duration_in_seconds INT NOT NULL
)ENGINE = INNODB;
CREATE TABLE podcast(
	id INT AUTO_INCREMENT PRIMARY KEY,
    playlist_id INT,
    name VARCHAR(45) NOT NULL
)ENGINE = INNODB;
CREATE TABLE playlist(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    last_played DATE,
    last_updated DATE NOT NULL,
    num_of_likes INT ,
    num_of_songs INT,
    num_of_podcasts INT
)ENGINE = INNODB;
CREATE TABLE user_has_playlist(
	playlist_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY(playlist_id, user_id)
)ENGINE = INNODB;
CREATE TABLE subscription(
	id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(45) UNIQUE NOT NULL
)ENGINE = INNODB;
CREATE TABLE credentials(
	id INT AUTO_INCREMENT PRIMARY KEY,
    bcrypt_password VARCHAR(45) NOT NULL
)ENGINE = INNODB;
CREATE TABLE user(
	id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(45) NOT NULL,
    email varchar(45) NOT NULL,
    subscription_end_date DATE,
    subscription_id INT,
    credentials_id INT NOT NULL
)ENGINE = INNODB;
ALTER TABLE artist
	ADD CONSTRAINT FK_artist_label
	FOREIGN KEY (label_id)
	REFERENCES label (id),
    ADD CONSTRAINT FK_artist_band
	FOREIGN KEY (band_id)
	REFERENCES band(id);
ALTER TABLE album
	ADD CONSTRAINT FK_album_artist
	FOREIGN KEY (artist_id)
	REFERENCES artist (id);
ALTER TABLE song
	ADD CONSTRAINT FK_song_album
	FOREIGN KEY (album_id)
	REFERENCES album (id),
    ADD CONSTRAINT FK_song_artist
	FOREIGN KEY (artist_id)
	REFERENCES artist(id),
    ADD CONSTRAINT FK_song_playlist
	FOREIGN KEY (playlist_id)
	REFERENCES playlist (id),
    ADD CONSTRAINT FK_song_genre
	FOREIGN KEY (genre_id)
	REFERENCES genre(id);
ALTER TABLE podcast
	ADD CONSTRAINT FK_podcast_playlist
	FOREIGN KEY (playlist_id)
	REFERENCES playlist (id);
ALTER TABLE user_has_playlist
    ADD CONSTRAINT FK_user_has_playlist_playlist
	FOREIGN KEY (playlist_id)
	REFERENCES playlist (id),
    ADD CONSTRAINT FK_user_has_playlist_user
	FOREIGN KEY (user_id)
	REFERENCES user(id);
ALTER TABLE user
    ADD CONSTRAINT FK_user_credentials
	FOREIGN KEY (credentials_id)
	REFERENCES credentials (id),
    ADD CONSTRAINT FK_user_subscription
	FOREIGN KEY (subscription_id)
	REFERENCES subscription(id);
	
CREATE INDEX account
ON user (username);
CREATE INDEX artist
ON artist (name);

INSERT INTO label( name, trademark_year) VALUES
("GG", "2020-10-08"),
("Abet", "2004-12-18"),
("Alligator Records", "2003-03-11"),
("Lava", "2009-11-10"),
("Legacy", "2018-07-29"),
("Rhino", "2003-03-07"),
("Interscope", "2016-01-05"),
("Hollywood records", "2018-06-15"),
("Immortal", "2000-04-30"),
("Red ink records", "2017-08-01");

INSERT INTO band(name,num_of_artists) VALUES
("Skillet", 4),
("Oomph", 3),
("Rammstein", 3),
("Arctic Monkey", 4),
("The Neighbourhood", 4),
("Coldplay", 2),
("Cage the elephant", 6),
("Green Day", 3),
("Metallica", 5),
("Imagine Dragons", 4);

INSERT INTO artist(label_id,band_id, name,monthly_listens,followers) VALUES
(null, null,"Michael Jackson",100000,100234),
(10, 2,"Akvarium",200000,26000),
(8, null,"AC/DC",700000,230000),
(4, null,"Agatha Kristie",870000,230400),
(2, null,"Bastille",234567,100900),
(null, null,"Arcade FIre",450000,500000),
(1, 6,"John Denver ",236000,126000),
(8, null,"Bruno Mars",343000,236000),
(3, null,"Girl in red",342000,130000),
(8, null,"Lana Del Rey",459000,120000);

INSERT INTO genre(name)  VALUES
("rap"),
("rock"),
("trap"),
("rnb"),
("pop"),
("metal"),
("alt-rock"),
("jazz"),
("indie"),
("blues");

INSERT INTO album(artist_id, name,release_date,number_of_songs) VALUES
(1, "Dark side of the moon","2001-11-10",12),
(1, "The XX","2014-03-31",17),
(2, "Chinese Democracy","2010-06-03",16),
(3, "Use your Illusion","2008-02-10",15),
(5, "Use your Illusion 2","2015-01-22",16),
(7, "An awesome wave","2006-11-23",11),
(10, "After the disco","2012-05-20",12),
(6, "AM","2020-11-18",17),
(9, "Gameshow","2018-10-12",5),
(4, "The English Riviera","2018-02-17",20);



INSERT INTO podcast(name) VALUES
("Let's talk"),
("News"),
("Voice of GB"),
("Los Arboles"),
("Ciclo"),
("Song machine"),
("Seans"),
("Sumno"),
("Fata Morgana"),
("Enok");

INSERT INTO playlist(name, last_played,last_updated,num_of_likes,num_of_songs,num_of_podcasts) VALUES
("Feelin myself","2020-11-20","2020-11-18",3,5,null),
("Sad vibes","2020-11-12","2020-11-07",80,123,null),
("Rock","2020-10-31","2020-10-12",39,58,1),
("Chill","2020-12-05","2020-11-25",9,6,null),
("MJ","2020-11-20","2020-11-18",76,67,null),
("Good night","2020-11-20","2020-11-18",34,65,null),
("Songs to sing","2020-11-20","2020-11-18",77,78,null),
("Deutsch","2020-11-20","2020-11-18",54,34,null),
("Work out","2020-11-20","2020-11-18",33,50,null),
("Soundtracks","2020-11-20","2020-11-18",2,90,null);

INSERT INTO song(name,album_id,artist_id,playlist_id ,genre_id,duration_in_seconds) VALUES
("The Moss",10,4,1,1,210),
("Take a walk",10,4,1,1,219),
("Joan of Ark",6,7,2,2,226),
("November rain",8,6,1,1,197),
("Listerine",9,9,3,9,234),
("Bohemian Rhapsody",5,5,3,5,210),
("Welcome to the Jungle",5,5,3,5,231),
("Us and Them",1,1,1,5,187),
("Patience",1,1,1,5,246),
("Back in Black",7,10,7,5,209);

INSERT INTO subscription(type) VALUES
("usual"),
("student"),
("faily");
INSERT INTO credentials(bcrypt_password) VALUES
("dtw67d"),
("29oke6"),
("relax2002"),
("lovejackson"),
("rr456y89"),
("olalaba"),
("deathnote536"),
("dfer345652"),
("dgdj2789"),
("yeywuj8");

INSERT INTO user(username,email,subscription_end_date,subscription_id,credentials_id) VALUES
("diana","diana@gmail.com",null,null,1),
("kozlova","kozlova@gmail.com",null,null,2),
("mykyta","mykyta@gmail.com",null,null,3),
("anastasiia","anastasiiak@gmail.com",null,null,4),
("john","johnf@gmail.com",null,null,5),
("vitalii","vitaliik@gmail.com",null,null,6),
("andrew","andrewk@gmail.com",null,null,7),
("khoma","khoma@gmail.com",null,null,8),
("max","max@gmail.com",null,null,9),
("name","nameb@gmail.com",null,null,10);

INSERT INTO user_has_playlist(playlist_id,user_id) VALUES
(1,1),
(1,2),
(1,3),
(2,4),
(4,5),
(3,6),
(5,6),
(4,7),
(2,8),
(3,9),
(7,10);
