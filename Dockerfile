# Use the Ubuntu 22.04 image as the builder stage
FROM public.ecr.aws/lts/ubuntu:22.04 as builder

# Update the package repository and install ca-certificates
RUN apt-get update && apt-get install -y ca-certificates
# Install Golang
RUN apt-get install -y golang

# Set the working directory inside the container
WORKDIR /go/src/app

# Copy the source code file (http.go) into the container
ADD ./src/http.go /go/src/app
# Build the Go application inside the container
RUN go build http.go

# Create a new stage using the public ECR AWS Ubuntu 22.04 image
FROM public.ecr.aws/lts/ubuntu:22.04

# Copy the built binary from the previous stage to the root directory of the new stage
COPY --from=builder [ "/go/src/app/http", "/" ]

# Set the command to run when the container starts
CMD [ "/http" ]
