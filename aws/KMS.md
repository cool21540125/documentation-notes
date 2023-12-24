
# [KMS, AWS Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)

- KMS 使用 硬體安全模組(HSM), 依照 FIPS 140-2 Cryptographic Module Validation Program 來保護及驗證 `AWS KMS keys`
- CloudTrail 與 KMS 的整合
    - 可使用 CloudTrail 來查看 KMS 的使用
    - 用以滿足 auditing, regulatory, and compliance needs
- KMS 常被拿來與 **CloudHSM** 做比較
- API call > 4KB data 須借助 **envelop encryption**
- 使用 KMS 的注意事項
    - 要收費, `$0.03/10000` call KMS API
    - KMS Key - 無法 cross region 傳送
    - [Deleting AWS KMS keys](https://docs.aws.amazon.com/kms/latest/developerguide/deleting-keys.html)
        - 因為 KMS Key 太過敏感且重要, 為了防止誤砍, 給予了 waiting period 的機制
        - 點選刪除後, Key 會進入 **Pending deletion** (可自行設定 7~30 days, default 30 days)
        - 可在此期間內還原, 但如果超過此期間就 GG 了
            - AWS 會連帶刪除與此相關的 Resources
        - KMS Key 的權限, 主要使用 Key Policy 來管控訪問, 每把都需要有它自己的 key policy (其次也可使用 IAM)
- 2 types of KMS Keys:
    - Symmetric Keys
        - AES-256
        - CMK, Customer Master Key, 又分成 3 種:
            - AWS Managed Service Default CMK (AWS owned CMK)
                - Free
            - User Keys created in KMS (AWS managed CMK)
                - 一把 Key : 1/month
            - User Keys imported (Customer managed CMK)
                - 一把 Key : 1/month
                - 必須為 256 bit symmetric key
        - envelop encryption
        - user call API to use Key
    - Asymmetric Keys
        - RSA & ECC key pairs
        - user CAN NOT call API to see private key
- 常用的 API
    - [Encrypt]
    - [Decrypt]
    - [GenerateDataKey]
    - [GenerateDataKeyWithoutPlaintext]
    - GenerateDataKeyPair
    - GenerateDataKeyPairWithoutPlaintext


# [GenerateDataKey](https://docs.aws.amazon.com/kms/latest/APIReference/API_GenerateDataKey.html)

```jsonc
// Request
{
	"EncryptionContext": {"string": "string"},
	"GrantTokens": ["string"],
	"KeyId": "string",
	"NumberOfBytes": "number"
}

// Response
{
	"CiphertextBlob": "blob",
	"KeyId": "string",
	"Plaintext": "blob"
}
```

已獲授權的 Users, 可使用下列這些 GenerateDataKey API 來請求特定類型的 data key 或 a random key of arbitrary length

- 回傳 unique symmetric data key, 給 AWS KMS 以外的服務使用
- `plaintext key`, plaintext copy of the data key
    - 此 Key 與 KMS key 無關, 這東西用來 encrypt data
- a copy that is encrypted under a symmetric encryption KMS key that you specify


# [GenerateDataKeyWithoutPlaintext]
