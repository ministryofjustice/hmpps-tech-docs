#!/bin/bash

$SED -E -e 's/spring-boot"\) version "[3-4].[0-4].[0-9]{1,}(-beta)?(-beta-2)?"$/spring-boot") version "4.0.0-beta"/' \
        -e 's/kotlin\("([^"]*)"\) version "1.[4-5].[0-9]*/kotlin("\1") version "1.6.0/' build.gradl*

./gradlew wrapper --gradle-version=7.3.1 --distribution-type=bin
