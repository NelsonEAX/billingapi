FROM python:3.7-alpine
RUN apk add --no-cache gcc musl-dev postgresql-dev libffi-dev linux-headers
COPY requirements.txt /home/aiohttp/
WORKDIR /home/aiohttp/
RUN pip install -r requirements.txt
EXPOSE 8080