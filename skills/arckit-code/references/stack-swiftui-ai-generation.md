# SwiftUI AI Generation Overlay

- Prompt builder、schema、validator 和 generation service 不写在 View 中。
- View 只协调输入、生成状态、取消、重试和结果展示。
- stream 状态应能区分 connecting、streaming、validating、success、failed、cancelled。
- 生成任务使用 Swift Concurrency 取消语义，页面消失或用户取消后不写过期状态。
- 生成结果保存到本地数据时，先通过领域校验再落库。
- 涉及权益/扣费时，UI 展示生成前后状态和失败解释。
