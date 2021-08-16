# pull official base image
FROM python:3.8.11-slim

# set work directory
WORKDIR /usr/src/uswds

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN
brew tap bramstein/webfonttools
brew install woff2 sfnt2woff-zopfli ttfautohint

# run
CMD [ "./sources/build.sh" ]
