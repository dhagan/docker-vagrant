docker run -p 8080:8080 -p 8001:8001 -d --name drools-wb docker_jboss-drools-workbench-showcase
docker run -p 8180:8080 -d --name kie-server --link drools-wb:kie_wb docker_jboss-kie-server-showcase
docker ps -a
