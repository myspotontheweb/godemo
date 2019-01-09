
NAME=go-demo
TECH=go

.PHONY: generate clean

generate: chart Dockerfile .travis.yml

chart:
	@helm create --starter=teamwork $(NAME)
	@mv $(NAME) chart
	@find chart -type f -exec sed "s/__NAME__/$(NAME)/g" {} --in-place \;

Dockerfile: chart
	cp chart/build/$(TECH)/Dockerfile Dockerfile

.travis.yml: chart
	cp chart/build/$(TECH)/travis.yml .travis.yml

clean:
	rm -f Dockerfile
	rm -f .travis.yml
	rm -rf chart
