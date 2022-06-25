
- User 定義 Template, 並藉由 Tempalte 建立 Stack
    - AWS 則在背後 提供 Resources
    - template ext: `.json`, `.yaml`, `.template`, `.txt`
- 如果要變更 Infra, 一定最好是藉由 **CloudFormation Change Set** 來查看變更, ex:
    - 如果對 DB 更名, CloudFormation 會砍舊建新, 因此 **update stack** 必須小心
- [CloudFormation 的所有 Resources & Property types 名稱參照](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
- [CloudFormation 格式大綱](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html), 如下:
    - ```yaml
      ---
      AWSTemplateFormatVersion: "version date"
      
      Description:
      String
      
      Metadata:
      template metadata
      
      Parameters:  (可在 Resources & Outputs 區塊參照使用, 並在 Runtime 提供, 例如 敏感資訊)
      set of parameters
      
      Rules:
      set of rules
      
      Mappings:  (用來定義條件宣告) 可在 Resources & Outputs 使用 `Fn::FindInMap` 來做配對
      set of mappings
      
      Conditions:
      set of conditions
      
      Transform:
      set of transforms
      
      Resources:  (只有這個是 Needed, 其他都是 Optional)
      set of resources
      
      Outputs:
      set of outputs
      ```