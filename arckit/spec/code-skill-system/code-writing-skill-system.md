# 代码写作 Skill 体系

## 功能定位

代码写作 skill 体系为 Codex 写真实代码提供统一入口和可复用规则。体系只覆盖实现、重构、修复、性能治理、测试补充、代码质量、平台能力接入、发布相关配置代码和 AI 生成链路代码。

该体系不承担产品治理、项目管理、需求分解、非代码文档写作或跨团队流程管理。相关工作由 `arckit/spec`、`arckit/tech`、`project-governance-workflow` 等文档或 skill 承担。

## 核心对象

### arckit-code

`arckit-code` 是所有通用写代码任务的入口。该 skill 负责读取代码事实、判断代码问题类型、识别技术栈、加载最小规则组合、指导修改代码并验证结果。

`arckit-code` 不直接包含所有技术栈细节。它通过任务 reference 和技术栈 overlay 组合形成一次写代码所需的最小上下文。

### 任务 reference

任务 reference 描述一类代码问题的通用判断方式。任务 reference 不绑定单一技术栈，表达“这类代码问题如何分析、如何落边界、如何验证”。

体系支持以下任务域：

- 页面组织：页面拆分、组件边界、状态矩阵、设计系统落地。
- 状态数据流：状态归属、单一事实源、分层边界、派生状态刷新。
- 网络 API：DTO、错误映射、鉴权、分页、上传下载、取消重试。
- 本地数据生命周期：schema、迁移、缓存、草稿、历史、损坏降级。
- 媒体管线：图片、音频、视频、上传、fallback、分享素材。
- 导航路由：内部导航、外部入口、deeplink、解析生成一致性。
- 交互动画：手势互斥、临时状态、提交时机、动画边界。
- 系统集成：平台 API、权限、bridge、扩展进程和配置文件。
- 性能质量：渲染成本、主线程压力、异步任务、回归验证。
- 发布观测代码：发布相关配置、隐私声明文件、日志、埋点、崩溃上下文。
- AI 生成链路：prompt、schema、stream、解析、质量门、成本状态。

### 技术栈 overlay

技术栈 overlay 描述任务 reference 在某个技术栈中的落地方式。SwiftUI、React、Flutter、Node API、Django、Postgres 等都作为技术栈 overlay 存在。

技术栈 overlay 不替代任务 reference。一次写代码通常读取一个任务 reference 和一个技术栈 overlay。

## SwiftUI 体系归属

SwiftUI 写代码能力由 `arckit-code` 的通用任务 reference、SwiftUI overlay 和少量 SwiftUI 专项 skill 共同承担。通用代码问题进入 `arckit-code`，强流程和平台特化问题进入独立专项 skill。

SwiftUI 规则长期分为三类：

- 通用任务规则：由 `arckit-code` 的任务 reference 承担。
- SwiftUI 落地规则：由 SwiftUI overlay 承担。
- 强流程专项能力：由独立 SwiftUI skill 承担。

## SwiftUI 能力归属

`arckit-swiftui-foundation` 是独立专项 skill。它包含脚手架脚本、模板、Xcode project 工程结构和工程底座生成流程。

`arckit-swiftui-share-media` 是独立专项 skill。它覆盖分享海报、ShareLink、二维码识别、系统级图片查看器、Widget/App Group 分享图片素材和平台图片 bridge。

`arckit-swiftui-system-integration` 是独立专项 skill。它覆盖 Apple 系统能力、权限、Widget、Keychain、App Group、必要 UIKit/AppKit bridge 和平台边界。

`arckit-swiftui-release-observability` 是独立专项 skill。它覆盖 Apple 发布配置、entitlements、Privacy Manifest、Info.plist 权限文案、TestFlight、日志和观测代码。

页面组织、状态数据流、普通网络 API、本地数据生命周期、普通媒体加载/缓存/上传、导航路由、交互动画、性能质量和 AI 生成链路由 `arckit-code` 的任务 reference 与 SwiftUI overlay 承担。

## 触发行为

`arckit-code` 默认可隐式触发，用于通用写代码任务。

用户只要求普通 SwiftUI 代码实现时，系统优先使用 `arckit-code`，再根据任务类型读取对应 SwiftUI overlay。

用户要求 SwiftUI 工程底座、复杂媒体管线、Apple 系统能力或 Apple 发布配置代码时，系统使用对应 SwiftUI 专项 skill。

## 成功标准

- 写代码任务有统一入口，不需要让多个 SwiftUI skill 同时竞争触发。
- 每次编码只加载必要任务规则和技术栈规则。
- 通用代码问题不再被绑定到 SwiftUI 单一技术栈。
- SwiftUI 特性仍有独立落地规则，不被跨技术栈抽象抹平。
- 强流程能力保留脚本、模板和专项 skill，不被通用入口吞掉。
