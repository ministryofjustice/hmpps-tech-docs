#!/bin/bash

sed -i'' '/org.mockito.kotlin:mockito-kotlin:/d' build.gradle*

sed -i'' -z 's/dependencies {\([^}]*\)\n}/dependencies {\1\n  testImplementation("org.mockito.kotlin:mockito-kotlin:4.0.0")\n}/' build.gradle*

find src/test -name '*.kt' -exec sed -i'' -e 's/verifyZeroInteractions/verifyNoInteractions/' -e 's/import com.nhaarman.mockitokotlin2/import org.mockito.kotlin/' {} \;
