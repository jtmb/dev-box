# mkdir -p ~/dev/container-storage/{home,apt_lists,apt_cache,dpkg,usr_local,etc}
docker rm -f wsl-dev
docker image rm wsl-dev:latest
# sudo rm -rfv ~/dev/container-storage/wsl-dev
docker compose up --build -d
docker exec -it wsl-dev bash