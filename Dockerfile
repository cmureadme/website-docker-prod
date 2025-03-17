# syntax=docker.io/docker/dockerfile:1.7-labs

# Stage 1: Base build stage
FROM python:3.13 AS builder

# Clone readme-website
ADD git@github.com/cmureadme/readme-website.git /readme-website

# Set the working directory
WORKDIR /readme-website

# Set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Production stage
FROM python:3.13-slim

RUN useradd -m -r readme && \
    mkdir /readme-website && \
    chown -R readme /readme-website

# Copy the Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

# Set the working directory
WORKDIR /readme-website

# Copy necessary parts of readme-website
COPY --from=builder --chown=readme:readme --exclude=.git --exclude=.gitignore --exclude=db_sample.json --exclude=media_sample.zip /readme-website/ .

# Set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
USER readme

# Expose the application port
EXPOSE 8000

# Start the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "readme_website.wsgi"]
