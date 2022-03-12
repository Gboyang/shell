#!/bin/sh

REDISPORT=6379
EXEC=/application/redis/src/redis-server

PIDFILE=/var/run/redis_6379.pid
CONF=/application/redis/redis.conf

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo -n "$PIDFILE exists, process is already running or crashed\n"
        else
                echo -n "Starting Redis server...\n"
                $EXEC $CONF
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo -n "$PIDFILE does not exist, process is not running\n"
        else
		PID=$(cat $PIDFILE)
                echo -n "Stopping ...\n"
                echo -n "SHUTDOWN\r\n" | nc localhost $REDISPORT &
                while [ -x /proc/${PIDFILE} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
        fi
        ;;
esac
