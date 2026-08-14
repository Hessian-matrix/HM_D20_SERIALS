# 2026-08-04: Sphinx 文档本地构建入口，保持和 Read the Docs 构建目录一致。
# 优先使用项目虚拟环境，保证本地预览与 Read the Docs 的依赖版本一致。
PYTHON        ?= $(if $(wildcard .venv/bin/python),.venv/bin/python,python3)
PIP           ?= $(PYTHON) -m pip
UV            ?= uv
SPHINXOPTS    ?=
SPHINXBUILD   ?= $(PYTHON) -m sphinx
SPHINXAUTO    ?= $(if $(wildcard .venv/bin/sphinx-autobuild),.venv/bin/sphinx-autobuild,sphinx-autobuild)
SOURCEDIR     = source
BUILDDIR      = build

# 2026-08-04: 默认目标只打印仓库常用命令，避免未安装 Sphinx 时 help 也失败。
help:
	@echo "Usage:"
	@echo "  make deps   Install Sphinx documentation dependencies"
	@echo "  make dev-deps Install local auto-preview dependencies"
	@echo "  make html   Build HTML documentation into build/html"
	@echo "  make serve  Serve the existing build/html output on port 8000"
	@echo "  make watch  Auto-build and serve documentation on port 8000"
	@echo "  make clean  Remove Sphinx build outputs"

# 2026-08-04: 首次本地编译前安装依赖；Read the Docs 会按 .readthedocs.yaml 自动执行同类安装。
deps:
	@if command -v $(UV) >/dev/null 2>&1; then \
		$(UV) pip install --python "$(PYTHON)" -r "$(SOURCEDIR)/requirements.txt"; \
	else \
		$(PIP) install -r "$(SOURCEDIR)/requirements.txt"; \
	fi

dev-deps:
	@if command -v $(UV) >/dev/null 2>&1; then \
		$(UV) pip install --python "$(PYTHON)" -r "$(SOURCEDIR)/requirements-dev.txt"; \
	else \
		$(PIP) install -r "$(SOURCEDIR)/requirements-dev.txt"; \
	fi

serve:
	@$(PYTHON) -m http.server 8000 --directory "$(BUILDDIR)/html"

watch:
	@$(SPHINXAUTO) --host 0.0.0.0 --port 8000 "$(SOURCEDIR)" "$(BUILDDIR)/html" $(SPHINXOPTS)

.PHONY: help deps dev-deps serve watch Makefile

# 2026-08-04: 将 html/linkcheck/clean 等目标转发给 Sphinx 的 make-mode。
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
