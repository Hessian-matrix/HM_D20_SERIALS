# 2026-08-04: Sphinx 文档本地构建入口，保持和 Read the Docs 构建目录一致。
PYTHON        ?= python3
PIP           ?= $(PYTHON) -m pip
SPHINXOPTS    ?=
SPHINXBUILD   ?= $(PYTHON) -m sphinx
SOURCEDIR     = source
BUILDDIR      = build

# 2026-08-04: 默认目标只打印仓库常用命令，避免未安装 Sphinx 时 help 也失败。
help:
	@echo "Usage:"
	@echo "  make deps   Install Sphinx documentation dependencies"
	@echo "  make html   Build HTML documentation into build/html"
	@echo "  make clean  Remove Sphinx build outputs"

# 2026-08-04: 首次本地编译前安装依赖；Read the Docs 会按 .readthedocs.yaml 自动执行同类安装。
deps:
	@$(PIP) install -r "$(SOURCEDIR)/requirements.txt"

.PHONY: help deps Makefile

# 2026-08-04: 将 html/linkcheck/clean 等目标转发给 Sphinx 的 make-mode。
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
