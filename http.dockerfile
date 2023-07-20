FROM public.ecr.aws/lts/ubuntu:22.04 as base
RUN apt-get update && apt-get install -y ca-certificates

FROM base AS gobuilder
RUN apt-get install -y golang

FROM gobuilder AS chisel
WORKDIR /root
RUN go install github.com/canonical/chisel/cmd/chisel@latest
RUN mv go/bin/chisel /usr/bin/

FROM gobuilder AS builder
WORKDIR /go/src/app
ADD ./src/http.go /go/src/app
RUN go build http.go && mv http app

FROM chisel AS chiseler
WORKDIR /staging
RUN ["chisel", "cut", "--root", "/staging", \
    "base-files_base", \
    "base-files_release-info", \
    "libc6_libs" ]

FROM scratch
COPY --from=chiseler [ "/staging/", "/" ]
COPY --from=builder [ "/go/src/app/app", "/" ]
CMD [ "/app" ]
