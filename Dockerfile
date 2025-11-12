# syntax=docker.io/docker/dockerfile:1.7-labs

# Stage 1: Base build stage
FROM python:3.13 AS builder

# Create and set the working directory
RUN mkdir /readme-website
WORKDIR /readme-website

# Set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy requirements
COPY ./readme-website/requirements-host.txt /readme-website/

# Install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements-host.txt

# Stage 2: Production stage
FROM python:3.13-slim

# Copy the Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

# Create /readme-website
RUN mkdir /readme-website

# Set the working directory
WORKDIR /readme-website

# Copy necessary parts of readme-website
COPY --exclude=.git --exclude=.gitignore ./readme-website/ .

# Set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy entrypoint.sh
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

# Expose the application port
EXPOSE 8000

# Start the application
CMD ["/entrypoint.sh"]
