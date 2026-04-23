FROM alpine:3.21 AS builder

RUN set -eux \
    && apk add --no-cache \
        python3 \
        py3-pip

RUN set -eux \
    && python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN set -eux \
    && python3 -m pip install --no-cache-dir \
        azure-cli \
    && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf 

# IMAGE FINALE
FROM alpine:3.21

ENV PATH="/opt/venv/bin:$PATH"

RUN set -eux \
    && apk add --no-cache \
        python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
	&& find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf 

RUN set -eux \
    && apk add --no-cache \
        icu-libs \
        jq \
        docker-cli

COPY --from=builder /opt/venv /opt/venv
