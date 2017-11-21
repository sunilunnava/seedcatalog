#!/bin/bash

export PATH=${PATH}:${M3_HOME}/bin

SERVICE_WORKSPACE=$2
SERVICE_NAME=$1

## ============================================================================
## Env Variables
## ============================================================================
# maven archetype
export ARCHETYPE_GROUP=com.att.ajsc
export ARCHETYPE_ARTIFACT=sdk-java-jersey-archetype
export ARCHETYPE_VERSION=6.3.3.8-oss



###################################################################
# Generate a new project from ajsc-archetype with Maven Command   #
###################################################################
echo "Running mvn archetype:generate with provided data..."

mvnresp=$(mvn archetype:generate \
  -DarchetypeGroupId=${ARCHETYPE_GROUP} \
  -DarchetypeArtifactId=${ARCHETYPE_ARTIFACT} \
  -DarchetypeVersion=${ARCHETYPE_VERSION} \
  -DgroupId=${SERVICE_GROUP} \
  -DartifactId=${SERVICE_ARTIFACT} \
  -Dversion=${SERVICE_VERSION} \
  -Dpackage=${SERVICE_PACKAGE} \
  -Dcontext-root=${CONTEXT_ROOT} \
  -Dservice-account=${SERVICE_ACCOUNT} \
  -Dkube-namespace=${KUBE_NAMESPACE} \
  -Dnamespace=${NAMESPACE} \
  -Ddocker-registry=${DOCKER_REGISTRY} \
  -Dservice-replicas=1 \
  -DarchetypeRepository=http://repo.maven.apache.org/maven2/ \
  -DinteractiveMode=false)

echo ${mvnresp} | grep 'BUILD SUCCESS'

if [ $?  != 0 ]; then
    echo "FAILED: Maven archetype generation failed";
    echo "${mvnresp}"

    # when you want to throw failure, you can exit the script with non-zero exit code.
    exit 1;

fi;

echo "Copying additional configuration files...."

###################################################################
# Additional tasks to setup eco pipeline including Jenkinsfile    #
###################################################################
# copy jenkinsfile and other required files to project
cp -f Jenkinsfile ${SERVICE_ARTIFACT}/


chmod -R 777 ${SERVICE_ARTIFACT}/


echo "Success: Archetype generated with project name: ${SERVICE_ARTIFACT}"