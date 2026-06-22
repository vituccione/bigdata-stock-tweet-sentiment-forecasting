# Pyspark
pyspark \
  --packages mysql:mysql-connector-java:8.0.33,org.mongodb.spark:mongo-spark-connector_2.12:3.0.1,com.datastax.spark:spark-cassandra-connector_2.12:3.4.0,com.johnsnowlabs.nlp:spark-nlp_2.12:5.1.3,org.apache.commons:commons-text:1.10.0 \
  --conf spark.cassandra.connection.host=127.0.0.1 \
  --conf spark.hadoop.fs.defaultFS=file:/// \
  --conf spark.jars.ivy=/tmp/.ivy \
  --conf spark.driver.extraJavaOptions="-Dio.netty.tryReflectionSetAccessible=true" \
  --conf spark.sql.extensions=com.datastax.spark.connector.CassandraSparkExtensions 
 
 
# CASSANDRA
/usr/local/cassandra/bin/cassandra -f
/usr/local/cassandra/bin/nodetool status
/usr/local/cassandra/bin/nodetool ring
/usr/local/cassandra/bin/cqlsh

# MONGODB
mongod --bind_ip 127.0.0.1
mongo

# MYSQL
mysql -u root -p -h 127.0.0.1

# YCSB
chmod +x ycsb_benchmarkABC.sh

./ycsb_benchmarkABC.sh workloada jdbc true
./ycsb_benchmarkABC.sh workloadb jdbc
./ycsb_benchmarkABC.sh workloadc jdbc

./ycsb_benchmarkABC.sh workloada mongodb true
./ycsb_benchmarkABC.sh workloadb mongodb
./ycsb_benchmarkABC.sh workloadc mongodb

./ycsb_benchmarkABC.sh workloada cassandra-cql true
./ycsb_benchmarkABC.sh workloadb cassandra-cql
./ycsb_benchmarkABC.sh workloadc cassandra-cql

# Kafka
/home/hduser/zookeeper/bin/zkServer.sh start
/usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties

/home/hduser/zookeeper/bin/zkServer.sh stop

/usr/local/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --topic reddit-posts --partitions 1 --replication-factor 1
/usr/local/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic reddit-posts

/usr/local/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic reddit-posts --from-beginning

# Pyspark with Kafka
pyspark --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.4.4 \
  --conf spark.hadoop.fs.defaultFS=file:/// 