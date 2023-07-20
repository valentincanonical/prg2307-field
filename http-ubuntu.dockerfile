FROM public.ecr.aws/lts/ubuntu:22.04 as builder
RUN apt-get update && apt-get install -y ca-certificates
RUN apt-get install -y golang
WORKDIR /go/src/app
ADD ./src/http.go /go/src/app
RUN go build http.go

FROM public.ecr.aws/lts/ubuntu:22.04
COPY --from=builder [ "/go/src/app/http", "/" ]
CMD [ "/http" ]
