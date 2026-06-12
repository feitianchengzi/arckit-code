# SwiftUI Local Data Lifecycle Overlay

- 结构化持久数据优先沿用 SwiftData 或项目当前存储。
- 简单偏好使用 UserDefaults/AppStorage，敏感凭据使用 Keychain。
- Widget/扩展共享数据放入 App Group container。
- 缓存大文件和图片使用 FileManager/URLCache 或项目缓存 actor。
- SwiftData schema 变化需要迁移或读取兼容路径。
- `@Query` 只作为 View 查询入口，复杂合并和修复逻辑下沉到 service/store。
- 离线同步队列、冲突合并和后台刷新不要写在 View 或 `@Query` 派生逻辑中，优先放入 store/service/actor。
