# Arckit Code

Arckit Code 是飞天橙子的技术栈和平台级 coding skills 仓库，用来维护具体语言、框架、平台和 SDK 的编码实践。

当前仓库重点包含：

- `arckit-code-swiftui`：SwiftUI / Apple 客户端工程架构、状态模型、View/service/adapter 边界、平台能力和验证规则。
- `arckit-feedback-platform-integration`：反馈平台接入流程，包括 SDK WebView 和原生 API 两种方案。

如果你需要项目生命周期、产品定义、交互、视觉、技术方案、项目治理、项目记忆或通用 debug workflow，请安装 `arckit`。如果你需要具体技术栈或平台级 coding workflow，请安装 `arckit-code`。

## 推荐安装方式

推荐通过 [ArcForge](https://github.com/feitianchengzi/arcforge.git) 安装和治理 Arckit Code。

ArcForge 是飞天橙子的本地优先、GitHub 优先的 agent skill 治理工作台。它不替代 Codex、Claude、Cursor 等 agent 的运行时，也不是公共 marketplace；它负责让 agent 从 GitHub 或本地 Skill 项目中识别、审计、应用和检查 skills，而不是让用户手动复制目录。

如果你还没有安装 ArcForge，请先打开 ArcForge 仓库，并让 agent 执行：

```text
执行 skills/arcforge-install
```

ArcForge 安装完成后会进入推荐 Skill 项目阶段。此时可以让 agent 选择安装 `arckit-code`，或同时安装 `arckit` 和 `arckit-code`。

这样安装的原因是：

- `arckit-code` 仓库继续作为 GitHub-first 的 coding skills source of truth。
- Codex、Claude、Cursor 的用户级或项目级 skills 目录只是应用目标，不应该手动当成维护源。
- ArcForge 会先区分来源、维护源和应用目标，再由 agent 执行安装或同步，减少漏文件、旧文件残留和误覆盖。
- ArcForge 可以保存来源关系，后续用 drift 检查已安装副本是否偏离本仓库。
