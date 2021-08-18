# pull official base image
FROM python:3.8.11-slim

# set work directory
WORKDIR /public_sans

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN apt-get update && apt-get install git rsync make g++ ttfautohint libz-dev -y

RUN git clone --recursive https://github.com/google/woff2.git ../woff2 \
    && cd ../woff2 \
    && make

RUN git clone --recursive https://github.com/bramstein/sfnt2woff-zopfli.git ../sfnt2woff-zopfli \
    && cd ../sfnt2woff-zopfli \
    && make

ENV PATH "${PATH}:/sfnt2woff-zopfli:/woff2"

# run
CMD [ "./sources/build.sh" ]
