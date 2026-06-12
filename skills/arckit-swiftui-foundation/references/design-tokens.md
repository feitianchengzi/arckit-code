# 设计系统入口参考

> 设置设计系统、处理颜色/字体/间距时加载此文件。目标是让稳定视觉值有统一入口，并跟随项目已有设计系统。

## 判断顺序

1. 项目已有 DesignTokens、Theme、SwiftGen、R.swift、Asset Catalog 约定或品牌 SDK 时，沿用现有方案。
2. 新项目没有设计系统时，建立最小语义化入口，先覆盖颜色、字体、间距和圆角。
3. 需要深浅色或高对比度时，优先让 Asset Catalog 或系统动态颜色承载 appearance 差异。
4. 只有一次性、局部且不稳定的视觉值可以留在局部；可复用或品牌相关值进入设计系统入口。

## 核心规则

- 颜色按语义命名，例如 `primary`、`surface`、`textPrimary`、`error`。
- 稳定颜色优先来自 Asset Catalog、系统动态颜色或项目现有资源生成工具。
- 字体、间距、圆角使用统一命名入口，避免页面内大量散落 magic number。
- token 只表达视觉决策，不承载业务逻辑。
- 新增 token 前先确认是否已有等价语义，避免同义 token 膨胀。

## 最小示例

```swift
enum DesignTokens {
    enum Colors {
        static let primary = Color("Primary")
        static let surface = Color("Surface")
        static let textPrimary = Color("TextPrimary")
    }

    enum Spacing {
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }
}
```

示例只说明入口形态。真实项目的命名、bundle、资源生成工具和 token 分层以项目事实为准；只有资源位于独立 package/module 时才显式指定 bundle。

## 检查清单

- 语义颜色有深浅色策略。
- 页面中没有大量重复硬编码视觉值。
- token 命名能表达用途，而不是表达当前色值。
- 新组件优先使用项目设计系统入口。
- 本次改动没有为了套 token 重写无关 UI。
