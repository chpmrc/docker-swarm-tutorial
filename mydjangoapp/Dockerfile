FROM python:3.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .

EXPOSE 8000