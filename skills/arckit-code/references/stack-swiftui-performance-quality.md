# SwiftUI Performance Quality Overlay

- View body 不做排序、过滤、JSON decode、DateFormatter 创建、文件 IO 和同步图片处理。
- 长列表行保持轻量，图片尺寸、解码和缓存受控。
- Observable 粒度避免小状态刷新整页或长列表。
- `.task(id:)`、网络请求和图片加载使用取消、去重和并发边界。
- 动画或手势每帧状态局部化，结束后再提交业务状态。
- 需要 Instruments 时关注 SwiftUI body 重算、Main Thread、Time Profiler、Allocations。
