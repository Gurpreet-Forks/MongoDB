#!/bin/bash
#run processes for the cluster
#running on a single machine before main deployment

mkdir a0
mkdir a1
mkdir a2
mkdir b0
mkdir b1
mkdir b2
mkdir c0
mkdir c1
mkdir a2
mkdir d0
mkdir d1
mkdir d2

mkdir cfg0
mkdir cfg1
mkdir cfg2

#config servers (here we tell each is a config server for a sharded cluster)
mongod --configsvr --dbpath cfg0 --port 26050 --logpath log.cfg0 --logappend
mongod --configsvr --dbpath cfg1 --port 26051 --logpath log.cfg1 --logappend
mongod --configsvr --dbpath cfg2 --port 26052 --logpath log.cfg2 --logappend

#"shard servers"(mongod data servers)(shardsvr paramter tells ,this is part of a sharded cluster)
#Don't use such smallfiles nor such a small oplogSize in production,these are here all running on one machine
mongod --shardsvr --replSet a --dbpath a0 --logpath log.a0 --port 27000 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet a --dbpath a1 --logpath log.a1 --port 27001 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet a --dbpath a2 --logpath log.a2 --port 27002 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet b --dbpath b0 --logpath log.b0 --port 27100 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet b --dbpath b1 --logpath log.b1 --port 27101 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet b --dbpath b2 --logpath log.b2 --port 27102 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet c --dbpath c0 --logpath log.c0 --port 27200 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet c --dbpath c1 --logpath log.c1 --port 27201 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet c --dbpath c2 --logpath log.c2 --port 27202 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet d --dbpath d0 --logpath log.d0 --port 27300 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet d --dbpath d1 --logpath log.d1 --port 27301 --fork --logappend  --smallfiles --oplogsize 50
mongod --shardsvr --replSet d --dbpath d2 --logpath log.d2 --port 27302 --fork --logappend  --smallfiles --oplogsize 50

#mongos processes(although normally mongos should be using default ports)
NOte** ensure mongod's(shard servers)/config servers don't use this port 27017)
mongos --configdb c1:26050,c1:26051,c1:26052 --fork --logappend --logpath log.mongos0 (default port ie 27017)
mongos --configdb c1:26050,c1:26051,c1:26052 --fork --logappend --logpath log.mongos1 --port 26061
mongos --configdb c1:26050,c1:26051,c1:26052 --fork --logappend --logpath log.mongos2 --port 26062
mongos --configdb c1:26050,c1:26051,c1:26052 --fork --logappend --logpath log.mongos3 --port 26063

echo
ps -A | grep mongo

echo 
tail -n 1 log.cfg0
tail -n 1 log.cfg1
tail -n 1 log.cfg2

echo
tail -n 1 log.a0
tail -n 1 log.a1
tail -n 1 log.a2
tail -n 1 log.b0
tail -n 1 log.b1
tail -n 1 log.b2
tail -n 1 log.c0
tail -n 1 log.c1
tail -n 1 log.c2
tail -n 1 log.d0
tail -n 1 log.d1
tail -n 1 log.d2

echo
tail -n 1 log.mongos0
tail -n 1 log.mongos1
tail -n 1 log.mongos2
tail -n 1 log.mongos3