# English Documentation Style

- Use concise, natural US technical English. Translate intent, not Chinese word order.
- Keep information hierarchy aligned across languages: corresponding pages use the same section order, claims, warnings, procedure steps, and outcomes. Sentence structure may differ where natural English requires it.
- Use sentence case for headings and imperative verbs for procedures.
- Use `Getting Started`, not `First Use`; use `host PC`, not `upper computer`.
- Use `rover`, `base station`, `flight controller`, `correction link`, and `RTK fixed solution` consistently.
- Classify HM-D20 and HM-D13 as `integrated RTK GNSS receivers`. The products include the GNSS antenna, positioning engine, communication link, enclosure, and interfaces; do not reduce them to antennas or bare modules.
- Use `quadrifilar helix antenna (QHA)` on first reference to the D20 antenna architecture; `QHA` is acceptable afterward and in compact tables. Describe D13 with `compact`, `integrated`, or `all-in-one` wording; do not use `dome-style`, `mushroom-head`, or `puck-style` as formal English product labels.
- `Smart Antenna` is an accepted secondary industry term, but `Integrated RTK GNSS Receiver` is the formal category in this documentation.
- Classify HM-G51B as a `single-band multi-constellation GNSS receiver module` and describe its positioning mode as `standalone GNSS positioning`.
- Describe 4G correction access as a `CORS/NTRIP service` or `NTRIP correction service` according to context.
- Use `USB-to-UART adapter` as the formal English term for the supplied D20/D13 serial adapter; state the 3.3 V UART I/O requirement where electrical compatibility matters.
- Preserve product models, UI labels, commands, file paths, links, topics, message names, values, and units exactly.
- Do not add performance claims, operating conditions, compatibility, or troubleshooting steps that are absent from Chinese.
- Preserve warning severity. Wiring and power warnings must remain explicit and must not be shortened.
- D20/D13 wiring pages must distinguish the 5 V supply from 3.3 V UART I/O and state that 5 V UART logic may damage the device. Other pages may use a concise warning that links to the full pinout.
- Shared screenshots may contain English UI labels and must use an English alt description and caption.
- Prefer short paragraphs and scannable lists. Do not turn complete source content into a summary.
- Follow the approved mappings and usage notes in `i18n/terminology.md`; update both the human-readable table and `terminology.json` when a term is approved or changed.
