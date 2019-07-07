

* pod port

```
% kc -ndemo get svc
NAME    TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
mall    ClusterIP   172.21.255.162   <none>        7000/TCP,4000/TCP   23h
order   ClusterIP   172.21.255.203   <none>        7000/TCP,4000/TCP   20m
```

```
export MALL_POD=$(kubectl -ndemo get pod -lapp=mall -ojsonpath='{.items[0].metadata.name}')
```


```
% istioctl -ndemo pc listeners $MALL_POD
ADDRESS            PORT      TYPE
0.0.0.0            7000      HTTP
172.21.0.24        7777      HTTP
172.21.0.24        4444      TCP
172.21.255.162     4000      TCP
172.21.255.203     4000      TCP
......
```

```
 % istioctl -ndemo pc clusters $MALL_POD
SERVICE FQDN                        PORT      SUBSET         DIRECTION     TYPE
BlackHoleCluster                    -         -              -             &{STATIC}
PassthroughCluster                  -         -              -             &{ORIGINAL_DST}
mall.demo.svc.cluster.local         4000      -              outbound      &{EDS}
mall.demo.svc.cluster.local         7000      -              outbound      &{EDS}
mall.demo.svc.cluster.local         7000      http-m         inbound       &{STATIC}
mall.demo.svc.cluster.local         4000      tcp-m          inbound       &{STATIC}
order.demo.svc.cluster.local        4000      -              outbound      &{EDS}
order.demo.svc.cluster.local        7000      -              outbound      &{EDS}
order.demo.svc.cluster.local        4000      v1             outbound      &{EDS}
order.demo.svc.cluster.local        7000      v1             outbound      &{EDS}
order.demo.svc.cluster.local        4000      v2             outbound      &{EDS}
order.demo.svc.cluster.local        7000      v2             outbound      &{EDS}
......
```

```
% istioctl -ndemo pc endpoints $MALL_POD
ENDPOINT            CLUSTER
127.0.0.1:4444      inbound|4000|tcp-m|mall.demo.svc.cluster.local
127.0.0.1:7777      inbound|7000|http-m|mall.demo.svc.cluster.local
172.21.0.24:4444    outbound|4000||mall.demo.svc.cluster.local
172.21.0.24:7777    outbound|7000||mall.demo.svc.cluster.local
172.21.0.25:4444    outbound|4000|v1|order.demo.svc.cluster.local
172.21.0.25:4444    outbound|4000||order.demo.svc.cluster.local
172.21.0.25:7777    outbound|7000|v1|order.demo.svc.cluster.local
172.21.0.25:7777    outbound|7000||order.demo.svc.cluster.local
172.21.0.26:4444    outbound|4000|v2|order.demo.svc.cluster.local
172.21.0.26:4444    outbound|4000||order.demo.svc.cluster.local
172.21.0.26:7777    outbound|7000|v2|order.demo.svc.cluster.local
172.21.0.26:7777    outbound|7000||order.demo.svc.cluster.local
......
```

```
% istioctl -ndemo pc routes $MALL_POD
NOTE: This output only contains routes loaded via RDS.
NAME                                                VIRTUAL HOSTS
7000                                                3
8080                                                2
15010                                               2
15014                                               2
inbound|7000|http-m|mall.demo.svc.cluster.local     1
                                                    1
inbound|7000|http-m|mall.demo.svc.cluster.local     1
```

---

```
export ORDER_V1_POD=$(kubectl -ndemo get pod -lapp=order,version=v1 -ojsonpath='{.items[0].metadata.name}')
```


```
% istioctl -ndemo pc listeners $ORDER_V1_POD
ADDRESS            PORT      TYPE
172.21.0.25        7777      HTTP
172.21.0.25        4444      TCP
172.21.255.162     4000      TCP
172.21.255.203     4000      TCP
0.0.0.0            7000      HTTP
......
```

```
 % istioctl -ndemo pc clusters $ORDER_V1_POD
SERVICE FQDN                                   PORT      SUBSET         DIRECTION     TYPE
BlackHoleCluster                               -         -              -             &{STATIC}
PassthroughCluster                             -         -              -             &{ORIGINAL_DST}
mall.demo.svc.cluster.local                    4000      -              outbound      &{EDS}
mall.demo.svc.cluster.local                    7000      -              outbound      &{EDS}
order.demo.svc.cluster.local                   4000      -              outbound      &{EDS}
order.demo.svc.cluster.local                   7000      -              outbound      &{EDS}
order.demo.svc.cluster.local                   7000      http-o         inbound       &{STATIC}
order.demo.svc.cluster.local                   4000      tcp-o          inbound       &{STATIC}

order.demo.svc.cluster.local                   4000      v1             outbound      &{EDS}
order.demo.svc.cluster.local                   7000      v1             outbound      &{EDS}
order.demo.svc.cluster.local                   4000      v2             outbound      &{EDS}
order.demo.svc.cluster.local                   7000      v2             outbound      &{EDS}
```

```
% istioctl -ndemo pc endpoints $ORDER_V1_POD
ENDPOINT                 STATUS      CLUSTER
127.0.0.1:4444           HEALTHY     inbound|4000|tcp-o|order.demo.svc.cluster.local
127.0.0.1:7777           HEALTHY     inbound|7000|http-o|order.demo.svc.cluster.local
172.21.0.24:4444         HEALTHY     outbound|4000||mall.demo.svc.cluster.local
172.21.0.24:7777         HEALTHY     outbound|7000||mall.demo.svc.cluster.local
172.21.0.25:4444         HEALTHY     outbound|4000|v1|order.demo.svc.cluster.local
172.21.0.25:4444         HEALTHY     outbound|4000||order.demo.svc.cluster.local
172.21.0.25:7777         HEALTHY     outbound|7000|v1|order.demo.svc.cluster.local
172.21.0.25:7777         HEALTHY     outbound|7000||order.demo.svc.cluster.local
172.21.0.26:4444         HEALTHY     outbound|4000|v2|order.demo.svc.cluster.local
172.21.0.26:4444         HEALTHY     outbound|4000||order.demo.svc.cluster.local
172.21.0.26:7777         HEALTHY     outbound|7000|v2|order.demo.svc.cluster.local
172.21.0.26:7777         HEALTHY     outbound|7000||order.demo.svc.cluster.local
......
```

```
% istioctl -ndemo pc routes $ORDER_V1_POD
NOTE: This output only contains routes loaded via RDS.
NAME                                                 VIRTUAL HOSTS
7000                                                 3
8080                                                 2
15010                                                2
15014                                                2
inbound|7000|http-o|order.demo.svc.cluster.local     1
                                                     1
inbound|7000|http-o|order.demo.svc.cluster.local     1
```


