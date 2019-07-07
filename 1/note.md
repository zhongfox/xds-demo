

* pod port

```
export MALL_POD=$(kubectl -ndemo get pod -lapp=mall -ojsonpath='{.items[0].metadata.name}')
```


```
% istioctl -ndemo pc listeners $MALL_POD
ADDRESS            PORT      TYPE
172.21.0.24        7777      HTTP # mall pod ip + http port ->                                            "inbound|7000|http-m|mall.demo.svc.cluster.local" 入
172.21.0.24        4444      TCP  # mall pod ip + tcp port ->                                             "inbound|4000|tcp-m|mall.demo.svc.cluster.local" 入
172.21.255.162     4000      TCP  # mall service ip + mall service tcp port ->                            "outbound|4000||mall.demo.svc.cluster.local" 出
0.0.0.0            7000      HTTP # INADDR_ANY + mall service http port -> rds route_config_name: "7000"  "outbound|7000||mall.demo.svc.cluster.local" 出
......
```

```
 % istioctl -ndemo pc clusters $MALL_POD
SERVICE FQDN                                   PORT      SUBSET         DIRECTION     TYPE
BlackHoleCluster                               -         -              -             &{STATIC}
PassthroughCluster                             -         -              -             &{ORIGINAL_DST}
mall.demo.svc.cluster.local                    4000      -              outbound      &{EDS} 配置客户端治理
mall.demo.svc.cluster.local                    7000      -              outbound      &{EDS} 配置客户端治理
mall.demo.svc.cluster.local                    7000      http-m         inbound       &{STATIC} 配置服务端治理
mall.demo.svc.cluster.local                    4000      tcp-m          inbound       &{STATIC} 配置服务端治理
```

```
% istioctl -ndemo pc endpoints $MALL_POD
ENDPOINT                 STATUS      CLUSTER
127.0.0.1:4444           HEALTHY     inbound|4000|tcp-m|mall.demo.svc.cluster.local inbound 直接用127
127.0.0.1:7777           HEALTHY     inbound|7000|http-m|mall.demo.svc.cluster.local
172.21.0.24:4444         HEALTHY     outbound|4000||mall.demo.svc.cluster.local
172.21.0.24:7777         HEALTHY     outbound|7000||mall.demo.svc.cluster.local
......
```

```
% istioctl -ndemo pc routes $MALL_POD
NOTE: This output only contains routes loaded via RDS.
NAME                                                VIRTUAL HOSTS
7000                                                2
8080                                                2
15010                                               2
15014                                               2
inbound|7000|http-m|mall.demo.svc.cluster.local     1
                                                    1
inbound|7000|http-m|mall.demo.svc.cluster.local     1
```
