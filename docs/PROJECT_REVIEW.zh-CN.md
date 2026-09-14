# Nestly 项目阅读记录

本次目标是理解已有项目并恢复 Windows 本地开发环境。已阅读应用控制器、模型、视图、样式、JavaScript、路由、初始化配置、数据库 schema / migrations / seeds、测试以及启动和部署脚本。加密 credentials 未解密；图片作为资源文件识别，运行日志和缓存不作为业务源代码。没有修改业务实现或原有测试。

## 产品和架构

Nestly 是面向找房者和房源发布者的租房平台。Rails MVC 单体架构使用 ERB 服务端渲染、SQLite 持久化、Propshaft 资源管理、Importmap 加载 JavaScript、Turbo / Stimulus 提供交互，Bootstrap 5.0.2 通过 CDN 引入。

| 模块 | 实现与关系 |
| --- | --- |
| 用户 | Devise 注册、登录、记住登录、密码恢复；name 必填 |
| 房源 | Property 通过 landlord_id 关联 User；地址、租金、卧室、浴室、面积、宠物、设施、可入住日期 |
| 图片 | Active Storage 多图上传；Stimulus 本地预览、删除待上传图片和主图选择 |
| 浏览与收藏 | Swipe 保存 like / pass；用户与房源组合唯一；收藏可以置顶，筛选偏好存入 session |
| 预约 | TourRequest 关联用户和房源；pending → approved / denied，approved 在预约时间后可以变为 completed / incomplete |
| 消息 | Message 关联发送者、接收者和房源；按“房源 + 对方用户”聚合会话 |
| 邮件 | 开发环境使用 letter_opener_web；无需发送实际邮件即可查看密码重置内容 |

当前没有固定的 renter / landlord 角色字段；用户拥有房源时承担对应房东身份。消息通过 HTTP 提交并跳转更新，不能称为已实现实时聊天。虽然依赖包含 Solid Cable / Queue / Cache，实际开发配置使用 async cable、内存缓存，业务中没有自定义实时推送通道。

`Picture` 表和模型仍存在，但房源图片实际使用 Active Storage。`users.password_digest` 也是历史遗留字段，当前认证使用 Devise 的 encrypted_password。

## 迁移结果

本机已安装 Ruby 3.3.12、Bundler 4.0.15、Rails 8.1.3 和锁文件内依赖，MSYS2 编译工具、SQLite CLI 与 libvips 也已安装。开发库完整且迁移已全部应用，基础页面和图片处理验证通过。细节见 `WINDOWS_SETUP.zh-CN.md`。

## 实习展示前优先处理

1. **房源写操作授权缺口。** `PropertiesController` 的 owner 回调仅覆盖 edit / destroy，没有覆盖 update / delete_image。仅隐藏页面按钮不能限制直接发送请求；应统一对房源修改与删除图片验证所有权，并补权限测试。
2. **测试与数据模型不一致。** Minitest fixtures 和 RSpec setup 仍含 `role`，导致 15 项报错及 13 项失败；消息测试还引用未定义的 `users(:three)`。需要更新为有效、相互关联的测试数据，并覆盖当前业务规则。
3. **种子脚本不可重复执行。** 每次新增 10 个房源，之后遍历全部房源并按序读取仅 10 张图片；还会修改已有示例账号密码。应改为幂等的演示数据创建流程。
4. **异常输入处理。** update 对 `property_params[:images]` 直接调用 empty?，缺少该参数会报错；is_owner 对不存在的房源直接访问 landlord；预约 create 对不存在的房源直接访问 landlord。应返回明确的错误或 404。
5. **后端约束不完整。** ZIP 正则未锚定整个字符串；上传数量和类型主要由前端限制；消息 2000 字符限制仅在页面上。服务端也需要对应校验。
6. **展示一致性。** 滑动页使用第一张图片而非 main_image，和主图选择文案不一致；滑动页顶层 `let galleryIndex` 应检查 Turbo 重复导航行为；移动端布局需要实际浏览器验收。
7. **生产配置未完成。** Kamal IP、镜像和邮件 host 是占位值，credentials 解密密钥未随目录携带。Dockerfile 是 Linux 生产镜像，尚未验证构建或部署。

以上按代码阅读和本地验证记录，不代表已完成全面安全审计或端到端测试。当前适合继续本地开发；准备公开演示时应先修复授权和测试问题，再补演示数据、截图、部署和清晰的个人贡献说明。

## 简历表述应基于实际贡献

目前可客观描述的技术点包括 Rails MVC、Devise 认证、Active Record 关联与查询、SQLite、Active Storage 多图管理、Stimulus 图片预览、房源筛选收藏、预约状态管理、按房源组织的用户消息。团队项目应明确自己负责的模块，避免将全部功能都写成个人独立实现；没有测量之前不要添加用户量、性能提升或覆盖率数字。
