---
name: arckit-swiftui-media-pipeline
description: SwiftUI 图片、音频、视频媒体管线 skill。用于远程图片加载、缓存、占位、失败、重试、fallback URL、图片查看器、双指缩放、以触点为中心缩放、系统相册级缩放/平移/惯性/回弹、上传前压缩、头像上传、分享封面、分享海报、二维码识别、微信长按识别、Widget 图片、基础音频/视频播放。用户提到图片加载失败、图片重试、缓存、头像、上传、缩放、查看大图、封面、海报图、二维码识别失败、微信识别不到二维码、音频播放、视频播放、媒体资源时使用。
---

# ArcKit SwiftUI Media Pipeline

## 目标

把图片、封面、头像、上传、查看器、Widget/分享媒体做成稳定管线。Agent 执行时不要只把图片显示出来，而要处理加载状态、失败重试、缓存、fallback、内存、上传前处理和手势边界。

## 执行流程

1. 先分类媒体场景：列表缩略图、详情大图、头像、上传、分享封面、Widget 图片、图片查看器、基础音频/视频。
2. 查找项目是否已有统一图片组件、缓存、上传 payload、查看器；已有时优先修补统一入口。
3. 定义媒体状态：无资源、loading、success、failure、fallback success、retrying。
4. 定义媒体资源 identity：原始 URL、fallback URL、本地文件、缓存 key、缩略图和大图之间的关系要稳定。
5. 建立或复用缓存策略：内存、URLCache/磁盘、App Group 文件缓存；分享/Widget 优先读取可访问缓存，并有失效或刷新边界。
6. 对远程图片补 fallback URL、失败占位、用户重试或自动重试边界；fallback 成功不应阻断后续更高质量资源补全。
7. 对上传补格式识别、方向处理、尺寸限制、大小限制、压缩质量回退，输出稳定 payload。
8. 对图片查看器处理缩放、平移、最小/最大比例、触点/双指中心锚点、缩放态和翻页/滚动互斥；需要系统相册级缩放、平移、惯性、回弹时优先使用 `UIScrollView` bridge，而不是 SwiftUI 手势复刻。
9. 检查滚动列表、大图解码和内存峰值；必要时配合 performance skill。

## 读取资源

- 图片加载、缓存、失败/重试、fallback、上传压缩、Widget/分享封面：`references/media-pipeline-rules.md`
- 缩放、翻页、拖拽互斥：`arckit-swiftui-interaction-motion`
- 上传接口和网络错误：`arckit-swiftui-networking-api`
- 相册、ShareSheet、Widget/App Group：`arckit-swiftui-system-integration`
- 图片内存和列表滚动：`arckit-swiftui-performance-quality`

## 核心规则

| 场景 | 执行要求 |
| --- | --- |
| 远程图片 | 不散落 `AsyncImage`，优先统一组件 |
| 加载失败 | 有占位、fallback 或重试，不长期空白 |
| 资源身份 | cache key、fallback、缩略图、大图关系稳定，补全后能刷新 |
| 上传 | 网络层只接收 `Data/URL/fileName/mimeType` |
| 分享/Widget | 图片路径必须目标进程可访问 |
| 查看大图 | 系统级体验优先平台控件桥接；缩放以触点/双指中心为锚点 |
| 滚动列表 | 控制解码、尺寸、缓存和并发 |

## 分享海报素材

当图片用于社交分享和 App 转化时，它是传播素材，不是普通截图。

- 分享海报应能脱离 App 独立表达：内容名称、简介、App 名称/App icon、二维码或打开入口都要可读。
- 明确输出尺寸、scale 和压缩格式。`UIGraphicsImageRenderer` 默认会受设备 scale 影响，生成分享图时应显式设置 scale，避免 @3x 体积暴涨。
- 微信长按识别二维码时，不能只看海报视觉尺寸；要检查最终导出的实际像素、二维码实际像素尺寸、二维码留白区和 JPEG 压缩质量。低分辨率海报或过小二维码会导致微信识别不到二维码，甚至命中其他入口。
- 常规 iPhone 分享海报若需要微信识别二维码，优先使用中高质量实际输出：3:4 海报可参考 `1440x1920 @ scale 1`，二维码区域建议至少约 `180px` 实际像素宽高，并保留清晰白底 quiet zone。
- 如果设计稿使用较小逻辑尺寸，可以用固定 `scale = 1` 和更大的输出画布等比放大绘制；不要只把控件画小再依赖系统缩放。
- 海报类图片通常优先用 JPEG 控制体积；只有透明或强无损需求时才优先 PNG。
- 分享图体积要有预算，避免让系统分享和社交 App 处理大图时卡顿或失败；面向微信分享海报，约 `300KB-500KB` 通常比过度压缩到一百多 KB 更稳。
- 系统分享预览图和实际分享 payload 可以分开设计，但两者都应使用标准图片类型并有 fallback。

## 最低交付标准

- 媒体状态覆盖 loading/success/failure/retry/empty。
- 图片失败可解释、可恢复，或有合理 fallback。
- 缓存策略服务列表、详情、分享、Widget 中至少一个真实场景，并定义资源更新或失效路径。
- 上传前处理尺寸、格式、大小，且不让 UI 类型进入网络层。
- 图片查看器缩放、平移、翻页互斥路径明确；若使用平台控件桥接，UIKit/AppKit 类型不扩散到业务层。

## 降级/停止条件

- 静态 asset、图标、小装饰图不建立媒体管线。
- 已有统一媒体组件的小样式调整，只改组件内相关参数。
- 复杂音频引擎、录音、低延迟播放多次出现后再拆专门音频 skill；本 skill 只覆盖基础播放。
