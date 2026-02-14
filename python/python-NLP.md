# Python NLP

## textblob

### textblog 主要功能:

- 名詞片語抽取
- 詞性標註（Part-of-speech tagging）
- 情感分析（sentiment analysis）
- 文字分類（Naive Bayes、Decision Tree）
- 斷詞與斷句（tokenization）
- 字詞頻率統計
- n-grams 生成
- 單複數轉換與詞形還原
- 拼字校正
- 語言翻譯與偵測（透過 Google Translate API）
- WordNet 整合

### textblob 進階:

如果發現語意解釋不清, 可參考: https://textblob.readthedocs.io/en/dev/advanced_usage.html

```py
from textblob import TextBlob
phrase = "You can extract topics from phrases using TextBlob"
topics = TextBlob(phrase).noun_phrases
print(topics)  # 印出句子當中的名詞片語清單
#['extract topics', 'textblob']
```