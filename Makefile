all: build clean build-web
.PHONY: all

watch: build-web
	stack exec site watch
.PHONY: watch

clean: build
	stack exec site clean
	rm -rf About.org
	rm -rf posts
.PHONY: clean

build:
	stack build
.PHONY: build

add-header:
	python3 add_header.py
.PHONY: add-header

build-web: clean add-header
	stack exec site build
.PHONY: build-web

deploy: build-web
	git checkout master && cp -a public/. ./ && git add --all && git commit -m "Publish." && git push && git checkout dev
