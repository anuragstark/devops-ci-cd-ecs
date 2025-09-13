FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy the rest of the application files
COPY . .

# Expose the port the app runs on
EXPOSE 3000

USER node
# Command to run the application
CMD ["npm", "start"]