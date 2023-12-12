
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html
- CloudFormation 內建的 Functions
    - Fn::Ref
        - 對於 Parameters, 回傳 parameter value
        - 對於 Resources, 回傳 resource 的 physical ID
    - Fn::GetAtt
        - 對於 Resources, 可取得它對應的各種 peoperty/attribute
        - 各種 AWS Resources 的 
    - Fn::FindInMap
        - 此為底層用法(必須逐一事先宣告)
        - 適用情境為, 能夠掌握所有參數的話, 再來制定 Map
    - Fn::ImportValue
        - 可以從其他 template 的 exported values 做 import
    - Fn::Join
        - 串接字串
        - `!Join [ delimiter, [ comma-delimited list of values ]]`
    - Fn::Sub
        - `Fn::Sub` 或 `!Sub`
        - 要被替代的字串 必須包含 `${VariableName}`
    - Condition Functions
        - Condition 可以基於
            - Environment
            - AWS Region
            - Any parameter value
            - another condition
            - mapping
            - ...
        - Fn::And
        - Fn::Equals
        - Fn::If
        - Fn::Not
        - Fn::Or


# Examples

```yaml
### Fn::Ref - 取得參照 Resource 的 Physical Id
Resources:
    DbSubnet1:
        Type: AWS::EC2::Subnet
        Properties:
            VpcId: !Ref MyVPC
            ...

    MyVPC:
        ...
```

```yaml
### Fn::GetAtt - 取得參照 Resource 的 attribute (每種 Resource 的 peoperty/attribute 不同)
Resources:
    EC2Instance:
        Type: AWS::EC2::Instance
        Properties:
            ImageId: ami1234567
            InstanceType: t2.micro
    NewVolume:
        Type: AWS::EC2::Volume
        Properties:
            Size: 100
            AvailabilityZone:
                !GetAtt EC2Instance.AvailabilityZone
```

```yaml
### Fn::FindInMap - 將所有能夠掌握的參數設定到 mapping
Mappings:
    RegionMap:
        us-east-1:
            "32": "ami-123456"
            "64": "ami-777777"
        us-east-2:
            "32": "ami-878787"
            "64": "ami-333333"
Resources:
    myEc2Instance:
        Type: "AWS::EC2::Instance"
        Properties:
            ImageId: !FindInMap [RegionMap, !Ref "AWS::Region", 32]
            InstanceType: m1.small
```

```yaml
### Fn::ImportValue - 從其他 Template 的 exported value 做 import
Resources:
    EC2Instance:
        Type: AWS::EC2::Instance
        Properties:
            AvailabilityZone: ap-northeast-1
            ImageId: ami1234567
            InstanceType: t2.micro
            SecurityGroups:
                - !ImportValue SshSecurityGroup
```

```yaml
### Fn::Join - 串接字串, 會拿到 "a:b:c"
    ...
    !Join [ ":", [a, b, c]]
```

```yaml
### 
    ...
    !Sub
        - String
        - { k1: v1, k2: v2 }
    # 等同於
    !Sub String

```

```yaml
### Condition Functions - 依照環境來建立必要資源
Conditions:
    CreateProdResources: !Equals [ !Ref EnvType, prod ]

Resources:
    MountPoint:
        Type: "AWS::EC2::VolumeAttachment"
        Condition: CreateProdResources
```
