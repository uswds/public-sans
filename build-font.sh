#!/bin/sh

docker build -t public_sans_temp .
docker run -v $(pwd):/usr/src/uswds public_sans_temp
