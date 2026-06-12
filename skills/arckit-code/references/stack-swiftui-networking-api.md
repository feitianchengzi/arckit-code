# SwiftUI Networking API Overlay

- 底层优先使用项目现有 URLSession/APIClient 抽象。
- API service 使用 async/await，支持取消和超时。
- DTO 到领域模型映射放在 service 或 mapper，不在 View。
- 错误映射形成 enum 或稳定错误类型，再由 UI 层映射展示。
- token refresh 使用 single-flight，避免并发刷新覆盖。
- 网络日志脱敏，不记录 token、密钥和完整敏感 payload。
