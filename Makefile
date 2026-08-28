# 2026-08-04: Sphinx 文档本地构建入口，保持和 Read the Docs 构建目录一致。
# 优先使用项目虚拟环境，保证本地预览与 Read the Docs 的依赖版本一致。
PYTHON        ?= $(if $(wildcard .venv/bin/python),.venv/bin/python,python3)
PIP           ?= $(PYTHON) -m pip
UV            ?= uv
SPHINXOPTS    ?=
SPHINXBUILD   ?= $(PYTHON) -m sphinx
SPHINXAUTO    ?= $(if $(wildcard .venv/bin/sphinx-autobuild),.venv/bin/sphinx-autobuild,sphinx-autobuild)
SPHINXINTL    ?= $(if $(wildcard .venv/bin/sphinx-intl),.venv/bin/sphinx-intl,sphinx-intl)
SOURCEDIR     = source
BUILDDIR      = build
GETTEXTDIR    = $(BUILDDIR)/gettext
LOCALEDIR     = $(SOURCEDIR)/locales

# 2026-08-04: 默认目标只打印仓库常用命令，避免未安装 Sphinx 时 help 也失败。
help:
	@echo "Usage:"
	@echo "  make deps   Install Sphinx documentation dependencies"
	@echo "  make dev-deps Install local auto-preview dependencies"
	@echo "  make html   Build HTML documentation into build/html"
	@echo "  make serve  Serve the existing build/html output on port 8000"
	@echo "  make watch  Auto-build and serve documentation on port 8000"
	@echo "  make serve-zh Serve Chinese HTML on port 8000"
	@echo "  make serve-en Serve English HTML on port 8001"
	@echo "  make watch-zh Auto-build Chinese HTML on port 8000"
	@echo "  make watch-en Auto-build English HTML on port 8001"
	@echo "  make gettext Extract Chinese translation units"
	@echo "  make i18n-update Update English PO catalogs"
	@echo "  make i18n-check Validate English translation catalogs"
	@echo "  make i18n-check-html Validate rendered English contains no Chinese text"
	@echo "  make html-zh Build strict Chinese HTML into build/zh-cn/html"
	@echo "  make html-en Build strict English HTML into build/en/html"
	@echo "  make bilingual Build and link-check both languages"
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

serve-zh:
	@$(PYTHON) -m http.server 8000 --directory "$(BUILDDIR)/zh-cn/html"

serve-en:
	@$(PYTHON) -m http.server 8001 --directory "$(BUILDDIR)/en/html"

watch-zh:
	@DOCS_LANGUAGE=zh_CN $(SPHINXAUTO) --host 0.0.0.0 --port 8000 "$(SOURCEDIR)" "$(BUILDDIR)/zh-cn/html" $(SPHINXOPTS)

watch-en:
	@DOCS_LANGUAGE=en $(SPHINXAUTO) --host 0.0.0.0 --port 8001 "$(SOURCEDIR)" "$(BUILDDIR)/en/html" $(SPHINXOPTS)

gettext:
	@DOCS_LANGUAGE=zh_CN $(SPHINXBUILD) -b gettext -W --keep-going "$(SOURCEDIR)" "$(GETTEXTDIR)"

i18n-update: gettext
	@$(SPHINXINTL) update -p "$(GETTEXTDIR)" -l en -d "$(LOCALEDIR)"

i18n-check:
	@$(PYTHON) i18n/check_translations.py "$(LOCALEDIR)/en/LC_MESSAGES"

i18n-check-html:
	@$(PYTHON) i18n/check_rendered_english.py "$(BUILDDIR)/en/html"

html-zh:
	@DOCS_LANGUAGE=zh_CN $(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/zh-cn" -W --keep-going $(SPHINXOPTS)

html-en:
	@DOCS_LANGUAGE=en $(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)/en" -W --keep-going $(SPHINXOPTS)

linkcheck-zh:
	@DOCS_LANGUAGE=zh_CN $(SPHINXBUILD) -M linkcheck "$(SOURCEDIR)" "$(BUILDDIR)/zh-cn" -W --keep-going $(SPHINXOPTS)

linkcheck-en:
	@DOCS_LANGUAGE=en $(SPHINXBUILD) -M linkcheck "$(SOURCEDIR)" "$(BUILDDIR)/en" -W --keep-going $(SPHINXOPTS)

bilingual: i18n-check html-zh html-en i18n-check-html linkcheck-zh linkcheck-en

.PHONY: help deps dev-deps serve watch serve-zh serve-en watch-zh watch-en gettext i18n-update i18n-check i18n-check-html html-zh html-en linkcheck-zh linkcheck-en bilingual Makefile

# 2026-08-04: 将 html/linkcheck/clean 等目标转发给 Sphinx 的 make-mode。
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
