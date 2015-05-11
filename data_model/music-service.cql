-- unique node keyspace configuration
CREATE KEYSPACE music
WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };


-- multinode keyspace configuration
CREATE KEYSPACE music
WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 3 };


-- a simple data table to store songs 
CREATE TABLE songs (
  id varchar PRIMARY KEY,
  title text,
  album text,
  artist text,
  data blob
 );
 
 INSERT INTO songs (id, title, artist, album) 
 VALUES ('song-1','Ojo Rojo', 'Fu Manchu', 'No One Rides for Free');
 
 INSERT INTO songs (id, title, artist, album)
 VALUES ('song-2','Enter Sandman', 'Metallica', 'Black');
 
 INSERT INTO songs (id, title, artist, album)
 VALUES ('song-3','The Unforgiven', 'Metallica', 'Black');
 
 INSERT INTO songs (id, title, artist, album)
 VALUES ('song-4','Run to the hills', 'Iron Maiden', 'Collections');
 
 INSERT INTO songs (id, title, artist, album)
 VALUES ('song-6','The Spirit Carries On', 'Dream Theater', 'Collection Best');
 
 INSERT INTO songs (id, title, artist, album)
 VALUES ('song-8','Make Believe', 'Angra', 'Holy Land');
 
  
-- a playlist table to relate songs
 
 CREATE TABLE playlists (
  id varchar,
  song_order int,
  song_id varchar,
  title text,
  album text,
  artist text,
  PRIMARY KEY (id, song_order ) );
 

-- see table and schema details
DESC TABLES;
DESC SCHEMA;
 
 
-- inserting some playlist data
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-1', 4,'song-1','Ojo Rojo', 'Fu Manchu', 'No One Rides for Free');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-1', 2,'song-2','Enter Sandman', 'Metallica', 'Black');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-1', 1,'song-3','The Unforgiven', 'Metallica', 'Black');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-1', 1,'song-4','Run to the hills', 'Iron Maiden', 'Collections');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-2', 4,'song-1','Ojo Rojo', 'Fu Manchu', 'No One Rides for Free');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-2', 3,'song-5','The Looking Glass', 'Dream Theater', 'Collection Best');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-2', 2,'song-6','The Spirit Carries On', 'Dream Theater', 'Collection Best');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-2', 1,'song-7','Enemy Inside', 'Dream Theater', 'Collection Best');
INSERT INTO playlists (id, song_order, song_id, title, artist, album)
  VALUES ('pl-2', 4,'song-8','Make Believe', 'Angra', 'Holy Land');

-- example removing a song from a playlist
delete from playlists where id='pl-2' and song_order = 1;

-- data selection
SELECT * FROM playlists;
SELECT album, title FROM playlists WHERE artist = 'Metallica';



* Criação de Indices
CREATE INDEX ON playlists(artist);


* Tipos de Collections:
   Set
   List
   Map

* Adicionando Collections
ALTER TABLE playlists ADD tags set<text>;


* Atualizando dados em uma coleção

UPDATE playlists SET tags = tags + {'rock','metal'}
  WHERE id = 'pl-2' AND song_order = 1;
  
UPDATE playlists SET tags = tags + {'rock','progressive'}
  WHERE id = 'pl-2' AND song_order = 1;

UPDATE playlists SET tags = tags + {'heavy metal'}
  WHERE id = 'pl-1' AND song_order = 2;
  
UPDATE playlists SET tags = tags + {'heavy metal', 'rock', 'rock'}
  WHERE id = 'pl-1' AND song_order = 1;

* Remover dados de uma coleção
UPDATE playlists SET tags = tags - {'rock'}
  WHERE id = 'pl-1' AND song_order = 1;
  
* Adicionando mais coleções

ALTER TABLE playlists ADD reviews list<text>;
ALTER TABLE playlists ADD venue map<timestamp, text>;

* Atualizando uma lista

UPDATE playlists
  SET reviews = reviews + [ 'best lyrics', 'very nice song' ]
  WHERE id = 'pl-1' and song_order = 1;
  
UPDATE playlists
  SET reviews = reviews + [ 'very nice song' ]
  WHERE id = 'pl-2' and song_order = 2;
  
UPDATE playlists
  SET reviews = reviews + [ 'epic!' ]
  WHERE id = 'pl-2' and song_order = 4;


* Atualizando um Mapa:

INSERT INTO playlists (id, song_order, venue)
  VALUES ('pl-1', 1,
  { '2015-9-22 22:00'  : 'The Fillmore',
  '2015-10-1 21:00' : 'The Apple Barrel'});
  
INSERT INTO playlists (id, song_order, venue)
  VALUES ('pl-2', 1,
  { '2015-1-22 22:00'  : 'Cactus Cafe',
  '2015-10-12 20:00' : 'Mohawk'});
  
INSERT INTO playlists (id, song_order, venue)
  VALUES ('pl-2', 2,
  { '2015-08-22 22:00'  : 'Hard Rock Caffe',
  '2015-06-12 23:00' : 'Brasil'});
  
