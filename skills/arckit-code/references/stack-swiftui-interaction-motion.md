# SwiftUI Interaction Motion Overlay

- `DragGesture`、pinch、tap、long press 和 scroll 先定义优先级和互斥关系。
- 拖拽 offset、缩放比例、方向锁等过程状态使用局部 `@State` 或 gesture state。
- 页码、选择、排序等业务状态在手势结束后提交。
- 每帧更新禁用不必要隐式动画，收尾使用明确 `withAnimation` 或 `Transaction`。
- 系统级滚动/缩放/输入体验优先 `UIScrollView` / 平台控件 bridge。
- 缩放态禁用或降级翻页，避免手势互抢。
