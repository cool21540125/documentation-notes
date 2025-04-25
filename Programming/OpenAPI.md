# OpenApi

- OpenAPI 的 General API Info
  - 3.x
  - OpenApi 的替代方案: RAML, API Blueprint
    - OpenApi 3.0 的 go lib
      - github.com/getkin/kin-openapi 的 openapi3/
      - github.com/deepmap/oapi-codegen

```bash
### OpenAPI 3.x
go get github.com/getkin/kin-openapi/openapi3
go get github.com/deepmap/oapi-codegen
```

# Api documentation

- https://mariocarrion.com/2021/05/02/golang-microservices-rest-api-openapi3-swagger-ui.html
- Swagger Validator
  - https://validator.swagger.io/
- Swagger Codegen 3.X
  - https://swagger.io/docs/open-source-tools/swagger-codegen/codegen-v3/versioning/
- OAS3 特殊用法:
  - oneOf
  - anyOf
  - allOf

```yaml
info: xxx
hosts: xxx
security: xxx
paths: xxx
externalDocs: xxx
tags: xxx
components: xxx
```
