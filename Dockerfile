# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if present)
# to leverage Docker caching for dependencies
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Expose the port the app runs on.
# The Heroku sample app often uses process.env.PORT, but 5000 is a common default for Node.js
EXPOSE 5000

# Define the command to run the application
CMD [ "npm", "start" ]
