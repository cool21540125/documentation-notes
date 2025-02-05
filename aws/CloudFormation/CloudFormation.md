- [CloudFormation cheet sheet](https://theburningmonk.com/cloudformation-ref-and-getatt-cheatsheet/)
- [CloudFormation 的所有 Resources & Property types 名稱參照](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
- [CloudFormation Schema](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)
- [AWS resource and property types reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)

# CloudFormation - 基礎

- CloudFormation Drift 機制
  - 如果 Resources 都是透過 CloudFormation, 但偏偏有人直接去改 Resources(不透過 CloudFormation), 則可參考 _Stack actions > Detect drift_
    - drift 這機制可以用來看, actual Resources 與 desired Resources(from CloudFormation) 差了些什麼
    - 很強大的地方是, 可透過這種方式來 _view drift_, 藉此獲得 CloudFormation template
      - 先簡單寫 CloudFormation, create 以後, 手動改, 在用 drift 取得現階段的 template
    - 如果藉由 Console 操作了一開始由 CloudFormation 建立的資源導致 Drift
      - 事後再修改 Template 做更新時, 可能會在 Update 過程發生失敗, 進而導致 Rollback
      - 並且有可能 Rollback 時發生失敗, 狀態會變成: `UPDATE_ROLLBACK_FAILED`
        - ex: Rollback to an old DB instance that was deleted outside CloudFormation
      - Solution:
        - 手動修復 Drift 導致的錯誤
        - 直接將那些 Resources 做 Skip (再來進行 Update Template)
- Resource property types 若為 AWS Resources, 則長的像這樣:
  - `service-provider::service-name::data-type-name`

# CloudFormation - 進階一點的東西

- CloudFormation - StackSets
  - 可以 **Cross Account** 及 **Cross Region** 做一鍵 Create/Update/Delete Stacks
- 如果想對 CloudFormaion 裡頭的 Resources 做個別限制, ex:
  - 禁止在此 CloudFormation stack 裡頭新增 xxx, 修改 EC2, 針對 RDS 做 xxx
  - 可參考 Prevent Update to Stack Resources 或是 **Stack Policy**
  - Stack Policy 可以聲明(json format) 像是 Resource-Based Policy 來對資源操作做限制
- CloudFormation 聲明 ASG(`AWS::AutoScaling::AutoScalingGroup`) 的議題
  - ASG 內部的 EC2 User Data 更新時 -> update Template, 並不會讓 ASG 去替 EC2 做更新
  - 此時需要借助 UpdatePolicy Attribute, 有底下 3 種方式
    - `AutoScalingReplacingUpdate`
      - immutable
      - 會建立新的 ASG, 由此 ASG 建立其相關的 EC2 Instances
      - 完成後, delete old ASG 及其相關的 EC2 Instances
    - `AutoScalingRollingUpdate`
      - 在原有 ASG 裡頭, 藉由 min 及 max, 滾動更新其相關的 EC2 Instances
    - `AutoScalingScheduleAction`
- CloudFormation 跨帳號存取, 參考 [StackSet](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html)

# CloudFormation - 重要留意

- 如果要變更 Infra, 一定最好是藉由 **CloudFormation Change Set** 來查看變更, ex:
  - 如果對 DB 更名, CloudFormation 會砍舊建新, 因此 **update stack** 必須小心
- 避免 CloudFormation 被意外刪除, 可使用 **termination protection**
  - 做此配置以後, 如果使用 CloudFormation 刪除資源時, 會移除失敗, 不過 Status 依舊是 Unchanged (而非 Failed/Success)

# CloudFormation - 細節

- 刪除 CloudFormation 時, 其相關 Resources 的 DeletionPolicy
  - `DeletionPolicy=Retain`
  - `DeletionPolicy=Snapshot`
    - 底下 2 種情況的預設行為:
      - `AWS::RDS::DBCluster`
      - 未在裡頭聲明 DBClusterIdentifier 的 `AWS::RDS::DBInstance`
  - `DeletionPolicy=Delete`
    - 除了上述兩者以外, 預設都是 Delete
    - ex: 由 CloudFormation 刪除 S3 Bucket 前, 須先將 S3 Bucket 內容清空
