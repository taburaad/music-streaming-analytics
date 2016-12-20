# Analytics for Streaming Music Data

### Anthony Aburaad

http://104.197.248.161/taburaad/home.html


Companies like Pandora and Spotify use technologies like Hadoop, MapReduce, Hive, Pig, Storm, Kafka, etc. to handle massive quantities of streaming data. 

With so much play data from around the world, surely there are interesting insights to uncover as well as engineering challenges that come with it. While I do not have access to real-time real-world data, I attempt to simulate a Top Charts per City feature. I also go a bit further and look to see in what cities certain genres are proportionally most popular, and also calculate and provide the top most popular genres. The purpose of this project is to use Nathan Marz's lambda architecture to demonstrate 1) a pipleine to process and analyze large amounts of data in minimal time 2) a web application to interact with it. Batch, serving, and speed layers were created on a Google cluster, and the site is hosted on a Google webserver. 

1. **Building the dataset - from sources to uploading to HDFS.** I used the million song dataset to get song information (track id, artist id, track name, artist name) for 1 million unique songs (1). Then, I used a dataset mapping genres to almost 300k songs from the MSD, which are matched by primary key track id (2) The remaining songs’ genres were labeled ‘undefined-genre’ and not included in genre-specific calculations. This gave me everything I need for track information. Next, I built a dataset of listening history for unique users, with 50 million user/track observations, coming out to about 3GB (3). Finally, I built a dataset of 1 million unique users and their simulated cities, using the Python notebook in the utils directory. Each user was assigned a country with the probability relative to that of the country’s population. Therefore, you will see that in the app, many results by city are very similar - we assume everyone listens to the same music across the population. I loaded these three main tables into HDFS, for later querying.

2. **Building the batch layer.** I used the first 2 Pig scripts to create the batch layer in HDFS. Roughly, step1 is made up of joins to bring the data together into a central table. step2 splits the data into the uses I have for the app - play data grouped by city, and by genre. 

3. **Building the batch views and implementing the serving layer.** I used the second 2 Pig scripts to create batch views and populate HBase tables, making 3 distinct batch views in total. The first one shows the top 20 songs per city in terms of play count. The second one shows the top 5 genres per city in terms of play count. And the third one shows the cities that have the highest proportional play count for a particular genre. You can see in the commented code how each of these three batch views are computed and loaded into their respective HBase tables. 

4. **Building the speed layer.** The speed layer reads data from the submit form, and takes in ‘City’ and ‘Song’. The Perl script, which is used from class, takes this data and sends it to the Kafka topic song_plays. The script ingest-kafka-daemon.py reads the songs plays and write to HBase in real time, updating the play count.


5. **Web app: home page, submit page, scripts, usability.** The web app features a main front page, and a submit page linked from the white headphones. I used Python to replace the Perl script for the main page, which allowed for greater flexibility and usability. I used the Perl template from class for the submit page, which writes to the Kafka topic. They can be found in:

* /mpcs53013@webserver:var/www/html/taburaad

* /mpcs53013@webserver:usr/lib/cgi-bin/taburaad


To see top songs/genres per city, select a city with the genre selector set to ‘Select a genre’. If a genre is selected from the lower menu, it will return that query regardless, and not the songs/genre query. 


————————————————————————————————————-

1: http://labrosa.ee.columbia.edu/millionsong

2: http://www.tagtraum.com/msd_genre_datasets.html

3: http://labrosa.ee.columbia.edu/millionsong/tasteprofile
