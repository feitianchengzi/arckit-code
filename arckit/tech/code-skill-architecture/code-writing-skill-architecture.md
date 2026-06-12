# 代码写作 Skill 架构

## 方案概述

代码写作 skill 架构采用一个通用入口、多个任务 reference、多个技术栈 overlay 和少量专项 skill 的结构。

`arckit-code` 是写代码入口。它只处理代码实现、代码修复、代码重构、测试、性能、架构边界、配置代码和可验证交付，不承载非代码治理职责。

## 目录结构

```text
skills/
└── arckit-code/
    ├── SKILL.md
    ├── agents/openai.yaml
    └── references/
        ├── workflow.md
        ├── quality-gates.md
        ├── task-routing.md
        ├── task-view-composition.md
        ├── task-state-dataflow.md
        ├── task-networking-api.md
        ├── task-local-data-lifecycle.md
        ├── task-media-pipeline.md
        ├── task-navigation-routing.md
        ├── task-interaction-motion.md
        ├── task-system-integration.md
        ├── task-performance-quality.md
        ├── task-release-observability.md
        ├── task-ai-generation.md
        ├── stack-swiftui.md
        ├── stack-swiftui-view-composition.md
        ├── stack-swiftui-state-dataflow.md
        ├── stack-swiftui-networking-api.md
        ├── stack-swiftui-local-data-lifecycle.md
        ├── stack-swiftui-media-pipeline.md
        ├── stack-swiftui-navigation-routing.md
        ├── stack-swiftui-interaction-motion.md
        ├── stack-swiftui-performance-quality.md
        └── stack-swiftui-ai-generation.md
```

references 采用一层文件结构，避免深层目录造成阅读路径不稳定。任务文件使用 `task-` 前缀，技术栈文件使用 `stack-` 前缀。

## SKILL.md 职责

`SKILL.md` 只包含触发条件、执行流程、读取资源、路由规则、最低交付标准和降级条件。

`SKILL.md` 不包含各技术栈的完整代码模式。细节放入 reference，按任务和技术栈组合加载。

## Reference 组合规则

一次普通写代码任务读取以下最小组合：

- `workflow.md`
- `quality-gates.md`
- `task-routing.md`
- 一个主任务 reference
- 一个技术栈入口或技术栈 overlay

复合任务先选择一个主任务 reference 和最多一个辅助任务 reference。端到端复杂功能先确定主链路和最高风险边界，再按相邻风险逐步扩展读取。

## 任务 reference 职责

任务 reference 表达跨技术栈的代码问题模型。它描述边界、反模式和验证要求，不写某个技术栈的完整实现细节。

任务 reference 包括：

- `task-view-composition.md`
- `task-state-dataflow.md`
- `task-networking-api.md`
- `task-local-data-lifecycle.md`
- `task-media-pipeline.md`
- `task-navigation-routing.md`
- `task-interaction-motion.md`
- `task-system-integration.md`
- `task-performance-quality.md`
- `task-release-observability.md`
- `task-ai-generation.md`

## 技术栈 overlay 职责

技术栈 overlay 表达任务规则在具体技术栈中的代码落地方式。SwiftUI overlay 不重新解释通用任务规则，只补充 SwiftUI 特性和反模式。

`stack-swiftui.md` 是 SwiftUI 技术栈入口。它只保存共同基线和 overlay 路由，不承载所有 SwiftUI 细节。

SwiftUI 细节按任务拆为多个 overlay：

- `stack-swiftui-view-composition.md`
- `stack-swiftui-state-dataflow.md`
- `stack-swiftui-networking-api.md`
- `stack-swiftui-local-data-lifecycle.md`
- `stack-swiftui-media-pipeline.md`
- `stack-swiftui-navigation-routing.md`
- `stack-swiftui-interaction-motion.md`
- `stack-swiftui-performance-quality.md`
- `stack-swiftui-ai-generation.md`

## SwiftUI skill 处理策略

SwiftUI 写代码能力分为通用代码任务和专项代码任务。通用代码任务由 `arckit-code` 的 task reference 与 SwiftUI overlay 承担；专项代码任务由独立 SwiftUI skill 承担。

### 独立专项 skill

- `arckit-swiftui-foundation`：SwiftUI 工程底座、脚手架脚本、模板、Xcode project 工程结构。
- `arckit-swiftui-share-media`：分享海报、ShareLink、二维码识别、系统级图片查看器、Widget/App Group 分享图片素材和平台图片 bridge。
- `arckit-swiftui-system-integration`：Apple 系统能力、权限、Widget、Keychain、App Group 和必要 UIKit/AppKit bridge。
- `arckit-swiftui-release-observability`：Apple 发布配置、entitlements、Privacy Manifest、Info.plist 权限文案、TestFlight、日志和观测代码。

### 并入 arckit-code 的能力域

以下能力域由 `arckit-code` 的 task reference 和 SwiftUI overlay 承担，不再作为独立 SwiftUI skill：

- 页面组织。
- 状态数据流。
- 普通网络 API。
- 本地数据生命周期。
- 导航路由。
- 交互动画。
- 性能质量。
- AI 生成链路。

`skills/arckit-code/agents/openai.yaml` 保持 `allow_implicit_invocation: true`。

## 强流程保留标准

独立 skill 只在满足以下条件时保留：

- 存在脚本、模板或确定性生成流程。
- 操作顺序脆弱，错误会导致构建、签名、发布或平台能力失败。
- 验证方式明显不同于普通代码任务。
- 用户会自然显式调用该能力。
- 内容放入 reference 会显著拉高普通写代码任务的上下文成本。

## 重组后执行路径

SwiftUI 状态问题读取：

- `skills/arckit-code/SKILL.md`
- `references/task-state-dataflow.md`
- `references/stack-swiftui-state-dataflow.md`

SwiftUI 普通图片上传问题读取：

- `skills/arckit-code/SKILL.md`
- `references/task-media-pipeline.md`
- `references/stack-swiftui-media-pipeline.md`
- 必要时读取 `references/task-networking-api.md`

SwiftUI 新建工程读取：

- `skills/arckit-swiftui-foundation/SKILL.md`
- `skills/arckit-swiftui-foundation/scripts/create-ios-app.sh`
- `skills/arckit-swiftui-foundation/templates/ios-app-template/`

SwiftUI 系统能力代码读取：

- `skills/arckit-swiftui-system-integration/SKILL.md`
- `skills/arckit-swiftui-system-integration/references/apple-integration-boundaries.md`

SwiftUI 分享媒体专项代码读取：

- `skills/arckit-swiftui-share-media/SKILL.md`
- `skills/arckit-swiftui-share-media/references/share-media-rules.md`

SwiftUI 发布配置代码读取：

- `skills/arckit-swiftui-release-observability/SKILL.md`
- `skills/arckit-swiftui-release-observability/references/release-observability.md`

## 设计约束

`arckit-code` 不以客户端、服务端、数据端作为顶层分类。端和框架都作为技术栈 overlay。

`arckit-code` 不把所有 SwiftUI 细节放入单个 `stack-swiftui.md`。该文件只作为 SwiftUI 入口，具体细节分散到 `stack-swiftui-*` overlay。

任务 reference 不包含完整业务代码。它们只描述代码边界、反模式、检查点和验证要求。

技术栈 overlay 不重复通用任务规则。它们只描述技术栈特有 API、生命周期、状态模型和验证方法。

## 验证

重组后的每个 skill 目录通过 `quick_validate.py` 检查 YAML frontmatter 和命名规则。

`arckit-code` 的 reference 文件保持一跳可达，并在 `SKILL.md` 中直接列出关键文件。

独立 SwiftUI 专项 skill 通过 `quick_validate.py` 校验，并保持正向执行说明。
