.PHONY: clean build
.DEFAULT_GOAL:=help

# Variables
LAYER_NAME=feedparser-py-layer
CFN_STACK_NAME=feedparser-lambda-layer-codebuild
CFN_TEMPLATE=cfn-template.yaml
YOUR_LIB_NAME=feedparser
YOUR_LIB_VERSION:=1.20.26


deploy-ci: ## Deploy Codepipeline with Cloudformation
	@aws cloudformation deploy --stack-name $(CFN_STACK_NAME) --template-file $(CFN_TEMPLATE) --capabilities CAPABILITY_NAMED_IAM --region $(AWS_DEFAULT_REGION)
	@echo "Codecommit url:"
	@aws cloudformation describe-stacks --stack-name $(CFN_STACK_NAME) --region $(AWS_DEFAULT_REGION) --query 'Stacks[0].Outputs[0].OutputValue'

clean: ## PIPELINE COMMAND: cleanup
	rm -f $(LAYER_NAME).zip
	rm -rf build

build: ## PIPELINE COMMAND: build Lambda layer
	mkdir -p build/python
	pip install $(YOUR_LIB_NAME)==$(YOUR_LIB_VERSION) -t ./build/python
	cd ./build && zip -r ../$(LAYER_NAME).zip .

publish: ## PIPELINE COMMEND: publish Lambda layer
	@aws lambda publish-layer-version --layer-name "$(LAYER_NAME)" --description "$(YOUR_LIB_NAME) $(YOUR_LIB_VERSION)" --zip-file fileb://$(LAYER_NAME).zip --compatible-runtimes python3.8 

help:
	 $(call blue, "Help:\n=====")
	 @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m- %-20s\033[0m%s\n", $$1, $$2}'

define blue
	@tput setaf 6
	@echo $1
	@tput sgr0
endef
