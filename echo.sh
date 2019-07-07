#!/bin/sh

while true ;
  do nc -l -p 4000 -c 'echo -e "tcp_v1"';
done &

while true ;
  do nc -l -p 7000 -c 'echo -e "HTTP/1.1 200 OK\n\n http_v1"';
done
