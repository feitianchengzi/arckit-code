# SDK WebView 模式

使用条件：参数 UI 或等价配置返回 `integrationMode=sdk-webview`。

## 页面与桥接

WebView 加载：

```text
https://feedback.feitianchengzi.com/sdk
```

页面加载完成后注入配置：

```javascript
window.FeedbackSDK.configure({
  apiKey: credentialProvider.apiKey,
  projectId: credentialProvider.projectId,
  customUserId: runtimeUserId()
});
```

打开提交反馈：

```javascript
window.FeedbackSDK.openSubmit();
```

打开“我的反馈”：

```javascript
window.FeedbackSDK.openStatus();
```

## 实现要求

- `configure` 只在页面可用后调用。
- JavaScript 注入不得打印完整配置对象。
- WebView 错误日志不得包含 API Key。
- 提交反馈和“我的反馈”可以是两个入口，也可以是同一反馈中心内的两个 action，但必须分别触发 `openSubmit()` 和 `openStatus()`。
- 如果选择 `backend-runtime` 但运行时凭证未接入，不要尝试打开 SDK；页面显示“运行时凭证未接入”。
