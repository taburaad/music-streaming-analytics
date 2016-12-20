-----------Create batch view table for song count per city-------------------------
--Load main batch layer dataset (without genre)
FULL_TABLE1 = LOAD '/inputs/music_data_batch' USING PigStorage(',') as (user_id:chararray, track_id:chararray, play_count:int, artist_id:chararray, artist_name:chararray, track_name:chararray, city:chararray, country:chararray);
--Group by city and song for play count summation
DATA_BY_CITY_TRACK = GROUP FULL_TABLE1 BY (city, track_id);
--Generate sums of plays per song/city group
PLAYS_PER_CITY = FOREACH DATA_BY_CITY_TRACK GENERATE group.city as city, $1.country as country, $1.track_name as track_name, SUM($1.play_count) as plays;
-- Flatten bags in two steps (too big to do all at once)
PLAYS_PER_CITY2 = FOREACH PLAYS_PER_CITY GENERATE FLATTEN(group) as (city, track_id), BagToTuple($1.country).$0 as country, $1.track_name as track_name, $1.artist_name as artist_name, SUM($1.play_count) as plays;
PLAYS_PER_CITY3 = FOREACH PLAYS_PER_CITY2 GENERATE city as city, track_id as track_id, country as country, BagToTuple(track_name).$0 as track_name, BagToTuple(artist_name).$0 as artist_name, plays as plays;
--Store final table in HDFS to be used as a batch view
STORE PLAYS_PER_CITY3 into '/inputs/music_data/serving_totals' USING PigStorage(',');


-----------Create batch view table for genre count per city-------------------------
--Load main batch layer dataset (with genre)
FULL_TABLE2 = LOAD '/inputs/music_data_batch3' USING PigStorage(',') as (user_id:chararray, track_id:chararray, play_count:int, artist_id:chararray, artist_name:chararray, track_name:chararray, genre:chararray, city:chararray, country:chararray);
--Group by city and genre for genre popularity summation
DATA_BY_CITY_TRACK = GROUP FULL_TABLE2 BY (city, genre);
--Sum and flatten bag
GENRES_PER_CITY = FOREACH DATA_BY_CITY_TRACK GENERATE group.city as city, $1.country as country, group.genre as genre, SUM($1.play_count) as genre_count;
GENRES_PER_CITY2 = FOREACH GENRES_PER_CITY GENERATE city as city, BagToTuple(country).$0 as country, genre as genre, genre_count as genre_count;
--Store final table in HDFS to be used as a batch view
STORE GENRES_PER_CITY2 into '/inputs/music_data/serving_totals_genre' USING PigStorage(',');
