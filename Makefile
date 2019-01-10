
NAME=godemo
TECH=godemo
PORT=8080

.PHONY: generate clean

generate: chart Dockerfile .travis.yml skaffold.yaml

chart:
	@helm create --starter=teamwork $(NAME)
	@mv $(NAME) chart
	@find chart -type f -exec sed "s/__NAME__/$(NAME)/g" {} --in-place \;
	@find chart -type f -exec sed "s/__PORT__/$(PORT)/g" {} --in-place \;

Dockerfile: chart
	cp chart/build/$(TECH)/Dockerfile Dockerfile

.travis.yml: chart
	cp chart/build/$(TECH)/travis.yml .travis.yml

skaffold.yaml: chart
	cp chart/build/$(TECH)/skaffold.yaml skaffold.yaml

clean:
	rm -rf chart
	rm -f Dockerfile
	rm -f .travis.yml
	rm -f skaffold.yaml

