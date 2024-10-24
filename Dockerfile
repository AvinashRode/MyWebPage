# Use an official Nginx image as the base
FROM nginx:latest

# Set the working directory to /usr/share/nginx/html
WORKDIR /usr/share/nginx/html

# Copy all files from the current directory to the container's working directory
COPY mywebpage/ .

# Expose port 80 to access the web server from the outside
EXPOSE 3000

# Start Nginx server when the container starts
CMD ["nginx", "-g", "daemon off;"]
