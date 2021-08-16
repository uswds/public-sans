# pull official base image
FROM linuxbrew/brew:latest

# set work directory
WORKDIR /usr/src/uswds

# install environment packages
RUN apt-get update && apt-get install python3.8 pip rsync -y

# bring in our python requirements
COPY requirements.txt .

# install python dependencies
RUN pip install -r requirements.txt

# install webfont tools
RUN brew tap bramstein/webfonttools \
    && brew install woff2 sfnt2woff-zopfli ttfautohint

# run
CMD [ "./sources/build.sh" ]
