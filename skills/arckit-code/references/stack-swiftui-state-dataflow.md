# SwiftUI State Dataflow Overlay

- 简单局部 UI 状态使用 `@State`。
- 父子编辑使用 `@Binding`，避免把整个父级状态对象传入子 View。
- 持久化查询使用项目既有 SwiftData / `@Query` 模式。
- 关联业务状态使用 Observation / `@Observable`，不要为单个控件状态引入。
- Service 通过 Environment 或项目既有依赖注入方式进入 View。
- Service API 不泄漏 `UIImage`、`UIViewController`、`Color`、`View` 等 UI 类型；bridge 可在 representable 内部持有平台类型。
- View body 不触发网络、文件 IO、Keychain、重型解析或系统 bridge。
