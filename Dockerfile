# pull official base image
FROM python:3.8.11-slim

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN apt-get update && apt-get install git rsync make g++ ttfautohint libz-dev -y

RUN git clone --recursive https://github.com/google/woff2.git woff2 \
    && cd woff2 \
    && make

RUN git clone --recursive https://github.com/bramstein/sfnt2woff-zopfli.git \
    && cd sfnt2woff-zopfli \
    && make

ENV PATH "${PATH}:/sfnt2woff-zopfli:/woff2"

WORKDIR /public_sans

# run
CMD [ "./sources/build-font.sh" ]
