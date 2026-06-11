---
name: arckit-swiftui-networking-api
description: SwiftUI 客户端普通网络 API skill。用于 REST/GraphQL、URLSession、鉴权 token、refresh token、分页、错误码映射、重试、取消、弱网、DTO 到领域模型转换、上传下载、API service、网络日志。用户提到接口、后端、网络请求、登录态 token、分页、上传、下载、错误处理、重试、弱网、DTO、API service 时使用。AI 生成流式输出请同时使用 arckit-swiftui-ai-generation。
---

# ArcKit SwiftUI Networking API

## 目标

把客户端网络能力落成可测试、可取消、可恢复的 SwiftUI API 层。Agent 执行时不要只把 `URLSession` 调通，而要同步建立 DTO 边界、错误分类、鉴权、分页、上传下载和 View 状态衔接。

## 执行流程

1. 先读现有 API service、后端契约、错误码约定和调用页面，判断是新增能力还是接入已有网络框架。
2. 定义最小分层：`View -> Service Protocol -> Service Impl -> API Client -> URLSession`，不要让 View 拼 URL 或直接解码后端结构。
3. 为请求和响应建立 DTO；在 service 或 mapper 中转换为领域模型/display model。
4. 建立错误模型，至少区分网络、超时、取消、认证、权限、服务端、业务错误码、解码失败、文件格式/大小错误。
5. 实现 service protocol、mock/fake、Environment 注入；已有项目有统一注入方式时优先复用。
6. 涉及 token 时处理 refresh 并发互斥；涉及分页时明确首次加载、刷新、加载更多、hasMore、cursor/page、错误重试。
7. 涉及上传下载时使用 `Data`、`URL`、`fileName`、`mimeType`、size limit，不让网络层接收 `UIImage` 或 SwiftUI `Image`。
8. 涉及列表数据刷新时，先定义 freshness policy：刷新 key、TTL/过期条件、什么算成功请求、失败是否返回缓存、空响应是否可覆盖缓存；该判断放在 service/repository 层，不散落到 View/ViewModel。
9. 涉及资源详情加载时，确认资源详情响应是否覆盖目标页面所需的领域数据；若响应缺少入口摘要字段，必须保留入口已有领域数据或增加补全/合并路径。
10. 同一资源存在列表摘要、详情补全、用户态等多个接口 payload 时，freshness policy 必须按接口语义拆分；详情缓存命中条件至少检查资源身份、payload 完整度、详情专用 fetchedAt/syncedAt 未过期。
11. 在 View 层把错误转成 loading/error/retry/empty 等 UI 状态；不要直接展示后端原始错误字符串。
12. 补成功、错误码、解码失败、取消、分页边界、刷新门禁、上传限制等测试；无法跑测试时给出手测路径。

## 读取资源

- API client、DTO、错误分类、分页、鉴权、上传下载：`references/networking-contract.md`
- View/Service/Environment 边界：`arckit-swiftui-state-dataflow`
- AI stream、prompt、结构化输出：同时使用 `arckit-swiftui-ai-generation`

## 核心规则

| 问题 | 执行要求 |
| --- | --- |
| 请求散落 | 收敛到 API client/service |
| DTO 直进 UI | 建立 DTO -> Domain/Display 映射 |
| 错误混乱 | 定义稳定错误枚举和 UI 映射 |
| refresh token 竞态 | 做单飞刷新或串行保护 |
| 分页状态混杂 | 区分 refresh/loadMore/initial |
| 列表每次进页面都全量请求 | 在 service/repository 层定义 freshness policy，缓存未过期时不请求网络 |
| 列表与详情共用新鲜度字段 | 按 payload/接口语义拆分 refresh key 或 syncedAt；列表刷新不得让详情缓存变新鲜 |
| 上传依赖 UI 类型 | 网络层只收稳定数据载体 |
| 资源详情响应不覆盖页面需求 | 保留入口已有领域数据或补拉摘要数据后再合并 |

## 最低交付标准

- View 中没有新增裸 `URLSession`、硬编码 baseURL、重复 request 拼装。
- Service 可 mock，且通过项目约定方式注入。
- DTO 和领域/display 数据边界清楚。
- 请求支持取消和超时语义。
- 列表刷新入口共享同一套 freshness policy；缓存为空、过期、失败、空响应的行为明确。
- 资源详情、列表摘要、用户态等不同 payload 不共用同一个通用同步时间判断新鲜度。
- 用户可见失败态可恢复或可解释。
- 关键路径有测试或明确验证步骤。
- 资源详情加载不会因为接口字段少于入口摘要字段而丢失目标页面依赖的关键 display model。

## 降级/停止条件

- 只改一个已有接口字段映射时，不重建全套 API client，但仍保持 DTO 边界。
- 后端契约缺失时，先基于现有调用推断并标注待确认字段，不编造业务错误码。
- 若功能实际是 AI 生成质量、prompt 或 stream 解析问题，切到 `arckit-swiftui-ai-generation`。
