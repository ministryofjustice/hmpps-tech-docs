#!/bin/bash

PRODUCT_ID=${1?No product id specified}

# find health directory
CONFIG_DIR=$(find . -type d -name health | grep -v -e '/build/' -e '/test/')

typeset -i CONFIG_LINES=$(echo -n "$CONFIG_DIR" | wc -c)
if [[ "$CONFIG_LINES" -eq 0 ]]; then
  # try again with config directory
  CONFIG_DIR=$(find . -type d -name config | grep -v -e '/build/' -e '/test/')

  typeset -i CONFIG_LINES=$(echo -n "$CONFIG_DIR" | wc -c)
  if [[ "$CONFIG_LINES" -eq 0 ]]; then
    echo "Failed to find health or config directory to copy file into"
    exit 1
  fi
fi

for DIR in $(echo "$CONFIG_DIR");do
  PACKAGE_NAME=$(echo "$DIR" | sed -e 's/.*uk/uk/' -e 's#/#.#g')
    
  echo "package $PACKAGE_NAME

  import org.springframework.beans.factory.annotation.Value
  import org.springframework.boot.actuate.info.Info
  import org.springframework.boot.actuate.info.InfoContributor
  import org.springframework.stereotype.Component

  @Component
  class ProductIdInfoContributor(@Value(\"\\\${product-id:default}\") private val productId: String) : InfoContributor {

    override fun contribute(builder: Info.Builder) {
      builder.withDetail(\"productId\", productId)
    }
  }" > "$DIR/ProductIdInfoContributor.kt"


  git add "$DIR/ProductIdInfoContributor.kt"
done


for DEPLOY_DIR in $(find . -name 'helm_deploy'); do
  # ensure running latest service version
  sed -i -z 's/name: generic-service\n    version: [0-9].[0-9].[0-9]*/name: generic-service\n    version: 2.6.4/' $DEPLOY_DIR/*/Chart.yaml

  sed -i -e '/productId:/d' $DEPLOY_DIR/*/values.yaml

  # and add in the productId
  sed -i "s/nameOverride: \(.*\)/nameOverride: \1\n  productId: $PRODUCT_ID/" $DEPLOY_DIR/*/values.yaml
done
