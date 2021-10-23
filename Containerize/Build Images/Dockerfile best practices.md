# [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

- Since 2021/03/09

Docker Image 藉由 Dockerfile 每行的 directive 聲明來層層堆疊而成. 每一層都是上一層的 delta

## General guidelines and recommendations

### Create ephemeral containers

### Understand build context

- 執行 `docker build ...` 的時候, 目前所在位置即為 `build context`, 依照慣例我們會把 Dockerfile 放這

### Pipe Dockerfile through stdin

#### BUILD AN IMAGE USING A DOCKERFILE FROM STDIN, WITHOUT SENDING BUILD CONTEXT

#### BUILD FROM A LOCAL BUILD CONTEXT, USING A DOCKERFILE FROM STDIN

#### BUILD FROM A REMOTE BUILD CONTEXT, USING A DOCKERFILE FROM STDIN

### Exclude with .dockerignore

### Use multi-stage builds

### Don't install unnecessary packages

### Decouple applications

### Minimize the number of layers

Dockerfile building time, 僅有 `RUN`, `COPY`, `ADD` 會 *create layer* (早期版本則是都會)

其他的 instruction 只會增加 *intermediate images*, 並不會使 Image 肥大

### Sort multi-line arguments

### Leverage build cache

TODO: 這個好像有點學問, 找時間來K


## Dockerfile instructions

### FROM

### LABEL

### RUN

#### APT-GET

#### USING PIPES

### CMD

### EXPOSE

### ENV

### ADD or COPY

### ENTRYPOINT

### VOLUME

#### USER

### WORKDIR

### ONBUILD

- `ONBUILD` command 會在 Dockerfile build complete 的時候執行

看不懂官方在寫三小, 找時間讀: [Dockerfile ONBUILD instruction](https://stackoverflow.com/questions/34863114/dockerfile-onbuild-instruction)



## Examples for Official Images

## Additional resources
