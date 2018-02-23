FROM centos:7

WORKDIR /var/app 

RUN yum install -y epel-release && \
    yum install -y nodejs java-1.8.0-openjdk fontconfig freetype freetype-devel fontconfig-devel libstdc++ bzip2 && \
    npm install -g @angular/cli && \
    npm install -g phantomjs-prebuilt

CMD ["/bin/bash"] 
