DOCKER_TAG = swift-junit-dev:latest
WORKDIR = /opt/swift-junit

clean:
	-rm -Rf SwiftJunit.xcodeproj

xcode:
	swift package generate-xcodeproj --enable-code-coverage

docker_test:
	docker build . -f docker/Docker-dev -t $(DOCKER_TAG)
	docker run --rm -v `pwd`:$(WORKDIR) $(DOCKER_TAG) make test
	docker run --rm -v `pwd`:$(WORKDIR) $(DOCKER_TAG) make lint

test:
	swift test

lint:
	swiftformat Sources,Tests --lint
