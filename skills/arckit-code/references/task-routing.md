# 写代码任务路由

## 选择矩阵

| 用户问题 | 主任务 reference | 常见辅助 |
| --- | --- | --- |
| 页面太大、组件怎么拆、状态 UI 覆盖 | view-composition | state-dataflow, performance-quality |
| 状态混乱、业务逻辑放哪、Service 边界 | state-dataflow | local-data-lifecycle, networking-api |
| 接口、DTO、分页、上传下载、错误处理 | networking-api | state-dataflow, performance-quality |
| 本地数据、缓存、迁移、草稿、历史 | local-data-lifecycle | state-dataflow, media-pipeline |
| 图片/音视频、上传、fallback | media-pipeline | networking-api, performance-quality |
| 分享海报、二维码识别、ShareLink、系统级图片查看 | arckit-swiftui-share-media | system-integration, release-observability |
| 跳转、deeplink、外部入口、路由 round-trip | navigation-routing | system-integration, release-observability |
| 手势、拖拽、缩放、动画状态机 | interaction-motion | performance-quality, media-pipeline |
| 系统 API、权限、平台 bridge | system-integration | release-observability, media-pipeline |
| 卡顿、掉帧、重计算、回归 | performance-quality | state-dataflow, interaction-motion |
| 发布配置代码、隐私声明文件、日志、埋点、崩溃上下文 | release-observability | system-integration, performance-quality |
| AI 生成、prompt、stream、schema、质量门 | ai-generation | networking-api, local-data-lifecycle |

## 读取规则

- 普通任务读取 1 个主任务规则和 1 个技术栈 overlay。
- 复合任务最多先读 2 个主任务规则；确认根因后再扩展。
- 强流程代码任务优先使用独立正向 skill，例如 SwiftUI 工程底座、Apple 系统能力、Apple 发布配置和分享媒体体验。
- 项目已有明确架构时，项目事实优先于通用 reference。
