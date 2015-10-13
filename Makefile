SHELL=/bin/bash
# the directory we're running from, it's name, not it's full path
# this will serve as part of the config file we will load
MY_DIR:=$(shell basename ${PWD})
ENV_NAME:=$(MY_DIR)
# name of the config file used to provide env data specific to 
# this makefile
MY_INCLUDE=~/.${MY_DIR}.env
INCLUDE_EXISTS:=$(shell [ -f $(MY_INCLUDE) ] && echo YES)
# include the file specific to this makefile, it's cool if it's not
# there, some stuff simply may not work
-include ${MY_INCLUDE}
# We expect the file to provide values for the following variables
# STATIC_DEPLOY_AWS_ACCESS_KEY_ID
# STATIC_DEPLOY_AWS_SECRET_ACCESS_KEY
# STATIC_DEPLOY_S3_BUCKET_NAME
# STATIC_DEPLOY_S3_REGION_NAME

export AWS_ACCESS_KEY_ID=${STATIC_DEPLOY_AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${STATIC_DEPLOY_AWS_SECRET_ACCESS_KEY}

.PHONY: clean deploy serve report invalidations show

serve: report
	python -m SimpleHTTPServer ${PORT}

clean: report
	@echo "cleaning currently does nothing"
	
deploy: report
	aws s3 --region ${STATIC_DEPLOY_S3_REGION_NAME} cp --exclude '.git/*' --exclude 'Makefile' --exclude '.gitignore' --exclude '*.swp' --recursive . s3://${STATIC_DEPLOY_S3_BUCKET_NAME}
	aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} --invalidation-batch '{"CallerReference":"$(shell date +"%s")","Paths":{"Quantity":1,"Items":["${INVALIDATION_ROOT}"]}}'
	
invalidations:
	aws cloudfront list-invalidations --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID}

show:
	aws --region ${STATIC_DEPLOY_S3_REGION_NAME} s3 ls s3://${STATIC_DEPLOY_S3_BUCKET_NAME}/

report:
	@echo "environment $(ENV_NAME)"
ifdef INCLUDE_EXISTS
	@echo "using configuration from ${MY_INCLUDE}"
endif
