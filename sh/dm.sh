docker ps -a | grep 'ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm

sudo docker rmi $(sudo docker images -f "dangling=true" -q)
