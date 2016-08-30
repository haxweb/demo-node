FROM node:6.4.0-wheezy

MAINTAINER Axel Agarrat <axelagarrat@gmail.com>

# Create root dir for the node.js app
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# Copy sources & install app dependencies
COPY . /usr/src/app/
RUN npm install

# Expose outside the container, the following port list :
EXPOSE 8080 80 443

# start the app with npm start
CMD [ "npm", "start" ]
