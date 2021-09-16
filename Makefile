BIN_NAME := hammer
GOFILES := $(shell find . -type f -name '*.go')

build: bin/$(BIN_NAME)

bin/$(BIN_NAME): $(GOFILES)
	go build -o $@ .

build-cross: clean
	GOOS=linux  GOARCH=amd64 go build -o dist/$(BIN_NAME)_amd64_linux
	GOOS=darwin GOARCH=amd64 go build -o dist/$(BIN_NAME)_amd64_darwin

clean:
	rm -rf bin dist

deps:
	go get -t ./...
	go mod tidy

test:
	go test -race -v ./...
