---
name: arckit-swiftui-share-media
description: SwiftUI 分享素材与平台媒体体验 skill。用于 ShareLink、LinkPresentation、分享预览、分享海报、二维码识别、微信长按识别、分享图像素/压缩质量、系统相册级图片查看器、UIScrollView bridge、Widget/App Group 分享图片素材。用户提到分享图片、海报、二维码识别不到、微信识别、系统分享、分享预览、大图查看、相册级缩放、图片查看器惯性/回弹时使用。
---

# ArcKit SwiftUI Share Media

## 目标

把分享相关媒体体验做成可传播、可识别、可预览、可验证的 SwiftUI/Apple 平台能力。Agent 执行时不要只生成一张图，而要同时处理分享 payload、预览、图片像素、压缩质量、二维码识别、目标 App 限制和平台 bridge 边界。

## 执行流程

1. 明确分享目标：分享链接、分享图片、分享海报、邀请文案、二维码识别、图片查看器或 Widget/扩展图片素材。
2. 选择系统能力：分享入口统一使用 SwiftUI `ShareLink`。
3. 定义分享 payload：文字、URL、本地图片文件、metadata、预览图和 fallback 分开建模。
4. 生成分享图片时明确输出尺寸、scale、格式、压缩质量、文件体积和目标平台识别要求。
5. 涉及二维码时检查实际像素、quiet zone、对比度、压缩损伤和最终分享文件。
6. 涉及系统级图片查看器时优先 `UIScrollView` bridge，隔离 delegate 和 UIKit 类型。
7. 涉及 Widget/App Group 图片时确认文件路径可被目标进程读取，并定义失效和刷新边界。
8. 用真实目标验证：系统分享预览、微信/社交 App 识别、二维码长按、冷启动打开、图片查看缩放和边界手势。

## 读取资源

- 分享 payload、海报、二维码、ShareLink、图片查看器 bridge：`references/share-media-rules.md`
- PhotosPicker、App Group、权限、系统能力配置：`arckit-swiftui-system-integration`
- Apple 发布配置、Associated Domains、AASA、Privacy Manifest：`arckit-swiftui-release-observability`

## 核心规则

| 场景 | 执行要求 |
| --- | --- |
| ShareLink | 分享入口只使用标准 `ShareLink`，subject/message/preview 只传有用信息 |
| 分享海报 | 离开 App 后仍能表达内容、App 和打开入口 |
| 二维码 | 检查最终实际像素、quiet zone、压缩质量 |
| 分享预览 | 标题、图片、App 标识真实可读 |
| 图片查看器 | 系统级缩放/惯性/回弹优先 UIScrollView bridge |
| Widget/App Group 图片 | 文件路径目标进程可访问，大小受控 |

## 最低交付标准

- 分享 payload、预览和 fallback 明确。
- 分享图输出尺寸、格式、scale、压缩质量和体积预算明确。
- 二维码类素材通过最终导出图片验证识别条件。
- 分享入口统一使用 SwiftUI `ShareLink`；图片查看器 bridge 时 UIKit/AppKit 类型不扩散到业务层。
- 系统分享、目标社交 App、冷启动/热启动打开路径有验证方式。

## 降级/停止条件

- 普通远程图片加载、缓存、fallback、上传 payload 和列表图片性能使用 `arckit-code` 的 media task，不使用本 skill。
- PhotosPicker、Keychain、App Group capability、权限配置本身使用 `arckit-swiftui-system-integration`。
- 发布、AASA、Associated Domains、隐私声明和 TestFlight 验证使用 `arckit-swiftui-release-observability`。
