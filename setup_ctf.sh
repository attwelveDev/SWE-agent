#!/usr/bin/env bash

docker build --platform linux/amd64 -f docker/enigma.Dockerfile -t sweagent/swe-ctf:latest  .
docker network create ctfnet