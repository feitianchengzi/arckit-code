# Apple 系统能力边界

## 集成判断

接系统能力前先判断：

- SwiftUI 是否已有原生 API。
- SwiftUI 原生 API 是否能覆盖目标体验，而不只是“能做出类似画面”。
- 是否必须桥接 UIKit/AppKit。
- 是否需要 entitlements。
- 是否需要 Info.plist 权限文案。
- 是否需要 Developer 后台配置。
- 是否需要 App Group 或 Keychain Group。

## 隔离规则

系统能力隔离在：

- service。
- adapter。
- representable。
- coordinator。
- platform helper。

不要让业务 model 依赖 Apple UI 类型。不要让多个页面各自写系统桥接。

## 常见能力注意点

### PhotosPicker

- View 可持有 PhotosPicker 选择状态。
- 数据读取、压缩、上传交给媒体管线。
- 处理取消、读取失败、文件过大。

### Keychain

- 只存敏感凭据。
- 错误不能全部吞成 nil。
- 读取失败、未配置、系统失败要区分。

### WidgetKit

- 共享数据要小、稳定、可序列化。
- 图片路径需 Widget 可访问。
- 点击 URL 使用业务 id。

### 权限

- 在用户理解用途时请求。
- 拒绝后有降级路径。
- 权限文案和实际用途一致。

## UIKit/AppKit 使用准则

允许：

- SwiftUI 无替代。
- 系统 API 只能通过 UIKit/AppKit。
- 性能或手势能力 SwiftUI 无法满足。
- 平台控件已经内建关键物理行为，例如滚动惯性、缩放锚点、回弹、文本输入选择、系统面板交互。

要求：

- 封装清楚。
- 不扩散到业务层。
- 提供降级或失败处理。

不要为了“纯 SwiftUI”重写成熟平台控件的底层物理。SwiftUI first 的含义是页面、状态和组合方式优先 SwiftUI；不是禁止 `UIViewRepresentable` / `NSViewRepresentable`。

## 检查清单

- 是否优先评估 SwiftUI 原生方案？
- 桥接是否被隔离？
- 是否需要 entitlements？
- 权限文案是否齐全？
- 敏感数据是否进 Keychain？
- Widget/App Group 路径是否可访问？
- 系统失败是否有用户可理解状态？

## 决策机制

接入系统能力时先做三段判断：

1. SwiftUI 原生 API 能否覆盖？能覆盖则直接使用 SwiftUI。
2. 是否只是展示系统 UI？是则用局部 representable，不进入领域层。
3. 是否是长期业务能力？是则定义 protocol + adapter/service，View 只依赖稳定接口。

| 能力 | 首选 | 需要桥接时 |
| --- | --- | --- |
| 相册选择 | `PhotosPicker` | 复杂裁剪/旧系统兼容 |
| 分享 | SwiftUI `ShareLink` | 使用 `arckit-swiftui-share-media` 处理分享素材和预览 |
| Widget | WidgetKit | 不适用 |
| 通知 | UserNotifications service | 不适用 |
| Keychain | Keychain service | 不适用 |
| 图片查看缩放 | `MagnifyGesture` 仅适合简单缩放 | 系统相册级缩放/平移/惯性用 `UIScrollView` |
| 高级滚动/物理 | SwiftUI `ScrollView` | 需要 deceleration、zoom、contentOffset 精确控制时用 `UIScrollView` |
| 高级手势 | SwiftUI Gesture | UIKit recognizer adapter |

## 边界建模口径

- 权限状态不要压成简单 Bool；区分未请求、已授权、拒绝、受限、不可用和系统失败。
- 系统 adapter 返回稳定业务数据，例如 `Data`、`URL`、文件名、MIME type、业务 id 或领域枚举。
- SwiftUI/PhotosUI 边界类型可以停留在 View 或 adapter 边界；业务 service 不继续向下依赖平台 UI 类型。
- Keychain 错误要分类，至少区分未找到、重复写入、系统状态异常和数据格式错误。
- App Group 共享路径集中管理，主 App、Widget 和扩展使用同一套 group id 与业务 key。
- Bridge 只负责呈现或接入系统能力，不负责业务决策。

## 验证要求

- 权限：首次请求、拒绝、系统设置关闭、恢复授权。
- Bridge：多次打开/关闭不泄漏状态，系统失败能返回可处理状态。
- Keychain：未找到、重复写入、删除后读取、系统错误映射。
- App Group：主 App 写入，Widget 可独立读取。
- Info.plist/entitlements：代码用到的能力都有配置。
