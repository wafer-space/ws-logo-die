# Report template

Every Stage-1 / Stage-2 / Stage-4 research report uses this structure.
Sections marked **REQUIRED** must be present. Sections marked
*optional* should be included when they have content; if they would be
empty, omit them rather than leaving placeholder text.

The intent is that, after-the-fact, a reader can compare two parallel
reports section-by-section and immediately see where they agree and
where they diverge.

---

## Front matter — REQUIRED

```yaml
---
item: <letter, e.g. "a">
item_name: <short name, e.g. "internal-oscillator">
stage: <1 | 2 | 4>
angle: <"industry-survey" | "academic-survey" | "first-principles" |
        "synthesis" | "deep-dive:<option-name>">
researcher: <agent identifier or human name>
status: <"draft" | "in-review" | "revisions-requested" | "signed-off">
last-updated: <YYYY-MM-DD>
parent-report: <relative path, only for stage 4 deep dives>
---
```

## 1. Executive summary — REQUIRED

Two to four paragraphs. State, plainly:

- What problem this report addresses.
- The breadth of the search performed (sources consulted, time
  spent, kinds of approaches considered).
- The headline conclusions, **without picking a winner** at Stage 1.
- Any explicit limits on the search (e.g. "we did not survey
  biological-substrate clocks because they are out of scope for
  silicon").

## 2. Requirements as understood — REQUIRED

Re-state, in your own words, the project requirements that this
report is responding to. This is a *check on the brief* — if the
researcher misunderstood what they were asked to find, that surfaces
here.

Cite the source of each stated requirement (line in `TODO.md`,
constraint in the project brief, etc.).

## 3. Solution-space map — REQUIRED

This is the **core deliverable** of a Stage-1 report. Enumerate every
distinct approach you found. For each, include:

- A unique short name (used as a stable identifier across reports).
- One-paragraph plain-language description.
- Where it is currently used (commercial product, paper, patent).
- Typical performance numbers (with citations).
- Conditions under which it has been tried and found *insufficient*,
  with the exact failure mode and original use-case requirements.
- Conditions under which our project's requirements *differ*, and how
  that might change the verdict.

Group approaches by family (e.g. "ring-based", "RC-based", "LC-based",
"piezoelectric", "self-clocked") to reveal structure.

**Do not silently drop any approach you considered.** If you
discarded one as obviously irrelevant, list it briefly with a one-line
reason.

## 4. Sub-block breakdown — REQUIRED

For each high-level approach in §3, list the sub-blocks / building
blocks that an implementation would need. Examples:

- For an oscillator: timing core, bias generator, trim DAC, level
  shifter, supply rejection.
- For an NFC harvester: tuning capacitor bank, rectifier, overvoltage
  clamp, regulator, brown-out detector, antenna match.

This section is what allows a downstream architect to assess effort
and area cost.

## 5. First-principles sanity checks — REQUIRED

For every numerical claim made in §3, perform a first-principles
sanity check:

- Cite the underlying physical limit (Carnot, Friis, Shannon,
  Faraday, etc.) where relevant.
- Show the calculation explicitly.
- Flag any number that the prior art seems to claim *and* the
  physics seems to forbid. Investigate; reconcile or document the
  contradiction.

Quantities that are merely *pessimistic* are still numbers; pessimism
about easy approaches is a feature.

## 6. References — REQUIRED

Annotated bibliography. For each entry:

- Full citation (authors, title, venue, year, DOI/ISBN/URL).
- Type (peer-reviewed, datasheet, patent, blog, preprint, app note).
- Accessibility (open-access, paywalled, archived, broken).
- **Verification status**: have you confirmed the URL resolves and
  the document at that URL matches the citation? Use `WebFetch`,
  `gh api`, or equivalent. Date of verification.
- Local cache path under `references-cache/<citation-id>/`. If the
  source cannot be cached due to copyright, record the SHA-256 of the
  fetched document instead.
- A 1–3-sentence summary of the source's relevance to *this* item.

A reference that is cited in §3 but absent from §6 is a defect.

## 7. Negative results — REQUIRED

What didn't work, what was abandoned, what looked promising but
contained hidden costs. This section is **expected to have content**.
A Stage-1 report that finds no negative results is almost certainly
incomplete and will be sent back.

## 8. Open questions — REQUIRED

Concrete unanswered questions. Phrase each as a question, with:

- The decision or downstream work that depends on the answer.
- A guess at what kind of investigation would settle it (paper search,
  Spice sim, prototype measurement).

## 9. Comparison readiness — REQUIRED

A short table that the Stage-2 synthesiser can ingest. Use stable
short names from §3.

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| ... | ... | ... | ... | ... | ... |

This is the structured handoff. Stage 2 will merge tables across
parallel surveys.

## 10. Author's notes — *optional*

Free-form. Process notes, surprises, things you wish you'd had time
to investigate.

---

## Quality checklist (for self-review before declaring "in-review")

- [ ] Every section above marked REQUIRED is present and non-trivial.
- [ ] At least 5 distinct approaches are catalogued in §3 (a Stage-1
      report with fewer than 5 is almost certainly under-specified).
- [ ] Every reference in §6 has been verified to exist and (where
      possible) cached locally.
- [ ] At least one negative result is documented in §7.
- [ ] Every numerical claim has been sanity-checked against physics
      in §5.
- [ ] The report does **not** recommend a single approach (Stage-1)
      / does recommend with explicit reasoning (Stage-3+).
- [ ] No silent omissions: any approach the researcher considered
      and discarded is named, with a reason.

If any box is unchecked, do not move the status to `in-review`.

## Quality checklist (for reviewers)

- [ ] §3 is genuinely exhaustive within the stated scope.
- [ ] §3 includes both the "simplest dumb" and "most sophisticated"
      ends of the spectrum.
- [ ] §6 references all resolve to the cited document (spot-check
      at least 5).
- [ ] Cached local copies (where present) match the upstream source
      (spot-check via SHA-256 or visual diff).
- [ ] Any number that looked too good to be true has been
      sanity-checked, not just repeated.
- [ ] Negative results have actionable detail, not just "this
      didn't work".
- [ ] No premature narrowing — the report does not spend 80 % of its
      length on the researcher's favourite approach.
- [ ] If a parallel sister-report exists, the two are not suspiciously
      similar.

A reviewer who signs off on a report that fails these checks is
*also* sent back into the field.
