#!/bin/sh

docker build --no-cache -t public_sans_temp . --progress=plain
docker run -v "$(pwd)":/public_sans public_sans_temp
