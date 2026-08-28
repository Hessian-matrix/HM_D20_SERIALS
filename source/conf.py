# -*- coding: utf-8 -*-

import os


def _docs_language() -> str:
    """Normalize local and Read the Docs language identifiers."""
    value = os.environ.get("DOCS_LANGUAGE") or os.environ.get("READTHEDOCS_LANGUAGE") or "zh_CN"
    normalized = value.replace("-", "_").lower()
    return "en" if normalized.startswith("en") else "zh_CN"

# 2026-08-04: 基础项目信息，用于 Read the Docs 页面标题和版本展示。
language = _docs_language()
project = "Hessian Matrix Positioning Documentation" if language == "en" else "黑森矩阵定位产品文档"
author = "Hessian Matrix"
copyright = "2026, Hessian Matrix"
version = "2026.08"
release = "2026.08.0"

# 2026-08-04: 同时支持 RST 目录页和 Markdown 正文页，便于后续迁移现有资料。
extensions = [
    "myst_parser",
    "sphinx_reredirects",
]
source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

# 2026-08-04: 排除本地构建产物，避免 Read the Docs 扫描无关文件。
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]
locale_dirs = ["locales/"]
gettext_compact = False

# 2026-08-11: 使用 Sphinx Book Theme，保持 Read the Docs 页面风格清晰易读。
html_theme = "sphinx_book_theme"
html_title = "Hessian Matrix Positioning Documentation" if language == "en" else "黑森矩阵定位产品文档"
html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_show_sourcelink = False
html_theme_options = {
    "repository_url": "",
    "use_repository_button": False,
    "use_issues_button": False,
    "use_edit_page_button": False,
    "home_page_in_toc": True,
    "show_navbar_depth": 2,
}

latex_engine = "xelatex"
latex_elements = {
    "preamble": r"""
\usepackage{xeCJK}
\setCJKmainfont{Droid Sans Fallback}
""",
}

# 2026-08-04: 为 Markdown 标题生成锚点，便于在线文档跨页面引用。
myst_heading_anchors = 3
myst_enable_extensions = [
    "colon_fence",
    "deflist",
]

# 旧中文 docname 仅用于历史链接跳转；正文和后续中英文 URL 统一使用 ASCII 路径。
redirects = {
    "产品矩阵/index": "products/index",
    "产品矩阵/概述": "products/comparison",
    "产品矩阵/产品/index": "products/models/index",
    "产品矩阵/产品/HM-D20-4G": "products/models/hm-d20-4g",
    "产品矩阵/产品/HM-D20-LoRa": "products/models/hm-d20-lora",
    "产品矩阵/产品/HM-D13-4G": "products/models/hm-d13-4g",
    "产品矩阵/产品/HM-D13-LoRa": "products/models/hm-d13-lora",
    "产品矩阵/产品/HM-G51B": "products/models/hm-g51b",
    "RTK系列/index": "rtk/index",
    "RTK系列/01-快速开始/index": "rtk/getting-started/index",
    "RTK系列/01-快速开始/HM-D20-4G首次使用": "rtk/getting-started/hm-d20-4g",
    "RTK系列/01-快速开始/HM-D20-LoRa首次使用": "rtk/getting-started/hm-d20-lora",
    "RTK系列/01-快速开始/HM-D13-4G首次使用": "rtk/getting-started/hm-d13-4g",
    "RTK系列/01-快速开始/HM-D13-LoRa首次使用": "rtk/getting-started/hm-d13-lora",
    "RTK系列/02-概述": "rtk/overview",
    "RTK系列/05-基本使用/index": "rtk/operation/index",
    "RTK系列/05-基本使用/D20接口与接线": "rtk/operation/d20-wiring",
    "RTK系列/05-基本使用/D13接口与接线": "rtk/operation/d13-wiring",
    "RTK系列/05-基本使用/上位机连接与串口调试": "rtk/operation/host-tool",
    "RTK系列/05-基本使用/固件与输出协议选择": "rtk/operation/firmware-output",
    "RTK系列/05-基本使用/RTK状态与Fixed验证": "rtk/operation/rtk-fixed-validation",
    "RTK系列/06-差分链路配置/index": "rtk/differential-links/index",
    "RTK系列/06-差分链路配置/01-D13基站说明": "rtk/differential-links/d13-base-station",
    "RTK系列/06-差分链路配置/02-4G差分链路配置": "rtk/differential-links/4g-ntrip",
    "RTK系列/06-差分链路配置/03-LoRa差分链路配置": "rtk/differential-links/lora",
    "RTK系列/07-行业应用/index": "rtk/integrations/index",
    "RTK系列/07-行业应用/01-无人机应用-ArduPilot": "rtk/integrations/ardupilot",
    "RTK系列/07-行业应用/02-无人机应用-PX4": "rtk/integrations/px4",
    "RTK系列/07-行业应用/03-接入Viobot2": "rtk/integrations/viobot2",
    "RTK系列/07-行业应用/04-接入ROS": "rtk/integrations/jetson-raspberry-pi",
    "RTK系列/08-参数配置和维护/index": "rtk/maintenance/index",
    "RTK系列/08-参数配置和维护/01-常用参数配置": "rtk/maintenance/parameters",
    "RTK系列/08-参数配置和维护/02-固件升级": "rtk/maintenance/firmware-update",
    "RTK系列/09-常见问题/index": "rtk/troubleshooting/index",
    "RTK系列/09-常见问题/01-故障排查": "rtk/troubleshooting/troubleshooting",
    "GNSS系列/index": "gnss/index",
    "GNSS系列/G51B/index": "gnss/g51b/index",
    "GNSS系列/G51B/G51B快速开始": "gnss/g51b/getting-started",
}
