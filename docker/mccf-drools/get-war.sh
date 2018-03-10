#!/bin/bash

mkdir war 
curl -o war/drools-wb.war https://repository.jboss.org/nexus/content/groups/public-jboss/org/kie/kie-drools-wb/7.3.0.Final/kie-drools-wb-7.3.0.Final-wildfly10.war 

curl -o war/kie-drools-wb-7.3.1-20171009.134859-240-wildfly10.war https://repository.jboss.org/nexus/content/groups/public-jboss/org/kie/kie-drools-wb/7.3.1-SNAPSHOT/kie-drools-wb-7.3.1-20171009.134859-240-wildfly10.war

curl -o war/kie-server.war https://repository.jboss.org/nexus/content/groups/public-jboss/org/kie/server/kie-server/7.3.0.Final/kie-server-7.3.0.Final-ee7.war

curl -o war/kie-server-7.3.1-20171007.192308-74-ee7.war https://repository.jboss.org/nexus/content/groups/public-jboss/org/kie/server/kie-server/7.3.1-SNAPSHOT/kie-server-7.3.1-20171007.192308-74-ee7.war
