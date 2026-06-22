# Scripts

Database schemas and big-data service commands used in this project.

| File | Purpose |
|------|---------|
| `MySQL_DDL.sql` | Relational schema (`s2ca2` database, `stock_prices` and related tables) for the SQL side of the storage comparison. |
| `Cassandra_DDL.sql` | Wide-column schema (`s2ca2` keyspace) for the NoSQL side. |
| `commands.sh` | Reference commands for launching Spark with the required connectors (MySQL, MongoDB, Cassandra, Spark NLP) and managing Kafka topics. |
| `ycsb_benchmarkABC.sh` | Runs the **YCSB** workloads (A: 50/50 read-update, B: 95/5, C: 100% read) against the databases and collects results. |

> These scripts assume locally running services (Spark, Kafka, MySQL, Cassandra). Hostnames are
> set to `127.0.0.1`/`localhost`; adjust them for your environment. No credentials are stored in
> these files — supply your own at run time.
