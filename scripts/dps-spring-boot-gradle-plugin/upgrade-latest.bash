#!/usr/bin/env bash

sed -i '' -e 's/spring-boot") version "[0-9].[0-9].[0-9]*\(-beta\)*/spring-boot") version "4.5.1-beta/' build.gradl*

# Or multiple updates...
#sed -i '' -e 's/spring-boot") version "3.[0-3].[0-9]\(-beta\)*/spring-boot") version "3.3.9/' \
#          -e 's/kotlin("\([^"]*\)") version "1.[4-5].[0-9]*/kotlin("\1") version "1.5.31/' build.gradl*

# Holding off doing the gradle wrapper until we resolve: DT-2653
#./gradlew wrapper --gradle-version=7.2 --distribution-type=bin

# run a small gradle task to generate trivy ignore
./gradlew ktlintFormat
