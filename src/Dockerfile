FROM python:3.7-alpine
WORKDIR /aiohttp
COPY requirements.txt /aiohttp
RUN apk add --no-cache gcc musl-dev postgresql-dev libffi-dev linux-headers\
    && pip install -r requirements.txt
EXPOSE 8080