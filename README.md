# HM_D20_SERIALS

HM_D20_SERIALS 是Hessian Matrix定位产品的在线文档仓库，覆盖HM-D20、HM-D13 RTK系列和HM-G51B GNSS产品。

当前仓库已按 Sphinx + Read the Docs 的方式搭好基础结构，后续可以直接在 `source/`
目录下维护产品选型、首次使用、接口接线、差分链路、行业集成和故障排查内容。

## 文档结构

```text
.
├── .readthedocs.yaml        # Read the Docs 构建配置
├── Makefile                 # 本地 Sphinx 构建入口
├── source/
│   ├── conf.py              # Sphinx 配置
│   ├── index.rst            # 文档首页
│   ├── 产品矩阵/            # 产品选型、五个SKU产品页和完整参数对比
│   ├── RTK系列/             # RTK快速开始、连接、差分、应用和维护
│   ├── GNSS系列/            # HM-G51B用户手册
│   └── _static/             # 站点公共样式
└── build/                   # 本地构建输出，已加入 .gitignore
```

## 本地预览

```bash
make deps
make html
make serve
```

浏览器访问 `http://127.0.0.1:8000/` 即可预览。`make serve` 只提供已经生成的静态文件。

推荐使用自动重建模式。它会监听 `source/` 下的文档和配置，文件保存后自动重新构建，
并持续提供同一个预览地址：

```bash
make dev-deps
make watch
```

然后访问 `http://127.0.0.1:8000/`。修改并保存 `.md`、`.rst`、`conf.py` 或 `_static/` 文件后，
等待终端显示构建结果，再刷新浏览器即可。终端中按 `Ctrl-C` 停止自动预览。

如果希望隔离 Python 环境，可以先创建虚拟环境再执行上面的命令：

```bash
python3 -m venv .venv
source .venv/bin/activate
make deps
make html
```

## Read the Docs 接入

1. 在 Read the Docs 导入 GitHub 仓库 `Hessian-matrix/HM_D20_SERIALS`。
2. 构建配置文件选择仓库根目录的 `.readthedocs.yaml`。
3. 文档入口由 `.readthedocs.yaml` 指向 `source/conf.py`，不需要额外指定。
4. 后续新增页面时，把对应页面加入相关章节的 `index.rst` toctree。

## 维护约定

- 页面正文优先使用 Markdown，章节索引用 reStructuredText 的 `toctree`。
- 图片放在对应章节下的 `image/` 或 `images/` 目录，避免跨章节引用。
- 命令、设备节点、波特率、坐标系、时间单位等硬件相关信息要写成可核对的具体值。
- 完整公开参数由 `source/产品矩阵/概述.md` 统一维护；SKU页和快速开始只保留选型或操作必需值。
- 新页面加入导航前运行严格HTML构建和链接检查，旧网址在删除前先保留兼容入口。
