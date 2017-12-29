#!/bin/bash
#rishi's script

is_build_required=true

can_start_server=true

PATH_RETAILER=/Users/renovite/westfield/wrsinc/retailer/retailer

PATH_ORDER=/Users/renovite/westfield/wrsinc/order/order

PATH_MESSAGING=/Users/renovite/westfield/wrsinc/messaging/messaging

PATH_RECEIPT=/Users/renovite/westfield/wrsinc/receipt/receipt

PATH_MEMBERPREFERENCES=/Users/renovite/westfield/wrsinc/memberpreferences/memberpreferences

PATH_TEMPLATE=/Users/renovite/westfield/wrsinc/template/template

PATH_REDIS=/Users/renovite/westfield

PATH_CONVERSATION=/Users/renovite/westfield/wrsinc/conversation/conversation

PATH_RETAILERWEBDEMO=/Users/renovite/westfield/wrsinc/retailerwebdemo/retailerwebdemo/src

PATH_EMAIL=/Users/renovite/westfield/wrsinc/email

PATH_IDENTITY=/Users/renovite/go/src/github.com/wrsinc/identity

PATH_DATABUNKER=/Users/renovite/go/src/github.com/wrsinc/databunker

PATH_NGROK=/Users/renovite/westfield/downloads


if [ "$is_build_required" = true ] ; then
	JAVA_BUILD_COMMAND="mvn clean install;"
	JAVA_BUILD_COMMAND_SKIPTEST="mvn clean install -DskipTests;"
	NPM_BUILD_COMMAND="npm install;"
	GO_BUILD_COMMAND="go build;"
fi

if [ "$can_start_server" = true ] ; then
  JAVA_SERVER_COMMAND="mvn spring-boot:run"
  JAVA_SERVER_COMMAND_DEVELOPMENT="mvn -Drun.profiles=development spring-boot:run"
  JAVA_SERVER_COMMAND_DEVELOPMENT_EMULATOR="mvn spring-boot:run -Dspring.profiles.active=development,emulator"
  REDIS_SERVER_START="redis-server"

  GO_SERVER_COMMAND="./server.sh"
  
fi


function new_tab() {
  TAB_NAME=$1
  COMMAND=$2
  osascript \
    -e "tell application \"Terminal\"" \
    -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
    -e "do script \"printf '\\\e]1;$TAB_NAME\\\a'; $COMMAND\" in front window" \
    -e "end tell" > /dev/null
}

echo "starting retailer service in new tab..."
new_tab "retailer" "cd $PATH_RETAILER; $JAVA_BUILD_COMMAND $JAVA_SERVER_COMMAND"

sleep 60s

echo "starting Order service in new tab..."
new_tab "order" "cd $PATH_ORDER; $JAVA_BUILD_COMMAND $JAVA_SERVER_COMMAND"


echo "starting Receipt service in new tab..."
new_tab "receipt" "cd $PATH_RECEIPT; $JAVA_BUILD_COMMAND $JAVA_SERVER_COMMAND"


echo "starting Messaging service in new tab..."
new_tab "messaging" "cd $PATH_MESSAGING; $JAVA_BUILD_COMMAND_SKIPTEST $JAVA_SERVER_COMMAND_DEVELOPMENT"


echo "starting Memberpreferences service in new tab..."
new_tab "memberpreferences" "cd $PATH_MEMBERPREFERENCES; $JAVA_BUILD_COMMAND $JAVA_SERVER_COMMAND"


echo "starting Template service in new tab..."
new_tab "template" "cd $PATH_TEMPLATE; $JAVA_BUILD_COMMAND_SKIPTEST $JAVA_SERVER_COMMAND_DEVELOPMENT_EMULATOR"

if [ "$can_start_server" = true ] ; then
echo "starting redis service in new tab..."
new_tab "redis" "cd $PATH_REDIS; redis-server"
fi

echo "starting email service in new tab..."
new_tab "email" "cd $PATH_EMAIL;  $JAVA_BUILD_COMMAND $JAVA_SERVER_COMMAND"


sleep 60s


if [ "$can_start_server" = true ] ; then
echo "starting databunker service in new tab..."
new_tab "databunker" "cd $PATH_DATABUNKER; $GO_BUILD_COMMAND $GO_SERVER_COMMAND"

echo "auth identity service in new tab..."
new_tab "gauth" "cd $PATH_IDENTITY; gcloud beta auth login"

sleep 30s #wait for 30 seconds to google auth and execute command afterward

echo "starting pubsub emulator in new tab..."
new_tab "pubsub" "cd $PATH_IDENTITY; gcloud beta emulators pubsub start"

echo "starting datastore emulator in new tab..."
new_tab "datastore" "cd $PATH_IDENTITY; gcloud beta emulators datastore start"


echo "starting identity service in new tab..."

new_tab "identity" "cd $PATH_IDENTITY; $IDENTITY_BUILD_COMMAND go run main.go"


echo "starting conversation service in new tab..."
new_tab "conversation" "cd $PATH_CONVERSATION; $NPM_BUILD_COMMAND ./start.sh"

sleep 40s #wait for 30 seconds to before creating ngrok url for conversation

echo "starting ngrok url for conversation service in new tab..."
new_tab "ngrok" "cd $PATH_NGROK; ./ngrok http 9090"


echo "update header.ejs with conversation ngrok url before running retailerwebdemo service..."


sleep 30s #wait for 30 seconds to before creating ngrok url for retailerwebdemo


echo "starting retailerwebdemo service in new tab..."
new_tab "retailerwebdemo" "cd $PATH_RETAILERWEBDEMO; $NPM_BUILD_COMMAND node app.js"


echo "starting ngrok url for retailerwebdemo service in new tab..."
new_tab "ngrok" "cd $PATH_NGROK; ./ngrok http 8080"

fi
sleep 30s

echo "All services started successfully... "
