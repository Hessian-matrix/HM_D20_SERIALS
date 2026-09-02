#!/usr/bin/env python3
"""Validate completeness and protected technical content in English PO files."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

import polib


ROOT = Path(__file__).resolve().parent
CJK_RE = re.compile(r"[\u3400-\u9fff]")
FULLWIDTH_PUNCTUATION_RE = re.compile(r"[，。；：（）【】“”]")
URL_RE = re.compile(r"https?://[^\s)>\]}]+")
CODE_RE = re.compile(r"`+([^`\n]+?)`+")
RST_ROLE_RE = re.compile(r"(?:\:[A-Za-z0-9_-]+\:|\{[A-Za-z0-9_-]+\})`([^`]+)`")
RST_ROLE_TARGET_RE = re.compile(r"<([^>]+)>\s*$")
UNIT_RE = re.compile(
    r"(?<![\w.])\d+(?:\.\d+)?\s*(?:Hz|kHz|MHz|bps|V|mA|A|g|mm|cm|km|m|dBm|ppm|ns|m/s)(?![\w/])"
)
LINK_TARGET_RE = re.compile(r"\]\(([^)]+)\)")
NUMBERED_HEADING_RE = re.compile(r"^\d+\.\s")
BANNED_TRANSLATION_PATTERNS = {
    "use 'Getting Started' instead of 'First Use'": re.compile(r"\bFirst Use\b", re.IGNORECASE),
    "use 'rover' instead of 'Mobile Station'": re.compile(r"\bMobile Station\b", re.IGNORECASE),
    "use 'host PC' instead of 'host computer'": re.compile(r"\bhost computer\b", re.IGNORECASE),
    "use 'quadrifilar helix antenna' for the D20 antenna": re.compile(
        r"\bfour[ -]arm (?:helical|spiral|rotor|propeller)(?: antenna)?\b",
        re.IGNORECASE,
    ),
    "use capability-based D13 terminology instead of a literal shape label": re.compile(
        r"\b(?:mushroom[ -]head|dome[ -]style|puck[ -]style)\b", re.IGNORECASE
    ),
    "use 'quadrifilar helix antenna' instead of a propeller label": re.compile(
        r"\b(?:quad|four)-arm propeller\b", re.IGNORECASE
    ),
    "use 'integrated RTK GNSS receiver' instead of 'RTK integrated device'": re.compile(
        r"\bRTK integrated device\b", re.IGNORECASE
    ),
    "use 'GNSS receiver module' instead of 'GNSS integrated module'": re.compile(
        r"\b(?:integrated GNSS|GNSS integrated) module\b", re.IGNORECASE
    ),
    "remove duplicated firmware wording": re.compile(r"\bfirmware firmware\b", re.IGNORECASE),
    "use SIM card or data plan instead of 'traffic card'": re.compile(
        r"\btraffic cards?\b", re.IGNORECASE
    ),
    "use 'positive supply lead/input' instead of pole/electrode": re.compile(
        r"\bpositive (?:pole|electrode)\b", re.IGNORECASE
    ),
    "use 'correction link/data' instead of literal differential wording": re.compile(
        r"\bdifferential (?:link|data|communication link|system|source|protocol)\b",
        re.IGNORECASE,
    ),
    "use 'standalone GNSS positioning' instead of 'standard GNSS positioning'": re.compile(
        r"\bstandard (?:single-(?:frequency|band) )?GNSS positioning\b",
        re.IGNORECASE,
    ),
    "identify G51B as a GNSS receiver module": re.compile(
        r"\bsingle-frequency GNSS module\b", re.IGNORECASE
    ),
}


def load_tokens() -> list[str]:
    data = json.loads((ROOT / "protected_tokens.json").read_text(encoding="utf-8"))
    return sorted(data["tokens"], key=len, reverse=True)


def load_terminology() -> list[tuple[list[str], list[str]]]:
    data = json.loads((ROOT / "terminology.json").read_text(encoding="utf-8"))
    terminology: list[tuple[list[str], list[str]]] = []
    for term in data["terms"]:
        if not term.get("enforce", False):
            continue
        source_terms = term.get("zh_variants", [term["zh"]])
        approved_terms = [term["en"], *term.get("en_variants", [])]
        terminology.append((source_terms, approved_terms))
    return terminology


def protected_fragments(text: str, configured_tokens: list[str]) -> set[str]:
    fragments = {token for token in configured_tokens if token in text}
    fragments.update(URL_RE.findall(text))
    fragments.update(UNIT_RE.findall(text))
    fragments.update(LINK_TARGET_RE.findall(text))

    for role in RST_ROLE_RE.finditer(text):
        content = role.group(1)
        target_match = RST_ROLE_TARGET_RE.search(content)
        if target_match:
            fragments.add(target_match.group(1))
        elif not CJK_RE.search(content):
            fragments.add(content)

    inline_code_text = RST_ROLE_RE.sub("", text)
    fragments.update(CODE_RE.findall(inline_code_text))
    return {fragment for fragment in fragments if fragment}


def protected_fragment_is_localized(fragment: str, translation: str) -> bool:
    """Allow the page-language variant of a downloadable helper script.

    Chinese and English pages intentionally link to the matching localized
    script (`*_zh.sh` versus `*_en.sh`).  The rest of the path remains
    protected, so this narrowly scoped exception does not weaken URL checks.
    """
    if fragment.endswith("_zh.sh"):
        return fragment[:-6] + "_en.sh" in translation
    return False


def main() -> int:
    locale_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("source/locales/en/LC_MESSAGES")
    po_files = sorted(locale_dir.rglob("*.po"))
    if not po_files:
        print(f"ERROR: no PO files found under {locale_dir}")
        return 1

    tokens = load_tokens()
    terminology = load_terminology()
    errors: list[str] = []
    translated = 0
    checked = 0

    for po_path in po_files:
        catalog = polib.pofile(str(po_path))
        for entry in catalog:
            if entry.obsolete or not entry.msgid:
                continue
            checked += 1
            location = f"{po_path}:{entry.linenum}"
            if "fuzzy" in entry.flags:
                errors.append(f"{location}: fuzzy translation")

            translation = entry.msgstr.strip()
            if CJK_RE.search(entry.msgid) and not translation:
                errors.append(f"{location}: untranslated Chinese source: {entry.msgid[:80]!r}")
                continue
            if not translation:
                continue

            translated += 1
            if CJK_RE.search(translation):
                errors.append(f"{location}: Chinese characters remain in English translation")

            punctuation = sorted(set(FULLWIDTH_PUNCTUATION_RE.findall(translation)))
            if punctuation:
                errors.append(
                    f"{location}: full-width Chinese punctuation remains in English translation: "
                    f"{''.join(punctuation)!r}"
                )

            source_text = entry.msgid.casefold()
            translation_text = translation.casefold()
            for source_terms, approved_terms in terminology:
                matched_source = next(
                    (source for source in source_terms if source.casefold() in source_text), None
                )
                if matched_source and not any(
                    approved.casefold() in translation_text for approved in approved_terms
                ):
                    errors.append(
                        f"{location}: terminology mismatch for {matched_source!r}; "
                        f"expected one of {approved_terms!r}"
                    )

            # Sphinx 7.1 + MyST skips translated Markdown headings that begin with
            # an ordered-list marker. English step headings therefore use "Step N:".
            if NUMBERED_HEADING_RE.match(entry.msgid) and NUMBERED_HEADING_RE.match(translation):
                errors.append(f"{location}: numbered heading must use 'Step N:' in English")

            for description, pattern in BANNED_TRANSLATION_PATTERNS.items():
                if pattern.search(translation):
                    errors.append(f"{location}: {description}")

            for fragment in protected_fragments(entry.msgid, tokens):
                if fragment not in translation and not protected_fragment_is_localized(fragment, translation):
                    errors.append(f"{location}: protected fragment changed or missing: {fragment!r}")

    for error in errors:
        print(f"ERROR: {error}")
    print(f"Checked {checked} messages across {len(po_files)} catalogs; {translated} have explicit translations.")
    if errors:
        print(f"Translation validation failed with {len(errors)} error(s).")
        return 1
    print("Translation validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
