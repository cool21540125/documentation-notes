#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------

### 查看已購買的 Savings Plans
aws savingsplans describe-savings-plans | yq
#savingsPlans:
#  - commitment: '2.74000000'
#    currency: USD
#    description: 3 year No Upfront Compute Savings Plan
#    end: '2027-06-11T00:00:00.000Z'
#    offeringId: e0123456-123a-456b-789d-1a2b3c4d5e8h
#    paymentOption: No Upfront
#    productTypes:
#      - Fargate
#      - EC2
#      - Lambda
#    recurringPaymentAmount: '2.74000000'
#    returnableUntil: '2024-06-18T00:00:00.000Z'
#    savingsPlanArn: arn:aws:savingsplans::123456789012:savingsplan/fa123456-1234-5678-2345-123abcdefg03
#    savingsPlanId: f5e47879-3704-45a9-b6d1-7200908cac10
#    savingsPlanType: Compute
#    start: '2024-06-11T00:00:00.000Z'
#    state: active
#    tags: {}
#    termDurationInSeconds: 94608000
#    upfrontPaymentAmount: '0.00000000'
#  - commitment: '2.50000000'
#    currency: USD
#    description: 1 year No Upfront Compute Savings Plan
#    end: '2024-06-10T00:00:00.000Z'
#    offeringId: e0123456-123a-456b-789d-1a2b3c4d5e6f
#    paymentOption: No Upfront
#    productTypes:
#      - Fargate
#      - EC2
#      - Lambda
#    recurringPaymentAmount: '2.50000000'
#    returnableUntil: '2023-06-18T00:00:00.000Z'
#    savingsPlanArn: arn:aws:savingsplans::123456789012:savingsplan/fa123456-1234-5678-2345-123abcdefg01
#    savingsPlanId: 6fdb87e0-fbe0-42cf-8759-92eab4d7d4a1
#    savingsPlanType: Compute
#    start: '2023-06-11T00:00:00.000Z'
#    state: retired
#    tags: {}
#    termDurationInSeconds: 31536000
#    upfrontPaymentAmount: '0.00000000'
#  - commitment: '1.70000000'
#    currency: USD
#    description: 1 year All Upfront Compute Savings Plan
#    end: '2023-05-17T00:00:00.000Z'
#    offeringId: e0123456-123a-456b-789d-1a2b3c4d5e7g
#    paymentOption: All Upfront
#    productTypes:
#      - Fargate
#      - EC2
#      - Lambda
#    recurringPaymentAmount: '0.00000000'
#    returnableUntil: '2022-05-17T04:44:24.329Z'
#    savingsPlanArn: arn:aws:savingsplans::123456789012:savingsplan/fa123456-1234-5678-2345-123abcdefg02
#    savingsPlanId: c45d50bf-12e0-47a7-893f-e0a72bddecd9
#    savingsPlanType: Compute
#    start: '2022-05-17T04:44:24.329Z'
#    state: retired
#    tags: {}
#    termDurationInSeconds: 31536000
#    upfrontPaymentAmount: '14892.00000000'
