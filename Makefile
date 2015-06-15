
all: endless-joy

.PHONY: build
build:
	cabal2nix . > rabbittool.nix
	cabal2nix --no-check \
		http://hackage.haskell.org/package/amqp-0.12.2/amqp-0.12.2.tar.gz \
		> amqp.nix
	nix-build .

.PHONY: run-producer run-consumer
run-producer run-consumer: run-%:
	@env \
		rabbittool.host=$${host-localhost} \
		rabbittool.path=$${path-/tv} \
		rabbittool.user=$${user-tv} \
		rabbittool.pass=$${pass-correcthorse} \
		./result/bin/$*

ifdef remote_host
.PHONY: push
push:
	rsync -va . $(remote_host):src/rabbittool

.PHONY: remote-build
remote-build: push
	ssh $(remote_host) make -C src/rabbittool build

endif
