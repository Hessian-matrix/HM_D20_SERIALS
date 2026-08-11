# -*- coding: utf-8 -*-

# 2026-08-04: 基础项目信息，用于 Read the Docs 页面标题和版本展示。
project = "HM_D20_SERIALS"
author = "Hessian Matrix"
copyright = "2026, Hessian Matrix"
release = "0.1.0"

# 2026-08-04: 同时支持 RST 目录页和 Markdown 正文页，便于后续迁移现有资料。
extensions = [
    "myst_parser",
    "sphinx_lumina_theme",
]
source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

# 2026-08-04: 排除本地构建产物，避免 Read the Docs 扫描无关文件。
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]
language = "zh_CN"

# 2026-08-11: 使用 Sphinx Lumina Theme，保留 custom.css 覆盖产品矩阵表格样式。
html_theme = "lumina"
html_title = "HM_D20_SERIALS 文档"
html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_show_sourcelink = False
html_theme_options = {
    "disable_seo": True,
}

# 2026-08-04: 为 Markdown 标题生成锚点，便于在线文档跨页面引用。
myst_heading_anchors = 3
myst_enable_extensions = [
    "colon_fence",
    "deflist",
]
