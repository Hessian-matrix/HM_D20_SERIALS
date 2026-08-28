#!/usr/bin/env python3
"""Validate paired language controls and alternate links in rendered HTML."""

from __future__ import annotations

import sys
from html.parser import HTMLParser
from pathlib import Path


DOCS_BASE_URL = "https://hm-rtk-serials.readthedocs.io"
LANGUAGES = {
    "zh-cn": {"target": "en", "label": "English", "hreflang": "en"},
    "en": {"target": "zh-cn", "label": "中文", "hreflang": "zh-CN"},
}


class PageParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.is_redirect = False
        self.switch_depth = 0
        self.switches: list[dict[str, str]] = []
        self.alternates: dict[str, str] = {}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attributes = {key: value or "" for key, value in attrs}
        classes = set(attributes.get("class", "").split())

        if tag == "meta" and attributes.get("http-equiv", "").lower() == "refresh":
            self.is_redirect = True

        if tag == "a" and "hm-language-switch" in classes:
            self.switch_depth = 1
            self.switches.append(
                {
                    "href": attributes.get("href", ""),
                    "hreflang": attributes.get("hreflang", ""),
                    "target": attributes.get("data-target-language", ""),
                    "label": "",
                }
            )
        elif self.switch_depth:
            self.switch_depth += 1

        if tag == "link" and "alternate" in attributes.get("rel", "").split():
            self.alternates[attributes.get("hreflang", "")] = attributes.get("href", "")

    def handle_endtag(self, tag: str) -> None:
        if self.switch_depth:
            self.switch_depth -= 1

    def handle_data(self, data: str) -> None:
        if self.switch_depth and self.switches:
            self.switches[-1]["label"] += data.strip()


def expected_url(language: str, version: str, relative_path: Path) -> str:
    page = "" if relative_path.as_posix() == "index.html" else relative_path.as_posix()
    return f"{DOCS_BASE_URL}/{language}/{version}/{page}"


def validate_language(build_root: Path, language: str, version: str) -> tuple[set[Path], list[str]]:
    html_root = build_root / language / "html"
    pages: set[Path] = set()
    errors: list[str] = []
    expected_switch = LANGUAGES[language]

    for html_path in sorted(html_root.rglob("*.html")):
        relative_path = html_path.relative_to(html_root)
        if relative_path.parts[0] == "_static":
            continue
        parser = PageParser()
        parser.feed(html_path.read_text(encoding="utf-8"))
        if parser.is_redirect:
            continue

        pages.add(relative_path)
        target_url = expected_url(expected_switch["target"], version, relative_path)
        if not parser.switches:
            errors.append(f"{html_path}: missing language switch")
        for switch in parser.switches:
            if switch["href"] != target_url:
                errors.append(f"{html_path}: unexpected switch URL {switch['href']!r}")
            if switch["target"] != expected_switch["target"]:
                errors.append(f"{html_path}: unexpected target language {switch['target']!r}")
            if switch["hreflang"] != expected_switch["hreflang"]:
                errors.append(f"{html_path}: unexpected switch hreflang {switch['hreflang']!r}")
            if switch["label"] != expected_switch["label"]:
                errors.append(f"{html_path}: unexpected switch label {switch['label']!r}")

        for hreflang, alternate_language in (("zh-CN", "zh-cn"), ("en", "en")):
            alternate_url = expected_url(alternate_language, version, relative_path)
            if parser.alternates.get(hreflang) != alternate_url:
                errors.append(f"{html_path}: invalid {hreflang} alternate URL")

    return pages, errors


def main() -> int:
    build_root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("build")
    version = sys.argv[2] if len(sys.argv) > 2 else "latest"
    all_pages: dict[str, set[Path]] = {}
    errors: list[str] = []

    for language in LANGUAGES:
        pages, language_errors = validate_language(build_root, language, version)
        all_pages[language] = pages
        errors.extend(language_errors)

    if all_pages["zh-cn"] != all_pages["en"]:
        only_zh = sorted(all_pages["zh-cn"] - all_pages["en"])
        only_en = sorted(all_pages["en"] - all_pages["zh-cn"])
        errors.append(f"page sets differ; Chinese only: {only_zh}; English only: {only_en}")

    for error in errors:
        print(f"ERROR: {error}")
    print(
        f"Checked {len(all_pages['zh-cn'])} paired rendered pages "
        f"for language switches and alternate links."
    )
    if errors:
        print(f"Language switch validation failed with {len(errors)} error(s).")
        return 1
    print("Language switch validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
