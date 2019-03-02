docker-compose -f docker-compose-cli.yaml down --volumes
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)