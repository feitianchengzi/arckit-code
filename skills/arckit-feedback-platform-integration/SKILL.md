---
name: arckit-feedback-platform-integration
description: 引导接入 https://feedback.feitianchengzi.com 反馈平台，支持 SDK WebView 和原生 API 两种接入方案，默认通过本地 UI 一次性选择接入方案、源码静态配置、本地忽略配置、安全 UI/secret store、后端运行时配置等凭证策略并采集参数。用于用户要创建或选择反馈项目、生成接入配置、在 iOS/Android/Web/WebView 客户端集成反馈 SDK 页面或直接调用反馈 API、实现提交反馈和我的反馈入口、设计登录用户 ID 或游客设备 ID 绑定，或要求通过 UI 安全填写接入参数时。
---

# 反馈平台接入

## 核心原则

先完成接入向导，再写代码。已有 WebView、Profile 入口、占位 provider 或测试桩只代表“客户端壳/占位实现”，不代表真实接入完成。

接入方案必须由参数 UI 或等价配置统一选择，不要由 agent 擅自固定：

- `sdk-webview`: 加载反馈平台 SDK 页面，调用 `openSubmit()` / `openStatus()`。
- `native-api`: 直接调用反馈 API，自定义原生提交表单和“我的反馈”列表。

凭证策略也必须显式选择：

- `source-static`: 用户接受 API Key 进入客户端源码/安装包；可最快接入，但客户端可提取。
- `local-ignored`: API Key 写入被 git ignore 的本地配置。
- `secret-store`: API Key 写入安全 UI / secret store，agent 只使用 handle。
- `backend-runtime`: 客户端不采集 API Key，由后端运行时接口或代理提供。

除非参数 UI 不可用且用户明确允许源码静态配置，否则不要要求用户把 `apiKey` 粘贴到对话里，也不要把明文写入仓库文件。任何策略下都不要在日志、错误提示或最终回复中输出完整 API Key。

## 必须门禁

- **平台官网门禁**：进入代码编辑前，必须当场引导用户打开 `https://feedback.feitianchengzi.com` 创建或选择项目，并取得数字型 `Project ID` 和项目 `API Key`。如果工具不可用、用户拒绝或用户明确说不要打开，记录原因。
- **参数采集门禁**：进入真实 provider 落地前，必须已通过 UI、secret store、本地忽略配置、源码静态配置文件或后端运行时配置取得结构化结果。没有真实参数或运行时配置结果时，不要创建默认启用的静态 provider、空 `apiKey` 配置或占位 provider，除非用户明确要求占位。
- **源码静态配置门禁**：用户选择源码静态配置只表示接受客户端暴露风险；仍必须完成平台官网引导和 `Project ID` / `API Key` 采集。macOS 环境优先用参数 UI 采集并由脚本直接写入指定文件。

## 工作流

1. 确认入口位置、目标平台、是否已有登录体系，以及是否需要“提交反馈”和“我的反馈”两个入口。
2. 引导或申请打开平台官网，拿到 `Project ID` 和 `API Key`。
3. 读取 [安全 UI 与参数回传契约](references/secure-parameter-handoff.md)，触发参数 UI 或等价 credential flow，取得 `integrationMode`、`credentialStrategy`、`projectId`、`apiKeyStatus`、`customUserIdMode`。
4. 读取 [凭证与用户身份策略](references/credential-and-identity.md)，按返回策略接入 provider，并明确 `customUserId` 来源。
5. 按 `integrationMode` 读取对应参考：
   - `sdk-webview`: 读取 [SDK WebView 模式](references/sdk-webview-mode.md)。
   - `native-api`: 读取 [原生 API 模式](references/native-api-mode.md)。
6. 若目标是 iOS SwiftUI，读取 [iOS SwiftUI 落地](references/ios-swiftui.md)。
7. 实现提交反馈和“我的反馈”入口，验证加载/请求、配置、用户 ID 持久化和错误态。

## macOS 参数 UI

macOS 本地环境优先运行：

```bash
swift skills/arckit-feedback-platform-integration/scripts/collect_feedback_config.swift \
  --output /private/tmp/feedback-config.json \
  --static-swift-output ios/AnimeCalendar/AnimeCalendar/Features/Feedback/FeedbackPlatformStaticConfig.generated.swift \
  --local-json-output ios/AnimeCalendar/FeedbackPlatform.local.json
```

脚本会弹窗选择 `integrationMode`、凭证策略、`Project ID`、`API Key` 和用户 ID 模式；不会把 API Key 明文输出到 stdout。运行 GUI、访问 Keychain 或调用 credential flow 时，按当前环境权限规则申请授权。

## 验证与输出

验证时按所选方案检查：

- `sdk-webview`: SDK 页面能加载，`configure` 只在页面可用后调用，提交入口调用 `openSubmit()`，我的反馈入口调用 `openStatus()`。
- `native-api`: POST 能创建反馈，GET 能返回当前 `customUserId` 的反馈列表，响应解析覆盖 `{code,data}` 和可选 `meta`，并能处理 `data` 字段内的 JSON string。
- 两种方案都要验证 `projectId` 为数字、API Key 来源符合凭证策略、`customUserId` 稳定且不泄露敏感个人信息。

最终回复必须说明：

- 是否已引导打开平台官网；未打开则说明原因。
- 本轮采用的 `integrationMode` 和凭证策略；未运行参数 UI 时说明原因。
- `Project ID`、API Key、`customUserId` 的来源策略，不包含完整 API Key。
- 已修改或建议修改的文件、验证结果、未完成风险。
- 仓库已有反馈代码属于“客户端壳/占位实现/完整接入”中的哪一种。
