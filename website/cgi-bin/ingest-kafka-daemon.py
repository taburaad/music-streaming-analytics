#!/usr/bin/python

import happybase
import threading, logging, time
from kafka import KafkaConsumer

#http://kafka-python.readthedocs.io/en/master/usage.html

class Consumer(threading.Thread):
	"""
	A class which subscribes to a Kafka stream and continually updates an HBase
	table. For each event, the row to be updated is cast to an int, incremented, 
	and cast back to a string. For demonstration purposes, this script can be ran
	as a background process.
	"""
	daemon = True

	def __init__(self):
		super(Consumer, self).__init__()
		self.hbase = happybase.Connection('hdp-m')
		self.hbase.open()
		self.table = self.hbase.table('current_song_plays')

	def run(self):
		consumer = KafkaConsumer(bootstrap_servers='hdp-m.c.mpcs53013-2016.internal:6667',auto_offset_reset='earliest')
		consumer.subscribe(['song_plays'])

		for message in consumer:
			msg = str(message.value)
			city = msg.split('|')[1]
			song = msg.split('|')[3]
			rn = '{}|{}'.format(city,song)
			
			before = self.table.row(rn)
			before_count = int(before['city:count'])
			after_inc = {'city:count' : str(before_count + 1)}
			self.table.put(rn, after_inc)

def main():
	thread = Consumer()
	thread.start()
	time.sleep(12000000)

if __name__ == "__main__":
	main()
