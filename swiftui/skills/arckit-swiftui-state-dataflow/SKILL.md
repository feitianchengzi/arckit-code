---
name: arckit-swiftui-state-dataflow
description: SwiftUI 状态、数据流和分层边界 skill。用于处理 @State、@Binding、@Observable、@Query、@Environment、SwiftData、Service 注入、View/Model/Service 职责、业务状态与 UI 状态拆分、服务层去 UIKit/AppKit 类型依赖、ViewModel/状态模型边界。用户提到状态混乱、数据流、SwiftData、Observable、ViewModel、Service、架构边界、业务逻辑放哪、服务层不该依赖 UI 类型时使用。
---

# ArcKit SwiftUI State Dataflow

## 目标

为真实 SwiftUI 功能确定状态归属、数据流和 View/Model/Service 边界，避免 ViewModel 膨胀、Service 污染 UI 类型、状态多源复制和副作用散落。

## 执行流程

1. 列出功能中的状态：持久化数据、非持久化业务状态、局部 UI 状态、系统环境值。
2. 画出数据流：用户操作 -> View -> Service/Model -> 状态更新 -> View 渲染。
3. 选择状态工具：简单 UI 用 `@State`，父子编辑用 `@Binding`，持久化查询用 `@Query`，关联业务状态用 `@Observable`。
4. 定义 Model、Service、View 职责。Model 表达领域数据，Service 表达外部能力，View 做协调。
5. 检查 Service 接口是否泄漏 `UIImage`、`UIViewController`、`Color`、`View` 等 UI 类型；必要时改为 `Data`、`URL`、DTO、领域模型。`UIViewRepresentable`/`NSViewRepresentable` 可持有平台类型，但其公开输入输出应保持 SwiftUI/领域中立。
6. 检查派生 display model 或本地缓存是否会在异步补全后刷新，尤其是资源身份不变但数据完整度变化的场景。
7. 为远端回源、缓存命中、fallback、增量补全等路径定义 freshness/completeness，避免“同一 id 的低完整度数据”长期占住 UI。
8. 检查 Model 字段是否表达唯一事实来源；如果一个字段会被多个 Service 路径更新，不要用它判断某个具体接口 payload 的状态。
9. 对关键 Model、Service、状态转换保留可测试边界。

## 读取资源

- 详细规则和检查表：`references/state-dataflow-rules.md`
- 状态和 Service 代码模式：`references/code-patterns.md`

## 核心规则

| 层 | 可以 | 禁止 |
| --- | --- | --- |
| Model | 领域数据、领域约束、基于自身的计算属性 | 依赖 View、Service、UI 状态 |
| Service | 网络、存储、系统能力、算法通道 | 产品决策、导航、弹窗、UI 状态 |
| View | 持有状态、调用 Service、组合 UI、协调业务 | 底层网络、Keychain、重型解析、系统桥接细节 |
| Representable | 局部封装 UIKit/AppKit 控件和 delegate/coordinator | 领域决策、网络、持久化、跨页面共享状态 |
| Utils | 项目独立工具 | 依赖业务对象和 View |

## 异步补全和派生状态

- 派生 display model 必须能响应源数据完整度变化，不只比较资源 id。
- 缓存数据、fallback 数据和远端完整数据要能表达新旧程度或完整度差异。
- 同一资源的摘要、详情、用户态等数据面要能独立表达新鲜度；不要让通用 `updatedAt`、`lastSyncedAt` 或列表刷新时间充当详情补全时间。
- 如果 UI 先显示低完整度数据，远端补全成功后必须有明确的状态更新、合并或失效路径。
- 不要把临时占位、失败回退或缓存快照复制成另一个长期事实来源。

## 状态决策

```text
需要管理什么？
├─ 持久化领域数据 → @Model / SwiftData + @Query
├─ 非持久化业务状态 → @Observable
├─ 简单 UI 状态 → @State
├─ 父子双向编辑 → @Binding
└─ 外部能力 → Service + @Environment
```

## 最低交付标准

- 每个关键状态有唯一事实来源。
- View、Model、Service 职责明确。
- Service 接口不泄漏 SwiftUI/UIKit/AppKit 类型。
- 异步副作用不在 body 中触发。
- 关键状态转换可测试。
- 异步加载、补全、合并数据后，依赖同一资源身份的派生 UI 状态不会继续显示旧的低完整度数据。

## 降级/停止条件

- 只改纯展示样式或文案时，不做完整状态重构。
- 单个局部 `@State` 足以表达的小交互，不引入 `@Observable`。
- 既有项目已有清晰数据流时，沿用项目模式，只修正明显边界问题。
