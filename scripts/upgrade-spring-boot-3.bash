#!/bin/bash
. "${DIR}"/common-functions.bash

./gradlew wrapper --gradle-version=7.6 --distribution-type=bin

./gradlew useLatestVersions

find . -name '*.kt' -exec $SED -i \
 -e 's/import javax.servlet/import jakarta.servlet/' \
 -e 's/import javax.validation/import jakarta.validation/' \
 -e 's/import javax.transaction/import jakarta.transaction/' \
 -e 's/import javax.persistence/import jakarta.persistence/' \
 -e 's/EnableGlobalMethodSecurity/EnableMethodSecurity/' \
 -e 's/authorizeRequests/authorizeHttpRequests/' \
 -e 's/antMatchers/requestMatchers/' \
 -e 's/import org.hibernate.annotations.Type/import org.hibernate.type.YesNoConverter\nimport jakarta.persistence.Convert/' \
 -e 's/@Type(type = "yes_no")/@Convert(converter = YesNoConverter::class)/' \
 -e 's/antMatchers/requestMatchers/' \
 -e 's/import org.springframework.boot.web.server.LocalServerPort/import org.springframework.boot.test.web.server.LocalServerPort/' \
 {} \;

find . -name '*.yml' -exec $SED -i \
 -e 's/PostgreSQL10Dialect/PostgreSQLDialect/' \
 {} \;


$SED -i 's/com.vladmihalcea:hibernate-types-52/com.vladmihalcea:hibernate-types-60/' build.gradle.kts
