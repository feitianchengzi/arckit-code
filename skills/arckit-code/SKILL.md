---
name: arckit-code
description: ArcKit 写代码执行 skill。用于真实代码实现、重构、bug 修复、性能治理、架构边界调整、从需求或技术方案落代码、跨技术栈代码模式复用。用户要求写代码、改代码、修代码、优化代码、补测试、接入 API、实现 UI、调整状态数据流、处理本地数据、媒体、路由、系统能力、发布相关代码或 AI 生成链路代码时使用。
---

# ArcKit Code

## 目标

把写代码任务统一收敛为“读项目事实 -> 判断代码问题类型 -> 判断技术栈 -> 读取最小 reference -> 修改代码 -> 验证”的执行链路。不要把本 skill 当成大而全教程；它只服务于代码实现和代码质量，具体规则按需读取 reference。

## 执行流程

1. 先读代码事实：需求/技术方案、现有代码、测试、构建脚本和同类实现。
2. 判断代码问题类型：页面组织、状态数据流、网络 API、本地数据、媒体管线、导航路由、交互动画、系统集成、性能质量、发布相关代码、AI 生成链路。
3. 判断技术栈：SwiftUI、React、Flutter、Node API、Django、Postgres 等；未知时从项目文件和依赖中确认。
4. 读取最小组合：通常读取 1 个任务 reference + 1 个技术栈 overlay；不要一次加载所有规则。
5. 选择是否调用代码专项 skill：脚手架、平台能力接入、发布配置代码、强流程代码生成使用独立 skill。
6. 按项目既有代码模式做最小必要修改，不为了套规则重排无关代码。
7. 执行验证：小改动做定向验证，大改动补测试、构建或回归清单。
8. 输出改动、验证结果和剩余风险。

## 读取资源

- 通用工作流和验证：`references/workflow.md`、`references/quality-gates.md`
- 任务选择矩阵：`references/task-routing.md`
- SwiftUI 总体规则：`references/stack-swiftui.md`
- SwiftUI 任务 overlay：`references/stack-swiftui-state-dataflow.md`、`references/stack-swiftui-view-composition.md`、`references/stack-swiftui-networking-api.md`、`references/stack-swiftui-local-data-lifecycle.md`、`references/stack-swiftui-navigation-routing.md`、`references/stack-swiftui-interaction-motion.md`、`references/stack-swiftui-media-pipeline.md`、`references/stack-swiftui-performance-quality.md`、`references/stack-swiftui-ai-generation.md`

## 路由规则

```text
编码任务
├─ 普通实现/重构/修复 -> arckit-code + task reference + stack overlay
├─ 新建 SwiftUI 工程 -> arckit-swiftui-foundation
├─ 普通媒体加载/缓存/上传 -> arckit-code + task-media-pipeline + stack overlay
├─ SwiftUI 分享海报/二维码/系统级图片查看 -> arckit-swiftui-share-media
├─ Apple 系统能力/权限/bridge 代码 -> arckit-swiftui-system-integration
├─ Apple 发布相关配置代码 -> arckit-swiftui-release-observability
└─ 确定性脚手架/代码生成脚本 -> 对应专项 skill
```

## 最低交付标准

- 已说明主任务类型和技术栈。
- 已读取对应 reference，且未加载无关技术栈细节。
- 修改符合项目现有目录、命名、测试和依赖模式。
- 高风险边界有明确验证：构建、测试、手测、截图、日志、迁移样本或回归清单。
- 没有把平台特定实现误写进通用任务规则。
- 强流程代码任务路由到独立正向 skill，不写成过程说明。

## 降级/停止条件

- 用户明确指定某个写代码专项 skill 时，优先使用专项 skill。
- 任务只是在现有文件内做小文案或小样式修正时，不做体系化重构。
- 技术栈没有对应 overlay 时，按项目事实完成，并把可复用差异沉淀为新的 stack reference。
- 需要外部账号、证书、商店后台或线上系统时，本地只完成代码和配置侧改动，不编造外部状态。
