# -*- coding: utf-8 -*-

# 2026-08-04: 基础项目信息，用于 Read the Docs 页面标题和版本展示。
project = "黑森矩阵定位产品文档"
author = "Hessian Matrix"
copyright = "2026, Hessian Matrix"
release = "0.1.0"

# 2026-08-04: 同时支持 RST 目录页和 Markdown 正文页，便于后续迁移现有资料。
extensions = [
    "myst_parser",
]
source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

# 2026-08-04: 排除本地构建产物，避免 Read the Docs 扫描无关文件。
templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]
language = "zh_CN"

# 2026-08-11: 使用 Sphinx Book Theme，保持 Read the Docs 页面风格清晰易读。
html_theme = "sphinx_book_theme"
html_title = "黑森矩阵定位产品文档"
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
