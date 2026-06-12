# System Integration 任务规则

## 目标

把平台系统能力接入应用，同时保持业务层、平台层和发布配置边界清楚。

## 决策规则

- 先判断原生框架能力是否覆盖真实体验。
- 平台 bridge 隔离在 adapter、representable、service 或 integration 层。
- 系统返回结果转成稳定业务数据。
- 权限请求时机、拒绝降级、配置文件和发布能力同步定义。
- 可测试逻辑使用 protocol/fake，系统弹窗和权限状态给手测路径。

## 反模式

- 平台 controller、view、image 类型扩散到领域层。
- 只改代码，不同步权限文案、entitlements 或后台配置。
- 在普通业务 service 中混入 delegate 和系统生命周期细节。

## 验证

覆盖首次授权、拒绝、受限、撤销权限、系统失败、扩展进程和发布配置清单。
