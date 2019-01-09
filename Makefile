
NAME=go-demo

.PHONY: generate clean

generate: chart Dockerfile .travis.yml

chart:
	@helm create --starter=teamwork $(NAME)
	@mv $(NAME) chart
	@find chart -type f -exec sed "s/__NAME__/$(NAME)/g" {} --in-place \;

Dockerfile: chart
	cp chart/build/go/Dockerfile Dockerfile

.travis.yml: chart
	cp chart/build/go/travis.yml .travis.yml

clean:
	rm Dockerfile
	rm .travis.yml
	rm -rf chart
