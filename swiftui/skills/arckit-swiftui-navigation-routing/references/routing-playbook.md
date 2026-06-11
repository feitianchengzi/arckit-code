# 导航与外部入口 Playbook

## 路由事实源

每个 App 应有统一路由事实源：

- route enum。
- URL parser。
- URL builder。
- router/coordinator。
- 测试用例。

外部入口只负责把原始输入交给 parser，不直接决定页面细节。

## 外部入口清单

检查是否涉及：

- Universal Link。
- URL Scheme。
- Widget URL。
- Push payload。
- Share fallback page。
- App 内搜索/列表点击。
- Spotlight / Handoff，如项目需要。

## Route 设计

Route 应表达业务目标，而不是 UI 细节或临时对象：

- 好：`detail(id:)`
- 差：`presentDetailFullScreenWithTemporaryObject`

Route 参数必须能跨设备解析。公开链接不要依赖本机 UUID、临时文件路径或本地数据库 row id。

当同一业务目标有 App 内入口和外部入口两种来源时，route 设计要做入口等价性检查：

- 外部入口解析出的资源身份，应能走到与 App 内入口等价的加载路径。
- 如果 App 内入口携带了目标页面依赖的摘要数据，外部入口必须保留这些数据，或触发等价的补全请求。
- 如果系统有多个 id 命名空间，route 要明确 id 类型或来源，不要把裸 id 当成所有接口都可用的 id。
- 禁止用只能打开页面的占位对象替代真实领域数据，除非后续加载能证明会补齐目标页面依赖的 display model。

## Universal Link 规则

对外分享优先 Universal Link。检查：

- 域名稳定。
- path 能表达业务资源。
- 未安装时有网页兜底。
- App 安装后能冷启动直达目标。
- AASA、entitlements、Bundle ID、Team ID 匹配。

## Scheme 规则

Scheme 可用于：

- Widget。
- 调试。
- fallback 页面尝试打开 App。
- 历史兼容。

不要把 scheme 作为唯一公开分享链接。

## 测试矩阵

- App 未启动，点击 Universal Link。
- App 后台，点击 Universal Link。
- App 前台，收到 openURL。
- 同一个真实资源通过 App 内入口和 Universal Link 打开，关键 display model、权限状态和主操作一致。
- Widget 点击。
- Push 点击。
- 无效链接。
- 缺少 id。
- 旧版本链接。

## 检查清单

- 是否有统一 parser？
- 是否有统一 builder？
- builder 和 parser 是否 round-trip？
- 所有入口是否都转成 route？
- route 是否使用跨设备可解析 id？
- 外部入口是否与 App 内入口具备等价的资源身份和加载能力？
- 同一真实资源的关键 display model、权限状态和主操作是否一致？
- 未安装 fallback 是否存在？
- 冷启动和热启动是否都验证？
