
# CodeBuild locally

```bash
# Run builds locally with the AWS CodeBuild agent
#   https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html

$# docker pull public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0  # 13GB...
$# docker pull public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:4.0  #  8GB...

$# wget https://raw.githubusercontent.com/aws/aws-codebuild-docker-images/master/local_builds/codebuild_build.sh && mv codebuild_build.sh ~/bin
$# chmod +x ~/bin/codebuild_build.sh
$# codebuild_build.sh \
    -i public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:4.0 \
    -a public
# -i : image_name
# -a : artifact_output_directory
```
