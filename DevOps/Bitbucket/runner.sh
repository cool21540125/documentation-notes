

docker container run -it \
    -v /tmp:/tmp \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
    -e ACCOUNT_UUID={f0d49bda-7783-467f-aea9-83f03cc3ae4e} \
    -e REPOSITORY_UUID={e95d71ed-d45c-4457-b772-e3635927fdf8} \
    -e RUNNER_UUID={01e9e590-91be-558e-ba39-18842b9af7bb} \
    -e RUNTIME_PREREQUISITES_ENABLED=true \
    -e OAUTH_CLIENT_ID=totFXufMyJ72t7C1MR0FpBbvmTtqClYw \
    -e OAUTH_CLIENT_SECRET=ATOAwp75P2kEFxVUS2meftiABIveGgO6v8425vejx1TC0EcSMUqJyzWkQnOB6ITq2mYCA8C9B9FF \
    -e WORKING_DIRECTORY=/tmp \
    --name runner-01e9e590-91be-558e-ba39-18842b9af7bb \
    docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner:1
