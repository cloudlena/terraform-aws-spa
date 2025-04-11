.PHONY: lint
lint:
	tflint --init
	tflint --recursive

.PHONY: test
test:
	cd test && go test -v -timeout 30m -p 1
