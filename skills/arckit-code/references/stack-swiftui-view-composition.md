# SwiftUI View Composition Overlay

- 一个文件默认只放一个主 View 和紧邻的 preview/辅助小类型。
- 子 View 接收 display model、简单值、binding 和闭包。
- 页面级 View 协调 `@Query`、service、navigation 和 async task。
- 稳定颜色、字体、间距、圆角接入项目 DesignTokens。
- Preview 覆盖 loading、empty、error、success、长文本、Dynamic Type 和权限态。
- 平台控件 bridge 的公开输入输出保持 SwiftUI/领域中立。
