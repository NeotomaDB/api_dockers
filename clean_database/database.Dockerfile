# build stage
FROM postgis/postgis:17-3.5

RUN  apt update \
  && apt install -y wget \
  && rm -rf /var/lib/apt/lists/*

COPY . .
RUN mkdir -p /tmp/pg_data
ADD https://neotoma-remote-store.s3.us-east-2.amazonaws.com/clean_dump.tar.gz /tmp/pg_data/

# Pull in the database:
RUN chmod +x /dbruns/populate.sh

# ENTRYPOINT ["bash", "/dbruns/populate.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]