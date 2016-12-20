--------For second batch view-------
--Load counts of genre listens per city
SERVE1 = LOAD '/inputs/music_data/serving_totals_genre' USING PigStorage(',') as (city:chararray, country:chararray, genre:chararray, genre_count:int);
--Filter out the unidentified ones, and group
SERVE1_FILTERED = FILTER SERVE1 BY genre != 'unidentified-genre';
SERVE2 = GROUP SERVE1_FILTERED BY city;

--take top 5 genres per city
top = foreach SERVE2 {
        sorted = order SERVE1_FILTERED by genre_count desc;
        top1    = limit sorted 5;
        generate flatten(top1);
};

top2 = GROUP top BY (city, genre);
--Generate concatenated key to be used as query in HBase, flatten bags
top_counts = foreach top2 GENERATE CONCAT(group.city,'|',group.genre) as city_genre, BagToTuple($1.genre_count).$0 as genre_count;
--Store into HBase (top 5 genres per city)
STORE top_counts into 'hbase://music_top_20_genre' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('city:genre_count');


--------For third batch view-------
--Find total count of known plays over all genres per city
totalsum = FOREACH SERVE2 generate group as city, SUM($1.genre_count) as total;
--Join to have total plays per city and plays per genre per city, to calculate percentage
--Join on city, use substring to parse out city from top_counts's key
genre_perc1 = JOIN totalsum by city, top_counts by SUBSTRING(city_genre, 0, (INDEXOF(city_genre, '|', 0)));
genre_perc3 = FOREACH genre_perc1 GENERATE SUBSTRING(city_genre, 0, (INDEXOF(city_genre, '|', 0))) as city, SUBSTRING(city_genre, (INDEXOF(city_genre, '|', 0)+1), (int)SIZE(city_genre)) as genre, (double)genre_count / (double)total as perc;
genre_perc4 = GROUP genre_perc3 by genre;

--Take top 5 genre percentages per city, like before
top_perc = foreach genre_perc4 {
        sorted = order genre_perc3 by perc desc;
        top1_perc    = limit sorted 5;
        generate flatten(top1_perc);
};

--Group back into city and genre for HBase
top2_perc = GROUP top_perc BY (city, genre);

--Concatenate again (for HBase querying)
top_counts_perc = FOREACH top2_perc GENERATE CONCAT(group.city,'|',group.genre) as city_genre, BagToTuple($1.perc).$0 as perc;
--Store into HBase (top 5 cities that have the highest proportion of listens of this genre)
STORE top_counts_perc into 'hbase://music_cities_per_genre' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('genre:play_percentage');
