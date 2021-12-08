#!/bin/bash

$SED -i '/org.mockito.kotlin:mockito-kotlin:/d' build.gradle*

$SED -i -z 's/dependencies {\([^}]*\)\n}/dependencies {\1\n  testImplementation("org.mockito.kotlin:mockito-kotlin:4.0.0")\n}/' build.gradle*

# shellcheck disable=SC2086
find src/test -name '*.kt' -exec $SED -e 's/verifyZeroInteractions/verifyNoInteractions/' -e 's/import com.nhaarman.mockitokotlin2/import org.mockito.kotlin/' {} \;
