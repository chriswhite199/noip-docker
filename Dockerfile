FROM rust:latest as build

WORKDIR /usr/src/myapp
RUN apt update && apt install musl-tools -y
RUN wget https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_3.0.0.tar.gz \
	&& tar -xvf noip-duc_3.0.0.tar.gz \
	&& cd noip-duc_3.0.0 \
	&& rustup target add x86_64-unknown-linux-musl \
	&& cargo install --target=x86_64-unknown-linux-musl --path .

RUN ls -l /usr/local/cargo/bin/noip-duc \
	&& ldd /usr/local/cargo/bin/noip-duc

FROM scratch
COPY --from=build /usr/local/cargo/bin/noip-duc /noip-duc
USER 1000

ENTRYPOINT [ "/noip-duc" ]
