#!/bin/bash

MAX_LOOPS=10
LOOP_COUNT=0

POOL="pool.supportxmr.com:3333"
WALLET="44pavGxRjnFREKLAENNcaA3veD3BtereU2YgznZqHAcD32YZtnc28zBFhGHwCSq2pDLHSgeaXk64LEmeotJfZwiyJ1mtoi8"
WORKER="$(whoami)"

while [ $LOOP_COUNT -lt $MAX_LOOPS ]; do
    echo "Loop $((LOOP_COUNT+1)): Running xmrig for 10 minutes (toggle threads every minute)"

    THREADS=80

    for MINUTE in {1..10}; do
        echo " Minute $MINUTE: cpu-max-threads-hint=$THREADS"

        ./xmrig -o $POOL \
            -u $WALLET \
            -p $WORKER \
            --cpu-max-threads-hint=$THREADS &
        XMRIG_PID=$!

        sleep 60

        kill $XMRIG_PID 2>/dev/null
        wait $XMRIG_PID 2>/dev/null

        # Toggle threads
        if [ "$THREADS" -eq 80 ]; then
            THREADS=50
        else
            THREADS=80
        fi
    done

    echo "Waiting for 1 minute before next loop..."
    sleep 60

    LOOP_COUNT=$((LOOP_COUNT+1))
done
