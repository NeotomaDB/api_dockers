# build stage
FROM postgis/postgis:17-3.5

RUN  apt update \
  && apt install -y wget \
  && rm -rf /var/lib/apt/lists/*

COPY . .
# Pull in the database:
RUN mkdir -p /tmp/pg_data
RUN chmod +x /dbruns/populate.sh

ENTRYPOINT ["bash", "/dbruns/populate.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]