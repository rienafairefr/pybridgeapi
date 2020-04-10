.PHONY: clean

VERSION ?= $(shell pipenv run python -c "from setuptools_scm import get_version;print(get_version())")
OPENAPIGEN_VERSION ?= v4.2.3

clean:
	rm -rf api

docker_image: $(wildcard generator/**/*) $(wildcard generator/*)
	docker build -t custom-codegen generator

api: swagger.yaml Makefile
	docker run --rm --user `id -u`:`id -g` -v ${PWD}:/local custom-codegen generator \
	           generate -i /local/swagger.yaml \
	           --git-user-id rienafairefr \
	           --git-repo-id pybridgeapi \
	           -t /local/templates \
	           -g python -o /local/api -DprojectName=pybridgeapi -DpackageName=bridge \
	           -DpackageVersion="$(VERSION)" -DappDescription="This is pybridgeapi, an autogenerated package to access bridgeapi.io"\
	           -DappName="pybridgeapi" -DinfoEmail="rienafairefr@gmail.com"
