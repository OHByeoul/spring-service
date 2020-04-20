#!/bin/bash

REPOSITORY=/home/ubuntu/app/first
PROJECT=spring-service

cd $REPOSITORY/$PROJECT/

echo "> git pull"

git pull

echo "> project build start"

./gradlew build

echo "> move first directory"

cd $REPOSITORY

echo "> build 파일 복사"

cp $REPOSITORY/$PROJECT/build/libs/*.jar $REPOSITORY/

echo "> running app pid"

CURRENT_PID=$(pgrep -f ${PROJECT}*.jar)

echo "current running pid: $CURRENT_PID"

if [-z "$CURRENT_PID"]; then
 echo "> 현재 구동중인 앱이 없음"

else
 echo "> kill -15 $CURRENT_PID"
 kill -15 $CURRENT_PID
 sleep 5
fi

echo "> new app deploy"

JAR_NAME=$(ls -tr $REPOSITORY/ | grep *.jar | tail -n 1)

echo "> jar name: $JAR_NAME"

nohup java -jar $REPOSITORY/$JAR_NAME 2>&1 &