--For first batch view, top 20 songs per city
--Load counts of song listens per city
SERVE1 = LOAD '/inputs/music_data/serving_totals' USING PigStorage(',') as (city:chararray, track_id:chararray, country:chararray, track_name:chararray, artist_name:chararray, plays:int);
SERVE2 = GROUP SERVE1 BY city;

--Take the 20 top songs by sorting
top = foreach SERVE2 {
        sorted = order SERVE1 by plays desc;
        top1    = limit sorted 20;
        generate flatten(top1);
};

top2 = GROUP top BY (city, track_id);
--Generate a concatenated field to be used as a key for HBase, to query by city
top_counts = FOREACH top2 GENERATE CONCAT(group.city,'|',group.track_id) as city_track, $1.track_name as track_name, $1.artist_name as artist_name, SUM($1.plays) as plays;
--Flatten bags
top_counts2 = FOREACH top_counts GENERATE $0 as city_track, BagToTuple($1).$0 as track_name, BagToTuple($2).$0 as artist_name, $3 as plays;

--Store into HBase table for batch view (top 20 songs per city)
STORE top_counts2 INTO 'hbase://music_top_20' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('city:track_name, city:artist_name, city:plays');
