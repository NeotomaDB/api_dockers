FROM node:alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch perl wget && \
    git lfs install
RUN mkdir /usr/src
RUN cd /tmp && \
    wget 'https://github.com/NeotomaDB/api_nodetest/archive/refs/tags/APIv2.0.1.tar.gz' -P /tmp
RUN tar -xvf /tmp/APIv2.0.1.tar.gz -C /usr/src
WORKDIR /usr/src/api_nodetest-APIv2.0.1
RUN yarn install
EXPOSE 3001

CMD ["yarn", "run", "start"]