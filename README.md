# feedparser-aws-lambda-layer

this repo contains the Makefile and buildspec needed to build and publish an AWS Lambda layer.

Many thanks to:

> [https://zoolite.eu/posts/2019-05-19-lambda-layer-ci/](https://zoolite.eu/posts/2019-05-19-lambda-layer-ci/)
> [https://github.com/ZooliteEU/lambda-layer-ci](https://github.com/ZooliteEU/lambda-layer-ci) 

for the informative guide.

To get started, go to AWS CodeBuild and keep it to the default values.
For the environment, select this one

> aws/codebuild/amazonlinux2-x86_64-standard:2.0-19.11.26

For the source, point it towards your repo containing the Makefile and buildspec.yml (make sure to update the variables in the Makefile to point to the libraries you want)

For the role, make sure to add **PublishLayerVersion** to it so you can publish the layer (you can find this under Lambda).


