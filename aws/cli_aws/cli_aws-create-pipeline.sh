#!/bin/bash
exit 0
# --------------------------------------------------------------------------------

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/create-pipeline.html

PIPELINE_NAME=
aws codepipeline create-pipeline --cli-input-json file://MyDemoPipeline.json
