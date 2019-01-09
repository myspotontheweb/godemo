
NAME=go-demo

.PHONY: clean

init: Dockerfile chart

chart:
	helm create --starter=teamwork $(NAME)
	mv $(NAME) chart

Dockerfile: chart
	find chart -type f -exec sed "s/__NAME__/$(NAME)/g" {} --in-place \;
	cp chart/build/go/Dockerfile Dockerfile

clean:
	rm Dockerfile
	rm -rf chart
