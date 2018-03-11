# Docker Development Environment

## Drools setup

vagrant up
vagrant ssh
cd docker/drools-mccf
./get-war.sh
docker-compose -f dc-drools.yml up

## Setup

There are two possible paths for setup: **New SSH Keys** and **Existing Keys**.

### New SSH Keys (easier)

**1**) Create the single VM:

    vagrant up

Upon successful completion, the VM is setup.

SSH to the following location (username and password are `vagrant`/`vagrant`):

    192.168.100.10

**2**) Create keys with the following:

	ssh-keygen

Though the default location is fine, to avoid conflict, you might consider set the location to `/home/vagrant/.ssh/halfaker_bb_id_rsa`

**3**) Post your public key to Bitbucket.org.

Follow the instructions at the following link for complete details:

[https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh1](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-ssh1)

To summarize: copy the contents of `/home/vagrant/.ssh/halfaker_bb_id_rsa.pub` to the "Add SSH key" area in Bitbucket settings. 

**3b**, **OPTIONAL**) To avoid getting asked for your password repeatedly throughout the download process, run (copy/paste) the following in SSH to allow the next script to pull your repos:

    eval `ssh-agent -s`
    ssh-add ~/.ssh/halfaker_bb_id_rsa

**4**) Pull and setup repos:

	cd docker
	./prepare.sh

It's important to backup your id_rsa (**keep private**) and id_rsa.pub. You can use keys-template.sh as a place to store your keys for future deployments. 

### Existing SSH Keys (advanced / more streamlined)

**1**) Before beginning, make sure you placed your SSH keys into the `keys.sh` file. Bitbucket requires these keys.

**2**) Create the single VM:

    vagrant up

Upon successful completion, the VM is setup. Next, you need to install your SSH keys and pull the repos:

To access the VM, SSH to the following location (username and password are `vagrant`/`vagrant`):

    192.168.100.10

**3**) Install your SSH keys with the script your updated in step 1:

	./docker/keys.sh

**3b**, **OPTIONAL**) To avoid getting asked for your password repeatedly throughout the download process, run (copy/paste) the following in SSH to allow the next script to pull your repos:

    chmod 600 ~/.ssh/config
    eval `ssh-agent -s`
    ssh-add ~/.ssh/halfaker_bb_id_rsa

**4**) Pull and setup repos:

	cd docker
	./prepare.sh

Setup is complete.

## Usage

### Shell Access

SSH to the following location:

    192.168.100.10

Username and password are `vagrant`/`vagrant`. This will place you in your home directory (`~`).

This gives you full access to the VM.

**TIP:** You can SSH into the machine as many times as needed with different SSH session. This will be important when you want to monitor multiple parts of TAS simultaneously.

### File Access

To view your files, access the following location in Windows:

    \\192.168.100.10\vagrant\docker\workspace

Username and password are `vagrant`/`vagrant`.

This is where all project files exist.

You will open this folder in your preferred IDE (e.g. Code/Atom).

## Using Docker

In an SSH session, move to the docker/workspace folder (`cd ~/docker/workspace`)

Run the Docker infrastructure:

	docker-compose up

This will build and start the entire Docker infrastructure.

> Use `docker-compose up -d` to run it in the background.

The following containers will be started in the background (more to be added as the project progresses):

* nginx (`tas-gateway`)
* TAS Core API (`tascore-api`)
* TAS Core UI (`tascore-ui`)
* FHIR (`tas-fhir`)

**TIP:** Modify the `docker-compose.yml` file to meet your needs at the moment. You may not always need the UI, database, queue, or FHIR server.

## Accessing the in infrastructure

Once the infrastructure is running, you an access all components via a single entry point (192.168.100.10 is just a sample IP):

* UI - `http://192.168.100.10`

* TASCORE API - `http://192.168.100.10:3001/_/v1/health` (also: `http://192.168.100.10:3001/api/core/v1/health`)

* FHIR - `http://192.168.100.10:8080`

* Elasticsearch - `http://192.168.100.10/search`

* Elasticsearch (same as previous, just direct access) - `http://192.168.100.10:9200`

> Gateway access follows the pattern of /api/{API\_NAME}/{API\_PARAMETERS}. To access an API directly, use underscore (`_`) as seen above.

## Ng Image

This environment has a special Docker image called `tas/ng`. You can use this image to run Node/Angular/JavaScript related functionality, even if the VM isn't configured to support it. This also comes in handy when ports during tests might conflict.

This is run with a command similar to the following, from the source folder of whatever you're working with:

    docker run -v `pwd`:/var/app tas/ng COMMAND_HERE

Everything after the image name `ng` will be passed to the image and run in the context of the container.

### Examples

### UI (Angular)

Run NPM (Angular) tests:

    docker run -v `pwd`:/var/app tas/ng npm test

Run Angular e2e tests:

    docker run -v `pwd`:/var/app tas/ng npm run e2e


### Node

Node uses the `tas/node8` image, not the `tas/ng` image.

Run Mocha tests:

    docker run -v `pwd`:/var/app tas/node8 mocha

Run Mocha tests with watch:

    docker run -v `pwd`:/var/app tas/node8 mocha -w
    
Run Mocha tests on specific file with watch:

    docker run -v `pwd`:/var/app tas/node8 mocha -w test/my-file-name.js
    
## Viewing Docker Output

To view the output of each, you can use the `docker logs` command:

    docker logs <CONTAINER NAME> -f

This will let you view your entire infrastructure at one. Run each of the following in a different SSH session for the complete picture:

    docker logs tas-gateway -f
    docker logs tascore-api -f
    docker logs tascore-ui -f
    docker logs tas-fhir -f

> The -f flag means enables log following, meaning you'll have a running log of that container's output.

## More Commands

To stop and remove the infrastructure (use `docker-compose` up to restart):

	docker-compose down

You can use the following command to view the running containers:

    docker container ls

You can use the following command to remove all containers (helpful for updating images):

    docker-compose rm

**Your files are external to the Docker images, so they will not be affected -- but you should still maintain proper backup practices.**

> If updating a Docker image, after removing containers, it's often helpful to run `docker-compose build` to rebuild containers before loading again. Use `docker-compose build --no-cache` to force a full rebuild from scratch.

(**CAUTION**) You can manually stop all containers with the following command:

    docker stop `docker container ls -qa`

> This will remove **ALL** containers, not just ones related to this project.

(**CAUTION**) You can manually remove all containers with the following command (ultimately the same as `docker-compose down`):

    docker rm `docker container ls -qa`    

(**Advanced**) To enter a container, run the following:

	docker exec -it <CONTAINER NAME> sh

Example: `docker exec -it tascore-ui sh`

> Some containers have Bash installed, thus `docker exec -it <CONTAINER NAME> /bin/bash` will work, and give better features. **Try /bin/bash first.**

## Examples of Starting Manually

*This section assumes the images have been built.*

To start a container manually, use a variant of one of the following:

### nginx

    docker run -d --rm --name tas-gateway -p 80:80 -p 3000:3000 -p 3001:3001 -p 8080:8080 -p 9200:9200 tas-gateway

Because all other containers attach to the `tas-gateway` container, `tas-gateway` must be deployed first.

### TAS Core API

    docker run \
        --name tascore-api \
        -dt \
        --rm \
        --network container:tas-gateway \
        -v `pwd`/tascore-api/src:/var/app \
        -e "PORT=3001" \
        -e "TAS_FILESYSTEM_DATA_ROOT=/var/log/tas" \
        -e "DEBUG=api,api-internal,data,fs,core,memory,webclient" \
        -e "LIVE_HTTP=true" \
        -e "TAS_ELASTICSEARCH_CONNECTION_STRING=http://127.0.0.1:9200" \
        tascore-api

### FHIR

    docker run --name tas-fhir --rm -dt --network container:tas-gateway tas-fhir

### TAS Core UI

    docker run --name tascore-ui -dt --rm --network container:tas-gateway -v `pwd`/tascore-ui:/var/app tascore-ui

### Elasticsearch

    docker run \
     -dt \
     --network container:tas-gateway \
     -v `pwd`/elasticsearch-data:/usr/share/elasticsearch/data \
     -e "xpack.security.enabled=false" \
     -e "discovery.type=single-node" \
     docker.elastic.co/elasticsearch/elasticsearch:5.6.4


## Troubleshooting

In case of the following message:

    docker: Error response from daemon: connection error: desc = "transport: dial unix /var/run/docker/containerd/docker-containerd.sock: connect: connection refused".

Restart Docker:

    sudo systemctl restart docker
    