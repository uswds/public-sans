#!/bin/sh

docker build -t public_sans_temp . --progress=plain
docker run --mount type=bind,source="$(pwd)",target=/public_sans public_sans_temp
