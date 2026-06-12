# SwiftUI 分享媒体规则

## 分享 payload

分享能力先拆 payload：

- 文字：完整邀请语、简介、链接。
- URL：公开可打开链接或 Universal Link。
- 图片文件：海报、封面、二维码图、本地缓存图。
- 预览：标题、缩略图、App 标识。
- fallback：图片生成失败、链接缺失、目标 App 不支持 metadata。

`ShareLink` 的 `item` 是核心 payload。`subject`、`message`、`preview` 是辅助表达，只有目标系统会使用时才传。

## 分享海报

分享海报是传播素材，不是普通截图。海报应能脱离 App 独立表达：

- 内容名称。
- 简介或核心价值。
- App 名称或 App icon。
- 二维码或打开入口。
- 可识别的视觉层级。

生成图片时显式设置：

- 输出逻辑尺寸。
- 实际像素尺寸。
- renderer scale。
- JPEG/PNG 格式。
- 压缩质量。
- 文件体积预算。

不要依赖设备默认 scale 隐式决定最终像素。`UIGraphicsImageRenderer` 默认受设备 scale 影响，分享图应显式设置 scale，避免体积暴涨或二维码实际像素不足。

## 二维码识别

二维码识别按最终导出文件验证，而不是按 SwiftUI 视图视觉尺寸验证。

检查项：

- 二维码实际像素宽高。
- 白底 quiet zone。
- 前景/背景对比度。
- JPEG 压缩是否破坏边缘。
- 海报缩放和社交 App 二次压缩后的识别效果。

常规 iPhone 分享海报若需要微信长按识别二维码，3:4 海报可参考 `1440x1920 @ scale 1`。二维码区域建议至少约 `180px` 实际像素宽高，并保留清晰白底 quiet zone。

分享图体积需要预算。面向微信分享海报，约 `300KB-500KB` 通常比过度压缩到一百多 KB 更稳。

## ShareLink 使用规则

分享入口统一使用 SwiftUI `ShareLink`：

- 以 `item` 作为核心 payload，优先传 URL、文本或本地图片文件。
- `subject`、`message`、`preview` 只传目标系统可能使用的辅助信息。
- 目标 App 不支持 metadata、预览或特定 payload 时，调整标准 payload 或提供内容 fallback。

## 图片查看器 bridge

需要系统相册级缩放、平移、惯性和回弹时，优先使用 `UIScrollView` bridge。

要求：

- 封装在 `UIViewRepresentable` 内。
- 外层只传 SwiftUI content、reset id、zoom 状态回调。
- `UIScrollViewDelegate` 和 UIKit 类型不进入业务 model/service。
- 切换图片时重置 zoom scale 和 content offset。
- 缩放态通知外层禁用页面翻页或关闭冲突手势。

## Widget 和 App Group 图片

分享或 Widget 图片需要目标进程可访问：

- 使用 App Group container。
- 控制缓存图大小。
- 文件命名和失效策略稳定。
- 主 App 更新素材后能刷新 snapshot 或 metadata。

## 验证要求

- 系统分享预览显示正确标题、图片和链接。
- 目标社交 App 接收的 payload 符合预期。
- 二维码在最终导出图片中可识别。
- 分享图片文件体积在预算内。
- 冷启动和热启动打开链接路径可用。
- 图片查看器缩放、平移、切图、边界回弹和手势互斥可用。
