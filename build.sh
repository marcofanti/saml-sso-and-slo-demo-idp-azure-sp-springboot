#!/bin/sh

FILE=src/main/resources/saml/signature.cer
if test -f "$FILE"; then
    echo "$FILE exists."
else
    echo "Please copy signature.cer to $FILE."
    exit
fi

if [ x"${JAVA_HOME}" == "x" ]; then 
     echo "JAVA_HOME is not set."
     exit
else
    echo "JAVA_HOME is set to $JAVA_HOME."
fi

pushd src/main/resources/saml/

rm delete-me-please.txt

keytool -importcert -noprompt -alias adfssigning -storepass secret -keystore samlKeystore.jks -trustcacerts -file signature.cer

keytool -genkeypair -alias acme -storepass secret -keypass secret -keyalg RSA -keysize 2048 -validity 10000 -keystore samlKeystore.jks -dname "CN=Acme CEO, OU=Acme DevOps, O=Acme Software, L=New York, ST=NY, C=US"

keytool -genkeypair -storepass secret -alias acme -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore acme.p12 -validity 3650 -dname "CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown"

popd

echo "Build finished. Modify /src/main/resources/application.yaml and run 'mvn clean spring-boot:run'"
