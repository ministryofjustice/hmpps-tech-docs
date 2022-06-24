./gradlew wrapper --gradle-version=7.4.2 --distribution-type=bin

./gradlew useLatestVersions

# latest gradle spring boot plugin
sed -i -E -e 's/spring-boot"\) version "[3-4].[0-3].[0-9]{1,}(-beta)?(-beta-[1-4])?"$/spring-boot") version "4.3.0-beta-1"/' build.gradle.kts

# jdk 18 in dockerfile
sed -i 's#openjdk:17-slim#openjdk:18-slim#' Dockerfile

# jdk 18 in circleci config
sed -i 's#17.0#18.0#' .circleci/config.yml

# jdk 18 in gradle build
sed -i -e 's/JavaLanguageVersion.of(17))/JavaLanguageVersion.of(18))/' \
       -e 's/jvmTarget = "17"/jvmTarget = "18"/' build.gradle.kts

# disable veracode pipeline scan as no support for jdk 18 or kotlin 1.7
sed -i -z 's~      - hmpps/veracode_pipeline_scan:\n          context:\n            - hmpps-common-vars\n            - veracode-credentials~      # currently disabled as no support for jdk 18 or kotlin 1.7\n      # - hmpps/veracode_pipeline_scan:\n      #   context:\n      #     - hmpps-common-vars\n      #     - veracode-credentials~' .circleci/config.yml
sed -i -z 's~      - hmpps/veracode_pipeline_scan:\n          slack_channel: << pipeline.parameters.alerts-slack-channel >>\n          context:\n            - veracode-credentials\n            - hmpps-common-vars~      # currently disabled as no support for jdk 18 or kotlin 1.7\n      # - hmpps/veracode_pipeline_scan:\n      #   slack_channel: << pipeline.parameters.alerts-slack-channel >>\n      #   context:\n      #     - veracode-credentials\n      #     - hmpps-common-vars~' .circleci/config.yml


# Orb version https://circleci.com/developer/orbs/orb/ministryofjustice/hmpps
sed -i -e 's#ministryofjustice/hmpps@3.[0-9]*#ministryofjustice/hmpps@5.1#' .circleci/config.yml

# Helm chart versions https://github.com/ministryofjustice/hmpps-helm-charts/releases
sed -i -z 's/name: generic-prometheus-alerts\n    version: 0.[0-9].[0-9]*/name: generic-prometheus-alerts\n    version: 1.0.0/' helm_deploy/*/Chart.yaml
sed -i -z 's/name: generic-service\n    version: [0-9].[0-9].[0-9]*/name: generic-service\n    version: 1.2.2/' helm_deploy/*/Chart.yaml

# Localstack https://hub.docker.com/r/localstack/localstack/tags
# sed -i 's#localstack/localstack:0.[0-9]*.[0-9]*#localstack/localstack:0.14.2#' docker-compose*
# find src/test -name '*.kt' -exec sed -i 's#("localstack/localstack").withTag("0.[0-9]*.[0-9]*")#("localstack/localstack").withTag("0.14.2")#' {} \;
