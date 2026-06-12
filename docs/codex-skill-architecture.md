# Codex Agent Skill 体系拆解

> 当前有效方案以 `arckit/spec/code-skill-system/code-writing-skill-system.md` 和 `arckit/tech/code-skill-architecture/code-writing-skill-architecture.md` 为准。本文保留为 SwiftUI 12 atom skill 阶段的历史思考材料。

## 背景

这份文档记录围绕 Apple SwiftUI 客户端开发的 skill 体系思考。

讨论起点来自 AnimeCalendar 的一批本地改动：Universal Link 分享、页面卡顿、动画卡顿、手势翻页、图片缩放、图片失败/重试、头像上传、非必要不使用 UIKit 等。这些问题不是单点 bug，而是复杂客户端项目中反复出现的工程问题。

随后又结合 `../yueya-melody` 作为第二个 case。该项目补充了 AI 生成、音乐领域建模、实时音频、积分权益、作品生命周期、Keychain 凭据等复杂 2C App 场景。

目标不是总结某个项目改了什么，而是思考：这些可复用经验应该沉淀成哪些 Codex Agent skill，才能在后续 Apple SwiftUI 2C App 开发中稳定发挥作用。

## 基本前提

当前阶段只面向：

- Apple 客户端开发。
- Swift / SwiftUI 技术栈。
- 2C App。
- 产品功能、交互、视觉、技术方向大体明确，但输入粒度可能较粗。

暂不追求跨 Web、Android、后端的通用抽象。后续如果做其他端，可以参考 Apple SwiftUI 的拆法，再建立对应端的 skill 体系。

## 对 Skill 的理解

Skill 不应被理解成单纯的 prompt 或 Markdown 文档。

更准确地说：

```text
Skill = 触发条件 + 工作流 + 规则约束 + 模板 + 脚本 + 检查清单 + 参考知识
```

因此 prompt、template、checklist、script、reference 并不是 skill 的替代物，而是 skill 内部可以组织的材料。

但项目事实不适合放进通用 skill。比如域名、Bundle ID、Team ID、业务接口、字段兼容规则、具体产品路由，应留在项目 spec、tech note 或 project memory 中。

进一步迭代后，对 skill 的要求收敛为：

```text
Skill 是指导 Agent 写真实代码的执行能力包，不是知识百科。
```

一个高质量执行能力包至少要包含：

- 触发条件：通过 `SKILL.md` frontmatter description 让 Agent 能在用户自然表达需求时触发。
- 执行流程：Agent 触发后先做什么、读什么、改什么、如何验证。
- 原则约束：架构边界、平台边界、不可做的反模式。
- 代码机制：原则必须落到可复用代码骨架、接口形态、状态机或数据流。
- 资源组织：复杂细节放入 `references/`，确定性操作放入 `scripts/`，模板放入 `templates/` 或 `assets/`。
- 校验标准：最低交付标准、测试/手测/Instruments/发布配置检查。

因此后续写 skill 时不能停在“应该怎样”的口号层面，而要形成：

```text
原则 -> 机制 -> 代码要求 -> 反模式 -> 验证要求
```

例如：

- 原则：Service 不做业务逻辑。
- 机制：Protocol -> Impl -> EnvironmentKey -> EnvironmentValues -> View 注入。
- 代码要求：Service 接口使用 `Data` / `URL` / DTO / 领域模型，不泄漏 `UIImage`、`UIViewController`、SwiftUI `View`。
- 反模式：`@Observable` 状态模型直接依赖 Service 或 `@Environment`。
- 验证要求：Service 可 mock，关键状态转换可测试。

## 核心观点

### 1. Skill 要抓大放小

Skill 不应该替代 Agent 和大模型的推理能力，也不应该把所有工程常识都制度化。

它应该覆盖的是：

- 高风险问题。
- 高频复发问题。
- 上下文跨度大的问题。
- 平台细节容易踩坑的问题。
- 结果出错代价高的问题。

它不应该覆盖：

- 单个控件怎么写。
- 某个具体页面怎么布局。
- 一次性业务流程。
- 普通 CRUD。
- 很容易通过读当前代码自然推出来的局部实现。

这条原则也约束内容密度：不要把 skill 写成事无巨细的教程，但原则性要求必须足够硬。凡是容易导致架构偏移、性能回归、平台能力误用、线上不可观测的问题，都应该给出明确机制和代码边界。

### 2. 不按 bug 或控件拆 skill

不建议拆成：

- 图片缩放 skill。
- 手势翻页 skill。
- Universal Link skill。
- 头像上传 skill。

这些粒度太细，会导致 skill 数量膨胀、触发困难、内容重复。

更合理的拆法是按长期反复出现的工程问题域拆分。

### 3. 不做过度跨端抽象

讨论中曾考虑过 `product / app / apple / swiftui` 多层结构，例如把 AI 生成、积分权益、领域建模拆成跨技术栈 product skill。

这个方向理论上更通用，但对当前目标过抽象。短期只做 Apple SwiftUI 客户端时，过度抽象会破坏 skill 的可用性和特性。

因此最终收敛为：

```text
arckit-swiftui-{capability}
```

先把 Apple SwiftUI 客户端这条线做深。以后做 Web、Android 或其他端，再参考这些能力域另拆对应体系。

### 4. 第一版不追求完备覆盖所有未来

Skill 体系应该像代码架构一样渐进演化。

有些方向成立，但第一版先不独立，例如：

- 强账号体系。
- 专业积分/订阅/IAP 账务体系。
- 专业音频/视频播放运行时。

这些可以先放在相关 skill 的 reference/checklist 中。等第二个或第三个项目再次出现，再拆成独立 skill。

### 5. 渐进加载比大而全更重要

Skill 的上下文加载分三层：

```text
metadata(description) -> SKILL.md -> references/scripts/assets
```

设计原则：

- `SKILL.md` 只放触发后必须立即执行的流程、读取资源、最低交付标准和降级条件。
- 细节机制、代码骨架、检查表放到当前 skill 的 `references/`。
- reference 应该一跳可达，避免深层索引和跨目录大文件。
- 不要让一个 `code-patterns.md` 成为所有 skill 的混合大仓库。
- 跨 skill 只引用能力名；需要代码模式时，应优先读当前 skill 自己的 reference。

这也是后来拆分 `code-patterns.md` 的依据：状态/Service 代码模式归 `state-dataflow`，View 组织归 `view-composition`，导航归 `navigation-routing`，foundation 只保留工程底座基础模式。

### 6. Skill 内容要符合 SwiftUI 和 Swift 最佳实践

当前体系面向 Apple SwiftUI 客户端，因此代码骨架必须遵守：

- SwiftUI first：优先使用 SwiftUI 原生 API。
- UIKit/AppKit 只在 SwiftUI 不覆盖或系统能力边界时使用，并隔离在 adapter、representable、service 或 platform helper。
- 使用 Swift Concurrency：`async/await`、`Task`、`actor`、`@MainActor`。
- Service 使用 `Sendable` 协议或清晰可替换边界。
- 长生命周期共享可变状态优先用 `actor` 保护。
- View 是协调者，但不写底层网络、Keychain、文件 IO、系统桥接细节。
- UI 状态局部化，复杂关联状态才抽 `@Observable`。
- View body 不做 JSON decode、排序、DateFormatter 创建、文件 IO、图片压缩等重计算。

## 命名规范

Skill 命名统一采用：

```text
arckit-swiftui-{capability}
```

其中：

- `arckit`：统一命名前缀，表示 ArcKit/Codex Agent 可复用工程能力。
- `swiftui`：当前 skill 体系面向 Apple SwiftUI 客户端开发。
- `{capability}`：稳定问题域，使用小写短横线。

命名约束：

- 不使用项目名、业务专有名或具体产品事实。
- 不按 bug 命名，例如不要命名为 `arckit-swiftui-fix-animation-lag`。
- 不按单个控件命名，例如不要命名为 `arckit-swiftui-image-zoom`。
- capability 应表达长期问题域，而不是一次性实现任务。

## 最终结论：12 个核心 Atom Skill

第一版建议沉淀 12 个 `arckit-swiftui-*` atom skill。

### 1. arckit-swiftui-foundation

职责：SwiftUI 工程底座，从 0 到 1 建壳工程。

覆盖：

- Xcode / SPM 工程结构。
- App 入口。
- Package 组织。
- 目录约定。
- 基础 DesignTokens。
- 基础 Environment 注入。
- 基础测试结构。
- 平台版本和技术栈约束。

原有 SwiftUI 总纲 skill 已重命名并收敛为 `.codex/skills/arckit-swiftui-foundation/SKILL.md`，作为 foundation skill，不再无限覆盖所有复杂问题。

### 2. arckit-swiftui-state-dataflow

职责：SwiftUI 状态、数据流与分层边界。

覆盖：

- `@State`、`@Observable`、`@Query`、`@Environment` 的使用决策。
- View / Model / Service 边界。
- Service 协议、实现和环境注入。
- View 作为协调者时的职责边界。
- 业务状态和 UI 状态拆分。
- 服务层避免依赖 UI 类型。

### 3. arckit-swiftui-view-composition

职责：页面组织、组件边界和设计系统落地。

覆盖：

- View 拆分。
- 组件复用边界。
- DesignTokens 使用。
- Dynamic Type。
- VoiceOver。
- 国际化布局。
- Preview 和基础 UI 状态覆盖。

### 4. arckit-swiftui-navigation-routing

职责：导航、外部入口和路由统一。

覆盖：

- NavigationStack / NavigationSplitView。
- Tab、sheet、fullScreenCover、modal。
- Deep Link。
- Universal Link。
- URL Scheme。
- Widget / Push 入口。
- 分享入口跳转。
- 路由生成和解析的 round-trip tests。

核心原则：

```text
所有外部入口必须进入统一 parser/router，不允许各入口散落解析逻辑。
```

### 5. arckit-swiftui-networking-api

职责：普通网络 API 与服务端数据通道。

覆盖：

- REST / GraphQL。
- 分页。
- 鉴权 token。
- refresh token。
- 错误码映射。
- 请求取消。
- 重试。
- 弱网。
- DTO 到领域模型转换。
- 上传下载。

AI 生成不放在这里；AI 的 prompt、stream、结构化解析、质量门和成本控制由 `arckit-swiftui-ai-generation` 处理。

### 6. arckit-swiftui-system-integration

职责：Apple 系统能力与 SwiftUI 边界。

覆盖：

- PhotosPicker。
- ShareLink。
- LinkPresentation。
- WidgetKit。
- UserNotifications。
- 权限。
- Keychain。
- 后台任务。
- 必要 UIKit/AppKit 桥接。

核心原则：

```text
SwiftUI first；UIKit/AppKit 只在 SwiftUI 不覆盖或系统能力边界时使用，并隔离在 adapter/service 层。
```

### 7. arckit-swiftui-media-pipeline

职责：图片、音频、视频等媒体管线的第一版统一 skill。

覆盖：

- 远程图片加载。
- 内存/磁盘缓存。
- 占位。
- 失败态。
- 重试。
- fallback URL。
- 图片查看器。
- 缩放和平移。
- 上传前压缩。
- 分享封面。
- Widget 图片。
- 基础音频/视频播放接入。

第一版先不单独拆 `audio-playback`。如果后续音频/视频类项目变多，再从这里拆出独立 skill。

### 8. arckit-swiftui-interaction-motion

职责：手势、动画和复杂交互状态机。

覆盖：

- Drag、pinch、scroll、tap、long press 的组合。
- Gesture priority 和互斥关系。
- 翻页。
- 拖拽。
- 缩放。
- 平移。
- 动画 transaction。
- 手势进行中使用局部轻量状态。
- 手势结束后再提交业务状态。

它不只是“怎么写动画”，而是处理交互状态如何不拖垮渲染。

### 9. arckit-swiftui-performance-quality

职责：性能、卡顿治理和质量回归。

覆盖：

- View body 禁止重计算。
- JSON decode、排序、DateFormatter、复杂数据准备离开渲染路径。
- display model 预处理。
- 列表性能。
- 图片内存压力。
- MainActor 压力。
- 异步任务调度。
- Instruments 检查。
- 单元测试、交互测试、回归检查。

它和 `arckit-swiftui-interaction-motion` 的区别：

- interaction-motion 管交互模型。
- performance-quality 管渲染成本、诊断和质量门。

### 10. arckit-swiftui-local-data-lifecycle

职责：本地数据生命周期。

覆盖：

- SwiftData schema。
- 本地缓存。
- 草稿。
- 历史。
- 作品/记录生命周期。
- 数据迁移。
- 数据损坏降级。
- 导入导出。
- Widget 共享数据。
- 缓存清理。

### 11. arckit-swiftui-ai-generation

职责：AI 生成链路在 SwiftUI 客户端中的落地。

覆盖：

- Prompt 结构。
- 流式输出。
- SSE。
- 结构化输出解析。
- 生成取消。
- 防抖。
- 超时。
- 重试。
- 去重。
- 质量校验。
- 成本控制。
- 生成状态 UI。
- 生成失败恢复。

积分/权益第一版不独立，相关检查可先作为该 skill 的 reference/checklist。

### 12. arckit-swiftui-release-observability

职责：发布配置与线上反馈闭环。

覆盖：

- Entitlements。
- Associated Domains。
- AASA。
- App Groups。
- Push capability。
- Privacy Manifest。
- Info.plist 权限文案。
- App Store 审核。
- TestFlight。
- 构建配置。
- 埋点。
- 日志。
- 崩溃。
- 线上指标。
- 性能指标。

第一版将 release 和 observability 合并，因为它们都属于上线和线上反馈闭环。后续若多项目中埋点/实验/监控复杂度上升，再拆出独立 observability skill。

## 当前两个项目的映射验证

### AnimeCalendar

AnimeCalendar 主要验证以下 skill：

| 问题 | 对应 skill |
| --- | --- |
| 用 Universal Link 做分享 | `arckit-swiftui-navigation-routing` + `arckit-swiftui-system-integration` + `arckit-swiftui-release-observability` |
| Widget 点击跳详情 | `arckit-swiftui-navigation-routing` + `arckit-swiftui-system-integration` |
| 页面卡顿 | `arckit-swiftui-performance-quality` |
| 动画卡顿 | `arckit-swiftui-interaction-motion` + `arckit-swiftui-performance-quality` |
| 手势翻页调整 | `arckit-swiftui-interaction-motion` |
| 图片缩放以触点为中心 | `arckit-swiftui-media-pipeline` + `arckit-swiftui-interaction-motion` |
| 图片失败、重试、兜底 | `arckit-swiftui-media-pipeline` + `arckit-swiftui-performance-quality` |
| 头像选择和上传 | `arckit-swiftui-media-pipeline` + `arckit-swiftui-system-integration` |
| 非必要不使用 UIKit | `arckit-swiftui-system-integration` + `arckit-swiftui-state-dataflow` |
| 服务层去 UI 类型依赖 | `arckit-swiftui-state-dataflow` + `arckit-swiftui-media-pipeline` |

### YueYaMelody

`../yueya-melody` 主要验证以下 skill：

| 问题 | 对应 skill |
| --- | --- |
| AI 儿歌生成、SSE、结构化输出 | `arckit-swiftui-ai-generation` + `arckit-swiftui-networking-api` |
| 九音音域、难度四维度、节奏量化 | `arckit-swiftui-state-dataflow` + `arckit-swiftui-local-data-lifecycle` |
| 生成失败、超时、重试、不可中途取消 | `arckit-swiftui-ai-generation` + `arckit-swiftui-performance-quality` |
| 积分、槽位、扣费、余额、失败后解释 | 第一版放入 `arckit-swiftui-ai-generation` 的 reference/checklist；复杂度上升后拆独立权益 skill |
| 作品、草稿、版本、数据异常保底 | `arckit-swiftui-local-data-lifecycle` |
| 触键发声、回放、AudioSession、中断 | 第一版放入 `arckit-swiftui-media-pipeline`；音频项目增多后拆独立音频 skill |
| Keychain、凭据校验、系统安全存储 | `arckit-swiftui-system-integration` + `arckit-swiftui-networking-api` |
| 横屏创作主界面、键盘交互、播放互斥 | `arckit-swiftui-interaction-motion` + `arckit-swiftui-performance-quality` |

## 暂不独立的方向

这些方向成立，但第一版先不拆独立 skill。

### 账号与安全

暂不独立为 `arckit-swiftui-account-security`。

第一版放入：

- `arckit-swiftui-networking-api`
- `arckit-swiftui-system-integration`

未来拆分条件：

- 多项目出现完整账号体系。
- 涉及登录、注销、Apple 登录、手机号/邮箱、隐私合规、敏感数据保护、账号删除等复杂流程。

### 积分、权益与扣费

暂不独立为 `arckit-swiftui-entitlement-accounting`。

第一版放入：

- `arckit-swiftui-ai-generation` 的 reference/checklist。
- 必要时与 `arckit-swiftui-local-data-lifecycle` 配合。

未来拆分条件：

- 多项目出现积分、订阅、IAP、会员、额度、次数限制、扣费失败解释。
- 需要独立处理幂等、退款、权益刷新、账务状态和门控 UX。

### 专业音频/视频运行时

暂不独立为 `arckit-swiftui-audio-playback`。

第一版放入：

- `arckit-swiftui-media-pipeline`

未来拆分条件：

- 出现多个音频/视频强相关项目。
- 涉及 AVAudioEngine、录制、低延迟触键、session 中断恢复、route change、实时调度等高复杂度问题。

### 独立埋点与观测

暂不独立为 `arckit-swiftui-observability-analytics`。

第一版放入：

- `arckit-swiftui-release-observability`

未来拆分条件：

- 多项目出现复杂埋点体系、A/B 实验、离线上报、漏斗分析、MetricKit、线上性能归因。

## 当前落地状态

第一版 12 个 atom skill 已落到 `.codex/skills/`：

```text
.codex/skills/arckit-swiftui-foundation/
.codex/skills/arckit-swiftui-state-dataflow/
.codex/skills/arckit-swiftui-view-composition/
.codex/skills/arckit-swiftui-navigation-routing/
.codex/skills/arckit-swiftui-networking-api/
.codex/skills/arckit-swiftui-system-integration/
.codex/skills/arckit-swiftui-media-pipeline/
.codex/skills/arckit-swiftui-interaction-motion/
.codex/skills/arckit-swiftui-performance-quality/
.codex/skills/arckit-swiftui-local-data-lifecycle/
.codex/skills/arckit-swiftui-ai-generation/
.codex/skills/arckit-swiftui-release-observability/
```

结构约定：

```text
skill/
├── SKILL.md              # 触发后执行流程、读取资源、最低交付标准
├── references/           # 机制、代码骨架、反模式、验证要求
├── agents/openai.yaml    # UI 元数据和默认 prompt
└── scripts/templates     # 仅在确有确定性操作或模板资产时存在
```

当前数量：

- 12 个 `SKILL.md`。
- 18 个 `references` 文件。
- 12 个 `agents/openai.yaml`。
- foundation 保留 `scripts/create-ios-app.sh` 和 `templates/ios-app-template/`。

所有 skill 已通过 `skill-creator/scripts/quick_validate.py` 基础校验。

## Foundation 的收敛

原有 `arckit-code-swiftui` 已重命名并收敛为 `arckit-swiftui-foundation`。

它现在只负责：

- 从 0 到 1 的 SwiftUI 工程底座。
- Xcode/SPM/目录结构。
- App 入口。
- 基础 DesignTokens。
- 基础 service 注入样板。
- 基础测试结构。
- 脚手架命令。

不再承担所有复杂 SwiftUI 问题。状态、View 拆分、路由、媒体、交互、性能、网络、AI、本地数据、系统能力、发布观测都进入对应 atom skill。

新建项目脚手架命令保留为一条明确示例：

```bash
bash .codex/skills/arckit-swiftui-foundation/scripts/create-ios-app.sh \
  --name MyApp \
  --package MyAppPackage \
  --bundle-id com.example.MyApp \
  --output ~/Projects
```

## Code Patterns 的拆分原则

旧 skill 中的 `code-patterns.md` 曾经是一个混合大文件，包含状态管理、Service、View 拆分、导航、并发、检查清单等内容。

后续已经按能力拆分：

- `foundation/references/code-patterns.md`：只保留类型选择、App 入口、目录职责、文件组织、并发基线、foundation 检查清单。
- `state-dataflow/references/code-patterns.md`：状态选择、`@State`、`@Observable`、Service protocol、Environment 注入、反模式。
- `view-composition/references/code-patterns.md`：一个文件一个 View、父子 View 职责、状态矩阵、DesignTokens 使用。
- `navigation-routing/references/code-patterns.md`：route、NavigationManager、NavigationStack、NavigationSplitView、外部入口解析。

判断原则：

```text
具体能力的代码模式归具体 skill；foundation 只保留跨能力工程骨架。
```

这样做的目的：

- 避免跨 skill 读取大而混杂的 reference。
- 保持渐进加载。
- 让 Agent 在当前任务中只加载当前能力需要的代码模式。
- 避免 foundation 重新退化成 SwiftUI 技术栈总纲。

## 执行能力包质量标准

后续每个 skill 的 reference 应按以下结构持续演化：

```text
## 决策机制
## 推荐代码骨架
## 反模式
## 验证要求
```

不是每个 reference 都必须机械包含全部标题，但核心原则必须能落到代码机制。

当前已补强的重点：

- `networking-api`：`APIEndpoint`、`APIError`、`APIClient`、DTO mapper、Feature Service、refresh token single-flight actor。
- `media-pipeline`：远程图片状态机、`ImageCache actor`、`RemoteImageLoader`、SwiftUI 组件边界、平台图片适配、上传 payload、图片查看器状态。
- `interaction-motion`：临时状态/提交状态分层、翻页 reducer、DragGesture 提交流程、缩放锚点、手势互斥。
- `performance-quality`：display model、formatter 缓存、Observable 粒度、`.task(id:)` 可取消模式、body 前后对比。
- `ai-generation`：`PromptBuilder`、输出 schema、validator、生成状态机、service、View 防重复任务。
- `system-integration`：SwiftUI 原生优先决策表、权限状态、系统 adapter、Keychain service、UIKit bridge、App Group 路径。
- `local-data-lifecycle`：数据生命周期契约、SwiftData entity、草稿 store、文件缓存 actor、Widget snapshot、损坏降级错误。
- `release-observability`：事件命名、Tracker protocol、日志脱敏、Deep Link 观测、Capability 配置记录。

## 后续演化规则

新增或拆分 skill 时，按以下条件判断：

1. 是否在多个项目反复出现？
2. 是否仅靠模型常识容易写错？
3. 是否涉及平台边界、架构边界、性能、发布、线上问题？
4. 是否已经在现有 skill 中形成稳定 reference，但复杂度继续上升？
5. 是否能抽象成能力域，而不是单个 bug、控件或页面？

满足这些条件后再拆独立 skill。否则先放入最相关 skill 的 reference/checklist 中。
