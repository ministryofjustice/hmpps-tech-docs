./gradlew wrapper --gradle-version=7.4.2 --distribution-type=bin

./gradlew useLatestVersions

sed -i -E -e 's/spring-boot"\) version "[3-4].[0-3].[0-9]{1,}(-beta)?(-beta-[1-4])?"$/spring-boot") version "4.3.0-beta"/' build.gradle.kts

sed -i 's#openjdk:17-slim#openjdk:18-slim#' Dockerfile

sed -i 's#17.0#18.0#' .circleci/config.yml

sed -i -e 's/JavaLanguageVersion.of(17))/JavaLanguageVersion.of(18))/' \
       -e 's/jvmTarget = "17"/jvmTarget = "18"/' build.gradle.kts

# Orb version https://circleci.com/developer/orbs/orb/ministryofjustice/hmpps
sed -i -e 's#ministryofjustice/hmpps@3.[0-9]*#ministryofjustice/hmpps@5.1#' .circleci/config.yml

# Helm chart versions https://github.com/ministryofjustice/hmpps-helm-charts/releases
sed -i -z 's/name: generic-prometheus-alerts\n    version: 0.[0-9].[0-9]*/name: generic-prometheus-alerts\n    version: 1.0.0/' helm_deploy/*/Chart.yaml
sed -i -z 's/name: generic-service\n    version: [0-9].[0-9].[0-9]*/name: generic-service\n    version: 1.2.2/' helm_deploy/*/Chart.yaml

# Localstack https://hub.docker.com/r/localstack/localstack/tags
# sed -i 's#localstack/localstack:0.[0-9]*.[0-9]*#localstack/localstack:0.14.2#' docker-compose*
# find src/test -name '*.kt' -exec sed -i 's#("localstack/localstack").withTag("0.[0-9]*.[0-9]*")#("localstack/localstack").withTag("0.14.2")#' {} \;
