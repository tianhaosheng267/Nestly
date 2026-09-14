# Windows 环境与启动说明

检查日期：2026-09-13（美国东部时间）。项目路径：`C:\Users\a1391\Desktop\Nestly`。

## 已安装

| 组件 | 本机版本 / 位置 | 用途 |
| --- | --- | --- |
| RubyInstaller + Devkit | Ruby 3.3.12，`C:\Ruby33-x64` | Ruby 运行时、MSYS2、GCC 编译工具 |
| Bundler | 4.0.15 | 按锁文件管理依赖 |
| Rails | 8.1.3 | Web 框架 |
| 项目 gems | 28 个直接依赖，140 个已安装 gems | 包含 Devise、Puma、SQLite、Hotwire、RSpec 等 |
| SQLite Ruby gem | 2.9.5 | 数据库连接；另已安装 SQLite 命令行程序 |
| libvips | 8.18.4 | Active Storage 图片处理 |
| 图片扩展 | HEIF、JPEG XL、ImageMagick、OpenSlide、Poppler 依赖 | 补齐 libvips 动态模块 |
| Git | 电脑原有安装 | 版本管理 |

Ruby 已加入用户 PATH。安装前打开的 PowerShell、VS Code 终端需要重新打开；如果仍找不到 Ruby，重启对应应用。

原 `.ruby-version` 和 Dockerfile 的 3.3.3 未改动；Windows 安装同一系列的维护版本 3.3.12。没有升级项目锁定的 gem 版本。

## 日常启动

```powershell
cd C:\Users\a1391\Desktop\Nestly
.\start.cmd
```

浏览器访问 `http://127.0.0.1:3000`。按 Ctrl+C 停止。脚本只启动服务，不重建数据库、不重置密码、不自动生成数据。

常用命令：

```powershell
ruby -v
bundle --version
bundle check
ruby bin/rails about
ruby bin/rails db:migrate:status
ruby bin/rails console
ruby bin/rails zeitwerk:check
```

Windows 下用 `ruby bin/rails ...`，原来的无扩展名 Unix `bin/dev`、`bin/setup` 不直接作为 Windows 命令使用。

SQLite 命令行可通过 `ridk exec sqlite3 storage/development.sqlite3` 使用。`ruby-vips` 能通过 RubyInstaller 加载已安装的 MSYS2 库。

## 数据保留

原开发数据库检查通过：1 个用户，0 个房源、收藏、预约、消息和 Active Storage 图片记录，17 个迁移全部已执行。原用户密码没有修改。

初始备份：`tmp/windows-migration-backup-20260913-204618/storage/development.sqlite3`。该目录也保存了原始 `Gemfile.lock`。备份位于被 Git 忽略的 `tmp` 下，运行清理 tmp 的命令前请另行保存备份。

没有对开发库执行 `db:reset`、`db:drop` 或 `db:seed`。不要直接重复执行当前种子脚本：它会新增房源、重设示例账号密码，并在房源多于 10 个时尝试读取不存在的图片文件。现有页面暂无房源是数据为空，并非环境错误。可以通过注册和 My Properties → Add property listing 自己创建演示内容。

## 已做验证

- `bundle check`：依赖完整。
- `rails about` 和 `db:migrate:status`：Rails 加载成功，开发库迁移完整。
- SQLite `PRAGMA integrity_check`：`ok`。
- `/up`、`/users/sign_in`、`/users/sign_up`、`/users/password/new`：应用请求检查返回 200。
- `start.cmd` 启动 Puma 8.0.2 成功；上述四个地址通过真实 HTTP 请求再次验证，均返回 200。
- `zeitwerk:check`：通过。
- libvips 读取项目 JPEG 并输出 PNG 缩略图：通过。
- 已初始化独立测试库；Minitest 15 项报错，RSpec 13 项失败，均首先遇到测试引用已删除的 `role` 字段。测试未被修改。

测试输出保存在 `tmp/windows-minitest.log` 和 `tmp/windows-rspec.log`。

Windows 启动时 Puma 提示 SIGUSR1 / SIGUSR2 / SIGHUP 不可用，这是 Unix 信号功能在 Windows 的限制，不影响本机页面服务。开发库验证后的 SHA-256 与原始备份相同，数据未被修改。

## 在另一台 Windows 电脑重建环境

官方来源：[RubyInstaller](https://rubyinstaller.org/downloads/)、[MSYS2 libvips](https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-libvips)。

```powershell
winget install --id RubyInstallerTeam.RubyWithDevKit.3.3 --exact --source winget
# 安装结束后重新打开 PowerShell
ridk install 1 3
gem install bundler -v 4.0.15 --no-document
ridk exec pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-libvips mingw-w64-ucrt-x86_64-sqlite3
ridk exec pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-libheif mingw-w64-ucrt-x86_64-libjxl mingw-w64-ucrt-x86_64-imagemagick mingw-w64-ucrt-x86_64-openslide mingw-w64-ucrt-x86_64-poppler
bundle _4.0.15_ install
```

如果携带已有数据库，先备份再检查迁移状态。全新数据库可以运行 `ruby bin/rails db:prepare`，但应了解 Rails 在首次准备数据库时可能执行 seeds。

本地开发不需要 Docker、WSL、MySQL、PostgreSQL、Redis 或 Node 前端工具链。生产部署是另一项工作：仓库里的 Kamal 主机和邮件域名仍是占位配置，不能直接视为可用的线上部署环境。
