#!/usr/bin/python

import happybase
import cgi
import cgitb
from html import HTML

cgitb.enable()

# Start HTML
print 'Content-type:text/html'
print '\n'
html = HTML('html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US"')

# Start Header
header = html.head
header.title('Music Analytics')
header.link(rel="stylesheet", type="text/css", href="/taburaad/table.css")
header.meta(http_equiv="Content-Type", content="text/html; charset=iso-8859-1")

# End Header, start body 
body = html.body

# Connect to HBase
hbase = happybase.Connection('hdp-m')
hbase.open()

# Get data from form
form = cgi.FieldStorage()

city = form['city'].value
genre = form['genre'].value
recent = form['city_recent'].value

if genre == 'closed' and recent=='closed':
	song_table = hbase.table('music_top_20')
	genre_table = hbase.table('music_top_20_genre')

	song_records = song_table.scan(row_prefix = city)
	genre_records = genre_table.scan(row_prefix = city)

	# Make list of top songs per city
	top_songs = []
	for row in song_records:
		artist = str(row[1]['city:artist_name'])
		track =  str(row[1]['city:track_name'])
		plays = int(row[1]['city:plays'])
		top_songs.append((track, artist, plays))
	top_songs.sort(key=lambda x: x[2], reverse=True)
	
	top_songs2= []
    for song in top_songs:
            top_songs2.append((song[0], song[1], "{:,}".format(song[2])))
	top_songs=top_songs2

	# Make list of top genres per city	
	top_genres = []
	for row in genre_records:
		genre = row[0].split('|')[1]
		count = int(row[1]['city:genre_count'])
		top_genres.append((genre, count))
	top_genres.sort(key=lambda x: x[1], reverse=True)

	top_genres2= []
    for genre in top_genres:
            top_genres2.append((genre[0], "{:,}".format(genre[1])))
    top_genres=top_genres2


	# Create html tables
	p = body.p(style='bottom-margin:10px').text('')
	title = body.h4('Top 20 songs in '+str(city), style='color:#FFFFFF')
	table = body.table(klass='CSS_Table_Example', style='style="width:100%;margin:auto;" align="center"')
	row_head = table.tr
	row_head.td('Rank')
	row_head.td('Artist')
	row_head.td('Song')
	row_head.td('Plays')

	rank = 1
	for song in top_songs:
		row = table.tr
		row.td(str(rank))
		row.td(song[0])
		row.td(song[1])
		row.td(str(song[2]))
		rank += 1

	title = body.h4('Top 5 genres in '+str(city),style='color:#FFFFFF')
	table = body.table(klass='CSS_Table_Example', style='style="width:100%;margin:auto;" align="center"')
	row_head = table.tr
	row_head.td('Rank')
	row_head.td('Genre')
	row_head.td('Plays')

	rank = 1
	for genre in top_genres:
	        row = table.tr
	        row.td(str(rank))
	        row.td(genre[0])
	        row.td(str(genre[1]))
	        rank += 1

	p = body.p(style='bottom-margin:10px').text('')
	body.br

	# Print out to main page
	print html
elif genre != 'closed' and recent =='closed':
	genre_city_table = hbase.table('music_cities_per_genre')
	genre_city_records = genre_city_table.scan()
	temp_list = []
	for row in genre_city_records:
		city,cur_genre = row[0].split('|')
        	perc = float(row[1]['genre:play_percentage'])
        	if cur_genre == genre:
                	temp_list.append((city, perc))
	temp_list.sort(key = lambda x: x[1], reverse=True)
	
	p = body.p(style='bottom-margin:10px').text('')
	title = body.h4('Cities which listen to ' + genre + " at the proportionally highest rate", style='color:#FFFFFF')
	table = body.table(klass='CSS_Table_Example', style='style="width:100%;margin:auto;" align="center"')
	row_head = table.tr
	row_head.td('Rank')
	row_head.td('City')
	row_head.td('Percent listens')

	rank = 1
	for cur_genre in temp_list:
		row = table.tr
		row.td(str(rank))
		row.td(cur_genre[0])
		row.td("{:.5f}%".format((cur_genre[1]*100)))
		rank += 1

	p = body.p(style='bottom-margin:10px').text('')
	body.br

	#print out to main page
	print html
elif recent != 'closed':
	recent_table = hbase.table('current_song_plays')
        recent_records = recent_table.scan(row_prefix = recent)
	
	recent_songs = []    
	for row in recent_records:
		song = row[1]['city:song']
		count = int(row[1]['city:count'])	
                if count !=0:
			recent_songs.append((song, count))
	recent_songs.sort(key=lambda x: x[1], reverse=True)
	
	p = body.p(style='bottom-margin:10px').text('')
    title = body.h4('Recent popular songs in ' + recent, style='color:#FFFFFF')
    table = body.table(klass='CSS_Table_Example', style='style="width:100%;margin:auto;" align="center"')
    row_head = table.tr
    row_head.td('Rank')
    row_head.td('Song')
    row_head.td('Listens')

    rank = 1
    for song in recent_songs:
            row = table.tr
            row.td(str(rank))
            row.td(song[0])
            row.td(str(song[1]))
            rank += 1

    p = body.p(style='bottom-margin:10px').text('')
    body.br

    #print out to main page
    print html
hbase.close()
