# Dockerfile
FROM node:7.8.0-alpine
 
WORKDIR /app
 
# Copy package files and install dependencies
COPY package.json package-lock.json* ./
RUN npm install --production
 
# Copy application source
COPY . .
 
# Expose the internal port
EXPOSE 3000
 
# Start the application
CMD ["npm", "start"]
