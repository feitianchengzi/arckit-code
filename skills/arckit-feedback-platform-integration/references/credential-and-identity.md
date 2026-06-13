# 凭证与用户身份策略

## 凭证策略

`apiKey` 是项目 API Key，用于识别接入方和项目访问权限。生产推荐按 secret 处理；用户明确允许客户端源码配置时，可以放进专用配置文件，但最终回复和日志仍不得输出完整 key。

- `source-static`: 使用脚本生成的 Swift 静态配置或等价专用配置文件。记录“用户已接受客户端源码配置风险”。不要把“缺后端运行时接口”列为阻塞，只列为生产安全升级建议。
- `local-ignored`: 确认本地配置路径被 git ignore 后再接入本地 provider。建议生成 `.example`，但不要提交真实 key。
- `secret-store`: 使用 secret handle 或项目可用的读取机制接入。不要读取、迁移或打印明文，除非用户明确要求迁移到源码静态配置并重新确认风险。
- `backend-runtime`: 不采集客户端 API Key。接入后端运行时配置接口、服务端代理或短期会话参数；如果暂时没有后端接口，保持“运行时凭证未接入”状态。

## 参数边界

必需参数：

- `projectId`: 数字型项目 ID，本身不是密钥。
- `apiKey`: 项目 API Key，按所选凭证策略处理。
- `customUserId`: App 内用户反馈归属 ID，不是平台登录 token。

agent 允许接触参数名、配置 key、环境变量名、secret handle、占位符、示例值、`projectId`、API Key 存在状态和注入方式。用户明确选择 `source-static` 时，允许为写入专用配置文件接触真实 key，但不要在日志、命令输出或最终回复中复述完整 key。

默认禁止接触或输出真实 API Key、包含真实 key 的截图/日志/diff，以及可反推出用户身份的 `customUserId` 明文样本。

## customUserId

- 有登录体系：传业务用户 ID，避免手机号、邮箱、昵称等可识别信息。
- 无登录体系：生成设备级游客 ID，持久化到 Keychain、SharedPreferences、localStorage 或同等持久存储，避免“我的反馈”断档。
- 退出登录、切换账号、游客升级登录时，必须明确反馈归属策略。
