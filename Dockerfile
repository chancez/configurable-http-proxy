FROM node:12.17.0-alpine
# ref: https://hub.docker.com/_/node?tab=tags&name=12

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Useful tools for debugging
RUN apk add --no-cache jq curl

RUN mkdir -p /srv/configurable-http-proxy
COPY . /srv/configurable-http-proxy/
WORKDIR /srv/configurable-http-proxy
ENV PATH=/srv/configurable-http-proxy/bin:$PATH

# Install configurable-http-proxy according to package-lock.json (ci) without
# devDepdendencies (--production), then uninstall npm which isn't needed.
RUN npm ci --production \
 && npm uninstall -g npm

# Switch from the root user to the nobody user
USER 65534

# Expose the proxy for traffic to be proxied (8000) and the
# REST API where it can be configured (8001)
EXPOSE 8000
EXPOSE 8001

ENTRYPOINT ["/srv/configurable-http-proxy/chp-docker-entrypoint"]
