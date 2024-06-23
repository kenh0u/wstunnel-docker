FROM ubuntu:noble AS build

ENV WSTUNNELVER 9.7.0
ENV WSTUNNELARCH amd64

WORKDIR /root
RUN apt update && \
    apt install -y wget && \
    wget 'https://github.com/erebe/wstunnel/releases/download/v'${WSTUNNELVER}'/wstunnel_'${WSTUNNELVER}'_linux_'${WSTUNNELARCH}'.tar.gz' \ 
      -O wstunnel.tar.gz && \
    tar xvf wstunnel.tar.gz && \
    test -e wstunnel && \
    chmod a+x wstunnel

FROM gcr.io/distroless/static-debian12
COPY --from=build /root/wstunnel /bin/

EXPOSE 80
CMD ["/bin/wstunnel","server","ws://[::]:80"]
