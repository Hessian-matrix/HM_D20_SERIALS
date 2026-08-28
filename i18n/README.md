# Translation Resources

Chinese files under `source/` are the only authored documentation source. English is stored as reviewed gettext catalogs under `source/locales/en/LC_MESSAGES/`.

Terminology is maintained in two synchronized forms:

- `terminology.md`: the human-review table with context and usage rules;
- `terminology.json`: the machine-readable Chinese-English mapping.

The public translation workflow is:

1. Run `make i18n-update` after an approved Chinese change.
2. Translate only new or changed entries. Keep approved unchanged English.
3. Run `make i18n-check` and `make bilingual`.
4. Review technical equivalence and English readability separately.
5. Publish only after human approval.

`make i18n-check` validates catalog completeness, protected technical content,
approved terminology, and the English step-heading form required by Sphinx/MyST.
After building English, `make i18n-check-html` rejects any Chinese text that
survives in rendered HTML.
`make i18n-check-switches` validates that every rendered Chinese and English
page links to its corresponding translation and publishes matching `hreflang`
metadata. Both checks run as part of `make bilingual`.

Files in this directory are intentionally public-safe. Internal evidence, unreleased product details, customer data, and AI-provider credentials must not be added here.
