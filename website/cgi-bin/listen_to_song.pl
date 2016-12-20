#!/usr/bin/perl -w
# Program: cass_sample.pl
# Note: includes bug fixes for Net::Async::CassandraCQL 0.11 version

use strict;
use warnings;
use 5.10.0;
use FindBin;

use Scalar::Util qw(
        blessed
    );
use Try::Tiny;

use Kafka::Connection;
use Kafka::Producer;

use Data::Dumper;
use CGI qw/:standard/, 'Vars';

my $city = param('city');
my $song = param('song');

if(!$city or !$song) {
    exit;
}

my ( $connection, $producer );
try {
    #-- Connection
    $connection = Kafka::Connection->new( host => 'hdp-m.c.mpcs53013-2016.internal', port => 6667 );

    #-- Producer
    $producer = Kafka::Producer->new( Connection => $connection );
    my $message = "<song_play><city>$city</city><song>$song</song></song_play>";

    # Sending a single message
    my $response = $producer->send(
	'song_plays',         # topic
	0,                                 # partition
	$message                           # message
        );
} catch {
    if ( blessed( $_ ) && $_->isa( 'Kafka::Exception' ) ) {
	warn 'Error: (', $_->code, ') ',  $_->message, "\n";
	exit;
    } else {
	die $_;
    }
};

# Closes the producer and cleans up
undef $producer;
undef $connection;

print header, start_html(-title=>'Listen to a song',-style=>{'background-image:URL("omar.png");
                            background-repeat:no-repeat;
                            background-position:center bottom'},-head=>Link({-rel=>'stylesheet',-href=>'/taburaad/table.css',-type=>'text/css'}));
print table({-class=>'CSS_Table_Example', -style=>'width:80%;'},
            caption('Song played (and sent to Kafka)!'),
	    Tr([th(["City", "Song"]),
	        td([$city, $song])]));

#print $protocol->getTransport->getBuffer;
print end_html;
