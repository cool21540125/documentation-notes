
# Cloud Development Kit, CDK

- [What is the AWS CDK?](https://docs.aws.amazon.com/cdk/v2/guide/home.html)
    - WARNING: CDK v1 將於 2023/06 起不再維護, 因此建議改用 CDK v2
- CDK 也有支援 :
    - [Terraform](https://developer.hashicorp.com/terraform/cdktf)
    - [K8s](https://cdk8s.io/)


# CDK 底層概念結構

- cdk App 由 1~N 個 Stakcs 構成
- Stack 由 1~N 個 Constructs 構成
- 每個 Construct 又可包含多個 **concrete AWS Resources**
    - ex: S3 Bucket, Dynamodb Table, Lambda Function
- Construct 具有下列 3 種 fundamental flavors:
    - L1, AWS CloudFormation-only
        - 由 AWS CloudFormation 自動產生
        - 命名方式都以 `Cfn` 開頭, ex: CfnBucket 表示 L1 construct 的 S3 bucket
        - L1 resources 都放在 `aws-cdk-lib`
    - L2, Curated
        - 由 AWS CDK team 維護安排
        - L2 封裝了 L1, 提供必要預設
    - L3, Patterns
- AWS CDK 的 `unit of deployment` 為 `stack`
- cdk 操作的 App, Stack, Construct, Resource 概念結構如下:
  - app > stack > construct > resource
  - app 內可含多個 stacks, stack 可含多個 constructs, construct 可含多個 resources

```mermaid
classDiagram

class cdkStack

class Construct

class MyStack {
    MyStack(Construct, String, cdkStackProps)
}

cdkStack <|-- MyStack
Construct *-- MyStack
```
