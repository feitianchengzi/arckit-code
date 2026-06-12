---
name: arckit-swiftui-system-integration
description: SwiftUI 与 Apple 系统能力集成 skill。用于 PhotosPicker、WidgetKit、UserNotifications、权限、Keychain、App Groups、后台任务、文件选择、相机、系统级滚动/缩放/输入控件、必要 UIKit/AppKit 桥接、SwiftUI first 边界。用户提到相册、拍照、通知、Widget、权限、Keychain、系统 API、UIKit 桥接、平台控件桥接边界时使用。
---

# ArcKit SwiftUI System Integration

## 目标

把 Apple 系统能力接入 SwiftUI App，同时保持 SwiftUI first、桥接隔离、权限/entitlements 明确。Agent 执行时不要简单“能调用系统 API”，而要把失败、权限、发布配置和业务边界一起处理。

## 执行流程

1. 明确要接入的系统能力：相册、相机、Widget、通知、Keychain、App Group、后台任务、文件、触觉、AudioSession 等。
2. 先判断 SwiftUI 原生 API 是否足够覆盖真实体验；足够时优先使用原生能力。
3. SwiftUI 不覆盖或复刻成本会损害体验时，使用 adapter/service/representable 隔离 UIKit/AppKit，不让 UIKit 类型进入领域层和普通 service API。
4. 明确权限请求时机、拒绝后的降级路径、Info.plist 文案、entitlements、App Group、Associated Domains 等配置。
5. 把系统返回结果转成稳定业务数据，例如 `Data`、`URL`、业务 id、枚举状态。
6. 对可测试逻辑建立 protocol 和 fake；系统弹窗、权限状态、失败场景至少给出手测路径。
7. 涉及发布能力时同步更新 release/observability 检查，不只改 Swift 文件。

## 读取资源

- PhotosPicker、WidgetKit、Keychain、权限、App Group、UIKit/AppKit bridge：`references/apple-integration-boundaries.md`
- entitlements、AASA、Privacy Manifest、TestFlight：`arckit-swiftui-release-observability`
- 分享素材、系统级图片查看器、二维码分享图：`arckit-swiftui-share-media`

## 核心规则

```text
SwiftUI first, not SwiftUI only；UIKit/AppKit 只作为系统能力边界存在，并被隔离在窄接口后面。
```

| 系统能力 | 落地要求 |
| --- | --- |
| PhotosPicker | View 可持有选择器，后续压缩/上传下沉 |
| Keychain | 只存敏感凭据，不用 UserDefaults 代替 |
| Widget/App Group | 使用共享容器和稳定业务 id |
| 外部入口 | 分享链接、Widget、Push 统一转成稳定业务目标 |
| 权限 | 用户理解场景再触发，拒绝可降级 |
| UIKit/AppKit bridge | 包在 representable/adapter 内，不扩散 |
| 系统级滚动/缩放/输入 | 优先成熟平台控件，不用 SwiftUI 硬复刻 |

## 最低交付标准

- 已评估 SwiftUI 原生 API 是否能满足。
- 已说明为何选择 SwiftUI 原生或平台桥接；体验关键路径不能只以“纯 SwiftUI”为理由牺牲系统行为。
- 必要 bridge 被隔离，调用方不依赖 ViewController/AppKit 对象。
- Info.plist、entitlements、App Group、Associated Domains 等配置被明确写出或更新。
- 权限拒绝、系统失败、数据缺失都有 UI 或业务降级路径。
- 敏感数据使用 Keychain 等安全存储。

## 降级/停止条件

- 纯 SwiftUI 内部交互不使用本 skill，转到 view composition 或 interaction motion；但一旦需要平台控件桥接，本 skill 必须参与。
- 只是已有系统封装的小参数调整，不扩大抽象。
- 需要开发者账号、服务端 AASA/Push 配置但本地无法完成时，完成代码侧和文档化待办。
