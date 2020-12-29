setup:
	mkdir -p backup

build: setup
	docker build -t ldap_master_image .

run: build
	docker run -d --name ldap_master -p 8080:80 -p 389:389 -p 636:636 -v ${PWD}/backup:/backup ldap_master_image

stop:
	docker stop ldap_master

start:
	docker start ldap_master

attach:
	docker exec -it ldap_master /bin/bash

clean: stop
	docker rm ldap_master
