.PHONY: test
test:
	cd test && go test -v -timeout 30m
