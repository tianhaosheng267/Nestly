# 免费公寓搜索与 Gmail

## 运行与使用

运行 `ruby bin/rails db:prepare`，然后 `start.cmd`。登录后输入美国 ZIP code，选择 5/10/25/50/100 miles，搜索结果自动导入 Apartments。可以查看详情、收藏和进入 Swipe；My Properties 仍支持手动创建。Swipe 混合展示两种来源，租金/卧室筛选只用于手动房源。

搜索无需 API Key、Google Maps 计费或 AI 账户。ZIP 中心来自 Zippopotam.us，公寓数据来自 OpenStreetMap/Overpass。距离为 ZIP 中心的直线距离，不是驾车距离。默认公共服务 `https://overpass.private.coffee/api/interpreter` 可通过 `OVERPASS_API_URL` 替换。

公共数据不能保证覆盖所有社区，可能只有建筑名、缺少地址/邮箱/照片；不会生成虚假的价格或空房信息。每次最多处理 201 条地图记录并展示最多 200 条去重结果，达到上限会提示缩小范围。大范围结果不保证是距离最近的 200 个。相同 ZIP/范围缓存 24 小时；公共端点繁忙时可能需要约一分钟或失败。失败保留上次结果。正式公开服务应换成有容量保障的提供商或自建 Overpass，不能把公共端点当作稳定生产服务。

## 配置 Gmail

当前搜索已经独立可用。Gmail 需要应用自己的 Google OAuth 配置，安装个人 Gmail 插件不能替代网站的 OAuth。

1. 在 Google Cloud 创建项目并启用 Gmail API。
2. 配置 Google Auth Platform 的应用信息、受众和测试用户，把自己的 Gmail 添加为测试用户。
3. 添加权限 `https://www.googleapis.com/auth/gmail.readonly` 和 `https://www.googleapis.com/auth/gmail.send`。
4. 创建 Web application 类型的 OAuth 客户端，允许的重定向 URI 填 `http://127.0.0.1:3000/gmail/callback`。浏览器始终使用同一主机地址；不要混用 localhost 与 127.0.0.1。
5. 在启动 Rails 的同一个 PowerShell 窗口设置下面三个环境变量，再运行 `start.cmd`。不要把真实密钥发进聊天、写进源码或提交到 Git。

```powershell
$env:GOOGLE_OAUTH_CLIENT_ID = "你的客户端 ID"
$env:GOOGLE_OAUTH_CLIENT_SECRET = "你的客户端密钥"
$env:GOOGLE_OAUTH_REDIRECT_URI = "http://127.0.0.1:3000/gmail/callback"
.\start.cmd
```

这三个变量不会自动从 `.env` 文件读取。关闭该 PowerShell 后，需要重新设置。配置后从 Inbox 点击 Connect Gmail，用户自行完成 Google 授权。

从公寓详情点击 Contact by email，核对或手动填入官方联系邮箱，创建会话后点击 Send email 才会发送。Nestly 只列出从这里创建的会话；打开或刷新会话时查询 Gmail 回复，没有实时推送，也没有附件功能。联系邮箱缺失时请从公寓官网确认，系统不会猜测。

OAuth 使用 state、PKCE 和过期校验；访问令牌和刷新令牌在数据库中加密。生产部署必须配置稳定、私密的 `SECRET_KEY_BASE`，否则更换密钥后原令牌不能解密，需要重新连接。邮件正文以转义文本显示。发送请求有重复提交保护；遇到超时且发送状态不明确时，请先检查 Gmail 已发送邮件再重试。断开连接删除本地会话关联，Gmail 原始邮件保留。

测试模式的 Google 授权可能需要定期重新连接。正式向公众开放前需完成 Google 要求的 OAuth 验证、隐私政策与可能的安全评估；本次尚未用真实账号验证 Gmail 收发。

## 参考

- [Overpass 公共实例与使用限制](https://wiki.openstreetmap.org/wiki/Overpass_API)
- [OpenStreetMap 数据许可](https://www.openstreetmap.org/copyright)
- [Google Gmail OAuth 配置](https://developers.google.com/workspace/gmail/api/quickstart/ruby)
- [Gmail 权限说明](https://developers.google.com/workspace/gmail/api/auth/scopes)
