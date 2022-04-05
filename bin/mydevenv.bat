@echo off
docker run -it --rm --net host -v "%UserProfile%"/.kube/:/root/.kube/ -v "%cd%":/work -w /work mykubeenv:latest