# iOS SwiftUI 落地

使用条件：目标项目是 iOS SwiftUI App。

## 默认形态

- 在 `Profile`、`Settings` 或同类用户中心页面增加“用户反馈”和“我的反馈”两个入口。
- 接入方案由参数 UI 的 `integrationMode` 决定：`sdk-webview` 使用 `WKWebView`；`native-api` 使用原生 SwiftUI 表单和列表。
- 用独立 Feature 或 Platform Adapter 承载反馈实现，不要把 WebKit delegate、JavaScript 拼接或 URLRequest 直接堆进 Profile 页面。
- 新增 `FeedbackPlatformCredentialProviding` 或同等 provider 边界，让 UI 不直接知道凭证来源。

## SDK WebView

- 用独立 `WKWebView` wrapper 加载 SDK 页面。
- 页面可用后注入配置并调用 `openSubmit()` 或 `openStatus()`。
- JavaScript 注入和错误日志都不得输出完整 API Key。

## 原生 API

- 用独立 service/client 承载 URLRequest、Authorization、Codable 模型和分页。
- 提交表单和“我的反馈”列表使用 ViewModel 管理加载、提交中、成功、失败、空态和重试。
- `data` 字段按 JSON string 处理，解析失败保留原文。

## Xcode 项目

- 如果项目使用 Xcode 文件系统同步 root group，可以直接新增 Swift 文件。
- 如果是传统 `.pbxproj` 文件引用，必须同步 target membership。

## 凭证与用户 ID

- 用户明确允许源码静态配置且已提供真实参数时，把 `Project ID` 和 `API Key` 集中放在一个专用配置文件，并在注释中标明客户端可提取、生产如需升级请迁移到运行时配置。
- 参数未提供时停止请求参数，不要写默认启用的占位静态配置。
- 用户未选择源码静态配置时，不要把 API Key 放进 `Info.plist`、`.xcconfig`、Build Settings、源码常量或任何会进入安装包的资源；使用 secret store、本地忽略配置或后端运行时配置。
- 有登录用户时使用业务用户 ID；无登录用户时生成 `guest-<UUID>` 并优先持久化到 Keychain。
