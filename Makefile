SERVICE_NAME=hello-world-printer
MY_DOCKER_NAME=$(SERVICE_NAME)

.PHONY: test
.DEFLAUT_GOAL := test

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

lint:
	flake8 hello_world test

test:
	PYTHONPATH=. py.test
	PYTHONPATH=. py.test  --verbose -s --cov=.  --junit-xml=test_result.xml
	PYTHONPATH=. py.test  -s --cov=.  --junit-xml=test_result.xml
	test_cov #generacja coverage
	test_xunit #generacja xunit i coverage


run:
	python main.py

docker_build:
	docker build -t $(MY_DOCKER_NAME) .

docker_run: docker_build
	docker run \
	--name $(SERVICE_NAME)-dev \
	-p 5000:5000 \
	-d $(MY_DOCKER_NAME)

docker_stop:
	docker stop $(SERVICE_NAME)-dev

USERNAME=elciak82
TAG=$(USERNAME)/$(MY_DOCKER_NAME)

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag $(MY_DOCKER_NAME) $(TAG); \
	docker push $(TAG); \
	docker logout;
