FROM node:alpine

RUN apk fix && \
    apk --no-cache --update add git git-lfs gpg less openssh patch perl curl && \
    git lfs install
RUN mkdir /usr/src
RUN mkdir -p /usr/src/app && \
    curl -fSL "https://github.com/NeotomaDB/tilia_api/archive/refs/tags/v1.1.0.tar.gz" -o /tmp/api.tar.gz && \
    tar -xzf /tmp/api.tar.gz -C /usr/src/app --strip-components=1 && \
    rm /tmp/api.tar.gz
WORKDIR /usr/src/app
RUN npm install

EXPOSE 3002

CMD ["npm", "run", "start"]