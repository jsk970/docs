#custom
SIMULATOR_ID=dev
LOCAL_PORT=7769
APP_NAME=test
APP_VERSION=0.0.1-S
NACOS_ADDR=IP:PORT
NACOS_NAMESPACE=XXXXXXXXXXXXXXXXXXXXXXXX
IMAGE_NAME=test/$APP_NAME:$APP_VERSION
CONTAINER_NAME=$APP_NAME-$SIMULATOR_ID
PAHT_LOGS=/home/common/logs/$SIMULATOR_ID
# stop
docker stop $CONTAINER_NAME
sleep 1s
# remove
docker rm $CONTAINER_NAME
sleep 1s
# start
docker run -d \
--restart=always \
--name $CONTAINER_NAME \
-e SLEEP_SECOND=5s \
-e spring.profiles.active=prod \
-e custom.system.simulator-id=$SIMULATOR_ID \
-e spring.cloud.nacos.config.server-addr=$NACOS_ADDR \
-e spring.cloud.nacos.config.namespace=$NACOS_NAMESPACE \
-v $PAHT_LOGS/test-prod:/opt/logs/test-prod \
-e JAVA_OPTS='-server -Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200' \
-p $LOCAL_PORT:8080 \
$IMAGE_NAME