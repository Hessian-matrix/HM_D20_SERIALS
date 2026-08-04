# HM_D20_SERIALS

HM_D20_SERIALS 是 HM_D20 RTK 与串口相关资料的在线文档仓库。

当前仓库已按 Sphinx + Read the Docs 的方式搭好基础结构，后续可以直接在 `source/`
目录下补充设备说明、串口协议、RTK 配置流程和故障排查内容。

## 文档结构

```text
.
├── .readthedocs.yaml        # Read the Docs 构建配置
├── Makefile                 # 本地 Sphinx 构建入口
├── source/
│   ├── conf.py              # Sphinx 配置
│   ├── index.rst            # 文档首页
│   ├── quick_start.md       # 快速开始
│   ├── serial/              # 串口通信章节
│   ├── rtk/                 # RTK 使用章节
│   └── faq/                 # 常见问题章节
└── build/                   # 本地构建输出，已加入 .gitignore
```

## 本地预览

```bash
make deps
make html
python3 -m http.server 8000 --directory build/html
```

浏览器访问 `http://127.0.0.1:8000` 即可预览。

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
