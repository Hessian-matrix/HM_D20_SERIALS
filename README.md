# 黑森矩阵定位产品文档

本仓库用于维护 Hessian Matrix 定位产品的在线文档，覆盖 HM-D20、HM-D13 RTK 系列和 HM-G51B GNSS 产品。

当前仓库使用 Sphinx + Read the Docs 维护中英文在线文档。中文 `source/` 正文是唯一事实源，
英文通过 gettext PO 词条同步维护；两种语言共用图片和 ASCII 页面路径。

## 文档结构

```text
.
├── .readthedocs.yaml        # Read the Docs 构建配置
├── Makefile                 # 本地 Sphinx 构建入口
├── source/
│   ├── conf.py              # Sphinx 配置
│   ├── index.rst            # 文档首页
│   ├── products/            # 产品选型、各型号产品页和完整参数对比
│   ├── rtk/                 # RTK 快速开始、连接、差分、平台接入和维护
│   ├── gnss/                # HM-G51B 用户手册
│   ├── locales/en/          # 经审查的英文 gettext PO 词条
│   └── _static/             # 站点公共样式
├── i18n/                    # 公开术语、风格、受保护词和翻译检查
└── build/                   # 本地构建输出，已加入 .gitignore
```

## 本地预览

```bash
make deps
make html-zh
make serve-zh
```

浏览器访问 `http://127.0.0.1:8000/` 即可预览中文。英文使用 `make html-en && make serve-en`，
然后访问 `http://127.0.0.1:8001/`。`serve-*` 只提供已经生成的静态文件。

推荐使用自动重建模式。它会监听 `source/` 下的文档和配置，文件保存后自动重新构建，
并持续提供同一个预览地址：

```bash
make dev-deps
make watch-zh
```

然后访问 `http://127.0.0.1:8000/`。英文自动预览使用 `make watch-en` 和端口 `8001`。
修改并保存 `.md`、`.rst`、`.po`、`conf.py` 或 `_static/` 文件后，等待终端显示构建结果，
再刷新浏览器即可。终端中按 `Ctrl-C` 停止自动预览。

如果希望隔离 Python 环境，可以先创建虚拟环境再执行上面的命令：

```bash
python3 -m venv .venv
source .venv/bin/activate
make deps
make bilingual
```

## Read the Docs 接入

1. 在 Read the Docs 导入 GitHub 仓库 `Hessian-matrix/HM_D20_SERIALS`。
2. 构建配置文件选择仓库根目录的 `.readthedocs.yaml`。
3. 文档入口由 `.readthedocs.yaml` 指向 `source/conf.py`，不需要额外指定。
4. 后续新增页面时，把对应页面加入相关章节的 `index.rst` toctree。

Read the Docs 中将中文项目配置为英文项目的翻译源后，分别通过 `/zh-cn/latest/` 和
`/en/latest/` 访问。远端语言项目和默认语言只在双语改动审核通过后配置。

## 英文同步流程

中文内容更新后执行：

```bash
make i18n-update
# 审查 source/locales/en/LC_MESSAGES/ 中新增或变更的英文词条
make bilingual
```

`make i18n-check` 会检查缺失译文、残留中文、受保护的型号/数值/链接和已禁止的直译术语。
英文译文必须经过人工审核后才能随中文版本发布。

## 维护约定

- 页面正文优先使用 Markdown，章节索引用 reStructuredText 的 `toctree`。
- 图片放在对应章节下的 `image/` 或 `images/` 目录，避免跨章节引用。
- 命令、设备节点、波特率、坐标系、时间单位等硬件相关信息要写成可核对的具体值。
- 完整公开参数由 `source/products/comparison.md` 统一维护；产品页和快速开始只保留选型或操作必需值。
- 新页面加入导航前运行 `make bilingual`；旧中文网址通过重定向保留兼容入口。
