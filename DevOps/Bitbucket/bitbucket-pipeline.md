# bitbucket-pipeline.yml 結構

- 2023/05/16

```yaml
### https://support.atlassian.com/bitbucket-cloud/docs/docker-image-options/
# default
image: atlassian/default-image:latest
# or
image: 
  name: my-docker-hub-account/my-docker-image:latest
  username: $DOCKER_HUB_USERNAME
  password: $DOCKER_HUB_PASSWORD
  email: $DOCKER_HUB_EMAIL
  run-as-user: 1001
# or AWS
image:
  name: $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$IMAGE:latest
  aws: 
    access-key: $AWS_ACCESS_KEY
    secret-key: $AWS_SECRET_KEY


### https://support.atlassian.com/bitbucket-cloud/docs/global-options/
options:
  max-time: 120
  docker: false
  size: 1x


### https://support.atlassian.com/bitbucket-cloud/docs/git-clone-behavior/
clone:
  enabled: true
  depth: 50
  lfs: false


### 
definitions:
  caches:
    Key: 
      files:
        - FILE_A_PATH
        - FILE_B_PATH
      path: vendor/bundle
  services:
    SERVICE:
      image: xxx
        KEY: VALUE
    my-mariadb:
      image: mariadb:latest
      variables:
        MARIADB_USER: $MY_MARIADB_USER
        MARIADB_PASSWORD: $MY_MARIADB_PASSWORD
        MARIADB_ROOT_PASSWORD: $MARIADB_ADMIN_PASSWORD


# 
pipelines:
  default:  # default / branches / pull-requests / tags
    - step:
        name: Hello world example
        script:
          - echo "Hello, World!"
  branches:
    main:
      - step:
          image: alpine
          script:
            - echo "This script runs only on commit to the main branch."
    hotfix/*:
      - step:
          name: Build hotfix branch
          script:
            - echo "Hello, hotfix!"
  tags:
    '*-macos':
      - step:
          name: xxx
          script:
            - echo 'yo'
    '*-linux':
      - step:
          name: Build for *-linux tags
          script:
            - echo "Hello, Linux!"
    - step:
        name: Hello world example
        services:
          - my-mariadb
        caches:
          - bundler-packages
        script:
          - ruby -e 'print "Hello, World\n"'

# 
pipeline:
  Pipeline start options page
    parallel:
      Parallel step options page
    stage:
      Stage options page
    step:
      Step options page
```
