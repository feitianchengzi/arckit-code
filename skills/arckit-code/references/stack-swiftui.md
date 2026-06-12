# SwiftUI 技术栈入口

## 基线

- SwiftUI first, not SwiftUI only。
- 使用 Swift Concurrency，UI 状态更新保持 MainActor 语义。
- 状态优先局部化，复杂关联状态再抽 observable。
- 平台控件在 SwiftUI 不覆盖或复刻会损害体验时使用 bridge。
- UIKit/AppKit bridge 隔离在 adapter、representable、service 或 integration 层。
- Xcode project/workspace、最低系统版本、entitlements 和 Info.plist 属于工程事实；业务代码是否需要独立 package/framework 由项目事实决定。

## 任务 overlay

| 任务 | 读取 |
| --- | --- |
| 状态数据流 | `stack-swiftui-state-dataflow.md` |
| 页面组织 | `stack-swiftui-view-composition.md` |
| 网络 API | `stack-swiftui-networking-api.md` |
| 本地数据 | `stack-swiftui-local-data-lifecycle.md` |
| 路由导航 | `stack-swiftui-navigation-routing.md` |
| 手势动画 | `stack-swiftui-interaction-motion.md` |
| 媒体管线 | `stack-swiftui-media-pipeline.md` |
| 性能质量 | `stack-swiftui-performance-quality.md` |
| AI 生成 | `stack-swiftui-ai-generation.md` |

## 专项 skill

- 新建或整理 SwiftUI 工程：`arckit-swiftui-foundation`
- 分享海报、二维码、ShareLink、系统级图片查看：`arckit-swiftui-share-media`
- Apple 系统能力、权限、平台 bridge：`arckit-swiftui-system-integration`
- Apple 发布配置、隐私声明、TestFlight 和观测代码：`arckit-swiftui-release-observability`
