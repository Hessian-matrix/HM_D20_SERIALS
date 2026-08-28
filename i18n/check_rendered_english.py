#!/usr/bin/env python3
"""Reject visible Chinese text that survives in rendered English HTML."""

from __future__ import annotations

import re
import sys
from pathlib import Path


CJK_RE = re.compile(r"[\u3400-\u9fff]")
LANGUAGE_SWITCH_RE = re.compile(
    r'<a\b[^>]*class="[^"]*\bhm-language-switch\b[^"]*"[^>]*>.*?</a>',
    re.DOTALL,
)


def remove_language_switches(html: str) -> str:
    """忽略语言控件中的目标语言名称，同时保留原始行号。"""
    return LANGUAGE_SWITCH_RE.sub(lambda match: "\n" * match.group(0).count("\n"), html)


def main() -> int:
    html_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("build/en/html")
    html_files = sorted(html_dir.rglob("*.html"))
    if not html_files:
        print(f"ERROR: no rendered HTML files found under {html_dir}")
        return 1

    errors: list[str] = []
    for html_path in html_files:
        html = html_path.read_text(encoding="utf-8")
        rendered_content = remove_language_switches(html)
        for line_number, line in enumerate(rendered_content.splitlines(), 1):
            match = CJK_RE.search(line)
            if match:
                excerpt = line[max(0, match.start() - 30):match.end() + 50].strip()
                errors.append(f"{html_path}:{line_number}: Chinese text remains: {excerpt!r}")

    for error in errors:
        print(f"ERROR: {error}")
    print(f"Checked {len(html_files)} rendered English HTML files.")
    if errors:
        print(f"Rendered English validation failed with {len(errors)} error(s).")
        return 1
    print("Rendered English validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
