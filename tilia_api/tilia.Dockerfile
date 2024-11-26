FROM node:alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch perl wget && \
    git lfs install
RUN mkdir /usr/src
ENTRYPOINT ["tail", "-f", "/dev/null"]

RUN wget 'http://github.com/NeotomaDB/tilia_api/archive/refs/tags/v1.0.0.tar.gz' -P /tmp
RUN tar -xvf /tmp/v1.0.0.tar.gz -C /usr/src
WORKDIR /usr/src/tilia_api-1.0.0
RUN yarn install
EXPOSE 3006

CMD ["yarn", "run", "start"]