# Tagging AWS Resources

- Best Practice
  - 做 tag 的時候, 留意 **managing resource access control** / **cost tracking** / **automation** / **organization**
  - Use too many tags rather than too few tags.
  - 隨著業務需求更動 tags, 不要弄了之後都不改了! 然而, 需要留意更動 tags 之後, 對於 control access 的影響
  - 如果有用 AWS Organization 的話, 盡可能搭配 Tag Policies 來對 tags 做進一步控管
- AWS tags 命名建議: tag naming 都使用「小寫」及「-」, 以及使用「:」作為 Prefix
- AWS tags 使用限制
  - AWS Resource 最多只能有 50 tags
