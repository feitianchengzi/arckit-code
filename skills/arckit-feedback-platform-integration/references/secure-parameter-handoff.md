# 安全 UI 与参数回传契约

本 reference 用于反馈平台接入时通过 UI 选择接入方案和凭证策略，并采集 `projectId`、`apiKey` 和 `customUserIdMode`。目标是让用户通过 UI 或安全配置通道填写参数，agent 只消费结构化状态、写入路径或 opaque handle；默认不通过聊天粘贴 `apiKey`。

如果用户已经明确选择“iOS 源码可以存”“先硬编码/静态配置”等源码静态配置策略，仍优先使用本文 UI 流程，并让脚本直接写入指定 Swift 配置文件。只有用户明确拒绝 UI 或当前环境无法运行 UI 时，agent 才按主 skill 的源码静态配置规则处理明文；仍不要在日志和最终回复中复述完整 `apiKey`。

## UI 承载职责

参数 UI 承载这些输入：

- `integrationMode`: `sdk-webview` 或 `native-api`。必须由 UI 或等价配置统一选择；agent 不应擅自固定接入方案。
- `credentialStrategy`: `source-static`、`local-ignored`、`secret-store` 或 `backend-runtime`。
- `projectId`: 数字型项目 ID，可以显示给用户确认。
- `apiKey`: 项目 API Key，输入框必须按 secret 处理，默认隐藏，不回显给 agent；`backend-runtime` 策略不采集。
- `customUserIdMode`: `business-user-id` 或 `persistent-guest-id`。UI 只需要让用户选择模式。

UI 或脚本应根据 `customUserIdMode` 自动派生 `customUserIdSource`，不要让用户手填自由文本：

- `business-user-id` -> `AuthService.currentUser.id.uuidString`
- `persistent-guest-id` -> `Keychain:feedback.customUserId`

UI 不应把 `apiKey` 明文写入聊天上下文、普通日志、测试 fixture、stdout 或 agent 可读取的临时报告。`source-static` 策略例外：UI 可以把 `apiKey` 写入用户认可的 Swift 源码配置文件，并只回传写入路径和状态。

## 本地 macOS 脚本

本 skill 自带 `scripts/collect_feedback_config.swift` 作为最小 UI 承载。它使用 AppKit 弹窗选择接入方案和凭证策略并采集参数，自动派生 `customUserIdSource`，按策略写入 Swift 静态配置、本地忽略配置或 macOS Keychain，并把结构化结果写入指定 JSON 文件。

推荐调用：

```bash
swift skills/arckit-feedback-platform-integration/scripts/collect_feedback_config.swift \
  --output /private/tmp/feedback-config.json \
  --static-swift-output ios/AnimeCalendar/AnimeCalendar/Features/Feedback/FeedbackPlatformStaticConfig.generated.swift \
  --local-json-output ios/AnimeCalendar/FeedbackPlatform.local.json
```

该命令会打开 GUI。运行前确认当前平台允许 GUI；如果需要审批，说明“用于让用户在本机窗口选择反馈平台接入方案和凭证策略并输入 API Key，脚本不会把明文输出到 stdout”。

不要通过命令行参数、环境变量或 stdin 传入真实 `apiKey`，因为这些路径可能被 shell history、进程列表或日志暴露。

## 结构化回传

推荐 UI 返回：

```json
{
  "integrationMode": "native-api",
  "projectId": 1,
  "credentialStrategy": "secret-store",
  "apiKeyStatus": "stored",
  "apiKeyHandle": "secret://feedback-platform/anime-calendar/api-key",
  "apiKeyOutputPath": null,
  "customUserIdMode": "persistent-guest-id",
  "customUserIdSource": "keychain:feedback.customUserId",
  "configuredByUser": true
}
```

字段规则：

- `integrationMode` 是用户选择的接入方案：`sdk-webview` 表示加载平台 SDK 页面；`native-api` 表示直接调用反馈 API 并自定义原生 UI。
- `projectId` 可以返回真实数字。
- `credentialStrategy` 是用户在 UI 中选择的凭证策略。
- `apiKeyStatus` 只能是 `written`、`stored`、`not-collected`、`missing`、`missing-output`、`cancelled` 或 `invalid`。
- `apiKeyHandle` 是 secret 引用，不是明文；只在 `secret-store` 策略下出现。
- `apiKeyOutputPath` 是脚本写入的源码配置或本地配置路径；不是明文。
- `customUserIdSource` 由模式自动派生，不应包含真实用户 ID。
- `configuredByUser` 表示用户是否完成 UI 提交。

## Agent 后续动作

收到结构化结果后，agent 可以：

- 对 `integrationMode=sdk-webview`，继续实现 WebView 加载、SDK configure、提交反馈和我的反馈入口。
- 对 `integrationMode=native-api`，继续实现原生 API client、请求/响应 Codable 模型、提交表单、我的反馈列表、分页、空态和错误态。
- 对 `source-static`，使用 `apiKeyOutputPath` 对应的 Swift 配置文件接入静态 provider，并同步 target membership。
- 对 `local-ignored`，确认 `apiKeyOutputPath` 已被 git ignore，再接入本地配置 provider。
- 对 `secret-store`，在代码中引用 `apiKeyHandle` 对应的运行时读取接口。
- 对 `backend-runtime`，接入后端运行时配置接口，或保留“运行时凭证未接入”状态。
- 写入不含密钥的配置 schema、占位 `.example` 文件或 build setting 名称。
- 检查 `projectId` 类型和 `customUserId` 策略。
- 根据 `integrationMode` 继续实现 SDK WebView 或原生 API UI。
- 判断客户端是否有后端运行时配置接口可用；如果没有，且用户没有在 UI 中选择源码静态配置或本地忽略配置，停在运行时凭证未接入状态，不要把 `apiKey` 编进安装包。

agent 不可以：

- 跳过可用的参数 UI，改为要求用户把 `apiKey` 粘贴到对话。
- 打印、读取或复述 secret store 中的 `apiKey` 明文。
- 在非 `source-static` 策略下把包含明文 `apiKey` 的文件加入版本控制。
- 为了调试而在日志中输出完整配置对象。

若用户之后明确要求把已采集的密钥迁移到源码静态配置，需要再次确认该选择，并优先重新运行 UI 选择 `source-static`；只有 UI 不可用时才按主 skill 的源码静态配置规则执行。

## 无 UI 时的降级

如果当前环境没有参数 UI、secret store 或 credential flow：

1. 停止索要明文 `apiKey`。
2. 创建或修改代码，使其从后端运行时配置、短期会话参数或等价安全机制读取 Project ID 和 API Key。
3. 不要把 `apiKey` 写入 `Info.plist`、`.xcconfig`、Build Settings、源码常量或客户端资源。
4. 告诉用户需要在后端安全配置、服务端代理、短期会话参数接口或平台支持的安全客户端机制中填写真实值。
5. 将本轮结果标记为“代码接入完成，凭证配置待用户在安全通道完成”。

如果用户明确改选源码静态配置，上述降级流程不适用；回到主 skill 的源码静态配置路径。

## 失败状态

- 用户取消 UI：停止真实接入配置，保留代码占位和待办。
- `projectId` 缺失或非数字：要求用户回到平台确认项目 ID。
- `apiKeyStatus` 为 `missing`：要求用户进入平台接入设置生成 API Key。
- `apiKeyStatus` 为 `invalid`：不要显示明文，提示用户重新生成或重新录入。
