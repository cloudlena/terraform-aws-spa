.PHONY: lint
lint:
	terraform validate

.PHONY: test
test:
	cd test && go test -v -timeout 30m -p 1
