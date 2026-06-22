#!/bin/bash

# Input Parameters
WORKLOAD_NAME="${1:-workloada}"  
DB="${2:-jdbc}"
DO_LOAD="${3:-false}"

# Static Settings
RECORDS=10000
OPS=10000
THREADS=20
PROPS="/home/hduser/ycsb-0.17.0/jdbc-binding/conf/db.properties"
WORKLOAD="/home/hduser/ycsb-0.17.0/workloads/$WORKLOAD_NAME"
YCSB_BIN="/home/hduser/ycsb-0.17.0/bin/ycsb.sh"
OUTPUT_FILE="ycsb_results_${DB}_${WORKLOAD_NAME}.csv"

# Cassandra specific settings
CASSANDRA_HOSTS="127.0.0.1"
CASSANDRA_KEYSPACE="ycsb"

# Target Throughput Values
TARGETS=(1000 2000 3000 4000 5000 6000 7000 8000 9000 10000)

# CSV Header
echo "Target Throughput, Actual Throughput, Read Latency (ms), Update Latency (ms)" > "$OUTPUT_FILE"

# Optional Load
if [[ "${DO_LOAD,,}" == "true" ]]; then
    echo "Loading database..."
    if [[ "$DB" == "jdbc" ]]; then
        $YCSB_BIN load $DB -P "$PROPS" -P "$WORKLOAD" -p recordcount=$RECORDS -p operationcount=$OPS -threads $THREADS
    elif [[ "$DB" == "cassandra-cql" ]]; then
        $YCSB_BIN load $DB -p hosts=$CASSANDRA_HOSTS -p cassandra.keyspace=$CASSANDRA_KEYSPACE -P "$WORKLOAD" -p recordcount=$RECORDS -p operationcount=$OPS -threads $THREADS
    else
        $YCSB_BIN load $DB -P "$WORKLOAD" -p recordcount=$RECORDS -p operationcount=$OPS -threads $THREADS
    fi
    echo "Load complete."
else
    echo "Skipping load step."
fi

# Run Benchmark
for TARGET in "${TARGETS[@]}"; do
    echo "Running benchmark at $TARGET ops/sec..."

    if [[ "$DB" == "jdbc" ]]; then
        RESULT=$($YCSB_BIN run $DB -P "$PROPS" -P "$WORKLOAD" \
            -p recordcount=$RECORDS -p operationcount=$OPS \
            -threads $THREADS -target $TARGET)
    elif [[ "$DB" == "cassandra-cql" ]]; then
        RESULT=$($YCSB_BIN run $DB -p hosts=$CASSANDRA_HOSTS -p cassandra.keyspace=$CASSANDRA_KEYSPACE -P "$WORKLOAD" \
            -p recordcount=$RECORDS -p operationcount=$OPS \
            -threads $THREADS -target $TARGET)
    else
        RESULT=$($YCSB_BIN run $DB -P "$WORKLOAD" \
            -p recordcount=$RECORDS -p operationcount=$OPS \
            -threads $THREADS -target $TARGET)
    fi

    # Extract metrics
    READ_LATENCY=$(echo "$RESULT" | awk -F, '/\[READ\], AverageLatency/ {print $3; exit}')
    UPDATE_LATENCY=$(echo "$RESULT" | awk -F, '/\[UPDATE\], AverageLatency/ {print $3; exit}')
    ACTUAL_THROUGHPUT=$(echo "$RESULT" | awk -F, '/\[OVERALL\], Throughput/ {print $3; exit}')

    # Save results
    echo "$TARGET, $ACTUAL_THROUGHPUT, $READ_LATENCY, $UPDATE_LATENCY" >> "$OUTPUT_FILE"
done

echo "Benchmarking complete. Results saved in $OUTPUT_FILE"