--Load 50 million records of user/track play counts
PLAY_COUNT = LOAD '/inputs/music_data/play_count.txt' USING PigStorage('\t') as (user_id:chararray, track_id:chararray, play_count:int);
--Load song info for 1 million unique tracks
TRACKS = LOAD '/inputs/music_data/unique_tracks_and_genre_pipe.txt' USING PigStorage('|') as (artist_id:chararray, track_id:chararray, artist_name:chararray, track_name:chararray, genre:chararray);
--Load user info
USERS = LOAD '/inputs/music_data/users_and_cities.txt' USING PigStorage(',') as (user_id:chararray, city:chararray, country:chararray);

--First join
PLAY_COUNT_NAMED = JOIN PLAY_COUNT by track_id, TRACKS by track_id PARALLEL 50;
--Generate needed fields
PLAY_COUNT_NAMED2 = FOREACH PLAY_COUNT_NAMED GENERATE $0 as user_id, $1 as track_id, $2 as play_count, $3 as artist_id, $5 as artist_name, $6 as track_name, $7 as genre; 
--Second join
FULL_TABLE = JOIN PLAY_COUNT_NAMED2 by user_id, USERS by user_id PARALLEL 50;
--Generate needed fields
FULL_TABLE2 = FOREACH FULL_TABLE GENERATE $0 as user_id, $1 as track_id, $2 as play_count, $3 as artist_id, $4 as artist_name, $5 as genre, $6 as track_name, $8 as city, $9 as country; 

--This is where we will keep our batch layer
STORE FULL_TABLE2 into '/inputs/music_data_batch3' USING PigStorage(',');