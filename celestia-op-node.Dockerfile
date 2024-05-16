FROM golang:1.21.1 as op

WORKDIR /app

ENV REPO=https://github.com/celestiaorg/optimism.git
# for verification:
ENV COMMIT=v1.2.0-OP_v1.7.0-CN_v0.12.4

RUN git clone $REPO . --branch $COMMIT

RUN cd op-node && \
    make op-node

FROM alpine

RUN apk add --no-cache jq curl

WORKDIR /app

COPY --from=op /app/op-node/bin/op-node /usr/local/bin
COPY --chmod=755 op-node-entrypoint /opt/conduit/bin/op-node-entrypoint
COPY --chmod=755 op-node-entrypoint.celestia.sh /opt/conduit/bin/op-node-entrypoint.celestia.sh

ENTRYPOINT [ "/opt/conduit/bin/op-node-entrypoint.celestia.sh" ]
