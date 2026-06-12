# 发布配置与线上观测规则

## 发布配置清单

按功能检查：

- Bundle ID。
- Signing Team。
- Entitlements。
- Associated Domains。
- App Groups。
- Push capability。
- Background Modes。
- Keychain Sharing。
- Privacy Manifest。
- Info.plist 权限文案。
- URL Types。
- Localizations。

配置要和代码、Developer 后台、服务端文件一致。

## Universal Link 发布检查

- entitlements 包含 `applinks:`。
- AASA 部署在正确路径。
- HTTPS 可访问。
- Team ID + Bundle ID 匹配。
- path 规则覆盖业务链接。
- fallback 页可用。
- 冷启动、热启动都验证。

## Privacy

检查：

- 权限文案是否准确。
- 是否收集用户数据。
- 是否记录敏感信息。
- 日志是否脱敏。
- 第三方 SDK 是否有隐私要求。
- Privacy Manifest 是否更新。

## 埋点设计

关键流程至少有：

- start。
- success。
- failure。
- cancel。

事件属性：

- 使用稳定枚举。
- 不传大对象。
- 不传敏感内容。
- 错误分类可分析。

## 日志与崩溃

日志应帮助定位：

- 用户在哪个流程。
- 当前状态。
- 失败类型。
- 关键 id，需脱敏。
- 请求或生成 trace，如项目需要。

不要记录 API Key、token、完整个人内容。

## TestFlight 前检查

- clean build。
- 关键流程手测。
- 权限弹窗。
- deep link。
- Widget。
- 网络失败。
- 数据迁移。
- 崩溃日志可见。
- 埋点事件可见。

## 检查清单

- 能力配置是否成套？
- 服务端文件是否部署？
- 权限文案是否匹配？
- 隐私和日志是否脱敏？
- 关键流程是否有埋点？
- 崩溃和错误是否能定位？
- 发布前是否有回归路径？

## 观测实现口径

- 事件名稳定、可聚合，按项目已有 analytics 命名规范组织。
- 业务代码依赖项目现有 tracker/logger 边界；没有边界时再建立最小协议或 adapter。
- 关键流程记录开始、成功、失败、取消或项目等价状态。
- 事件属性使用稳定枚举或受控 key，不传大对象、token、API Key、完整用户输入或敏感 URL。
- 路由解析成功和失败都要能定位到入口、目标类型和错误分类。
- 线上日志只记录分类、状态和脱敏 id。

## Capability 配置记录

发布能力要在代码仓库留下可 review 的配置记录。

```text
Capability: Associated Domains
Entitlement: applinks:example.com
Server file: https://example.com/.well-known/apple-app-site-association
Verification: cold start / warm start / logged out / fallback page
Owner: iOS + server
```

## 验证要求

- Universal Link：AASA HTTPS 可访问、Team ID/Bundle ID 匹配、冷热启动、fallback。
- Privacy：Info.plist 文案、Privacy Manifest、SDK 隐私声明一致。
- 埋点：关键流程 start/success/failure/cancel 都可见。
- 日志：token、API key、用户输入、完整个人内容不进入线上日志。
- TestFlight：clean build、权限、deep link、Widget、弱网、迁移、崩溃收集。
