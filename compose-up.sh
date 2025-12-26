# mkdir -p ~/dev/container-storage/{home,apt_lists,apt_cache,dpkg,usr_local,etc}
docker rm -f dev-box
docker image rm dev-box:latest
# sudo rm -rfv ~/dev/container-storage/dev-box
docker compose up --build -d
docker exec -it dev-box bash