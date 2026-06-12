# SwiftUI Navigation Routing Overlay

- 内部导航优先使用项目既有 `NavigationStack` / `NavigationPath` / router。
- Route 使用稳定 enum/struct，外部入口转换为 Route。
- deeplink、Universal Link、Widget、Push 和分享入口进入统一 parser。
- modal、sheet、fullScreenCover 与 push 路由分别建模。
- route 只携带稳定 id 和必要上下文，不传大对象。
- 解析和生成需要 round-trip 测试或等价样本。
