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


$SED -i \
  -e 's/com.vladmihalcea:hibernate-types-52/com.vladmihalcea:hibernate-types-60/' \
  -e 's/testImplementation("com.github.tomakehurst:wiremock-standalone:2[^"]*")/testImplementation("com.github.tomakehurst:wiremock-jre8-standalone:2.35.0")/' \
  -e 's/testImplementation("io.jsonwebtoken:jjwt:0.9.1")/testImplementation("io.jsonwebtoken:jjwt-impl:0.11.5")\n  testImplementation("io.jsonwebtoken:jjwt-jackson:0.11.5")/' \
  -e 's/implementation("org.springdoc:springdoc-openapi-ui:1[^"]*")/implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.0.0")/' \
  -e 's/implementation("org.springdoc:springdoc-openapi-webflux-ui:1[^"]*")/implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.0.0")/' \
  build.gradle.kts

$SED -i \
  -e '/implementation("org.springdoc:springdoc-openapi-kotlin:1.6.13")/d' \
  -e '/implementation("org.springdoc:springdoc-openapi-security:1.6.13")/d' \
  build.gradle.kts
