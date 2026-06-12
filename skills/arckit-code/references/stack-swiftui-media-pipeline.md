# SwiftUI Media Pipeline Overlay

- 不在页面散落 `AsyncImage`，优先统一远程图片组件或 loader。
- 图片状态至少表达 loading、success、failure、fallback、retrying。
- 图片缓存、fallback URL、缩略图和原图身份关系稳定。
- 上传前把平台图片转换为 `Data`/`URL`/mime type/filename。
- 头像、证件照或用户原图上传前按项目隐私策略处理 EXIF/位置元数据和方向。
- 普通 SwiftUI 图片组件不直接承载分享海报、二维码识别或系统相册级缩放体验；这些进入 `arckit-swiftui-share-media`。
