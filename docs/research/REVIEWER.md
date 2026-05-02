# Reviewer prompt template

When a Stage-1 / Stage-2 / Stage-4 research report is finished, an
independent reviewer agent is dispatched. The reviewer's job is to
hold the work to the standard set in [`METHODOLOGY.md`](METHODOLOGY.md)
and [`TEMPLATE.md`](TEMPLATE.md), and to send the researcher back into
the field if the work is lazy, narrow, or unverified.

## What the reviewer reads

The reviewer reads, in order:

1. `METHODOLOGY.md`
2. `TEMPLATE.md`
3. The per-item `<item>/README.md` (project scope for the item)
4. The report under review and all its sibling files in the same
   stage subdirectory (`report.md`, `references.md`, `components.md`,
   `solutions.md`, `open-questions.md`).
5. Any *parallel* reports for the same item — to detect suspicious
   convergence between independent researchers.
6. Cited references — at least 5 spot-checks via `WebFetch`.

## What the reviewer outputs

A markdown file at:

```
docs/research/<item>/reviews/<reviewer-id>-<reportPath>-<YYYYMMDD>.md
```

with this structure:

```markdown
---
report_under_review: <relative path>
reviewer: <agent identifier>
date: <YYYY-MM-DD>
verdict: <"signed-off" | "revisions-requested" | "fail">
---

## Verdict

<"signed-off"> — every checklist item passes, no major gaps.
<"revisions-requested"> — at least one significant flaw, but the
report is salvageable; itemise required changes.
<"fail"> — the report is so deficient it should be redone from
scratch by a different researcher.

## Findings

### Reference verification (REQUIRED)

For at least 5 spot-checked references:

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| ... | yes/no | yes/no | yes/no/N/A | yes/no/N/A |

Any "no" → revisions-requested at minimum.

### Solution-space coverage

- Is §3 of the report actually exhaustive within the stated scope?
- Are the simplest "dumb" *and* most sophisticated approaches both
  represented?
- Approaches mentioned in the per-item README that the report
  *omitted*: list explicitly. Each omission is a fail unless the
  report justifies the omission.
- Approaches the *parallel sister reports* covered that this one
  did not: list explicitly.

### Premature narrowing

- Does the report spend > 40 % of its length on a single approach?
  If yes, this is a structural defect — flag.
- Does the report's executive summary express an opinion about
  "the best" approach? Stage-1 reports must not.

### Numerical claim verification

- For at least 3 of the report's numerical claims, redo the calculation.
- Document any disagreement (cite the underlying physics or source).
- Numbers that violate physics (Friis, Faraday, ε₀ε_r/d, fT, kTB,
  etc.) → automatic fail.

### Negative results

- Are negative / failed-elsewhere results catalogued (TEMPLATE.md §7)?
- A Stage-1 report without negative results is almost always lazy
  — flag.

### Convergence with parallel reports

If parallel reports exist for the same item, summarise where they
agree and disagree. If they agree on more than ~70 % of the
approaches, that's *suspicious convergence* — at least one
researcher was probably reading from the same shallow source. Flag
both reports and require additional approaches in each.

### Specific revisions requested

If the verdict is "revisions-requested", a numbered list of concrete
changes required. Each item is actionable.

## Closing notes

Free-form. Things the reviewer wants future reviewers / readers to
know.
```

## Reviewer behaviour expectations

- Reviewers are *adversarial*. Their reputation depends on catching
  flaws, not on being agreeable.
- Reviewers do not write code or replace the researcher's work.
  They produce a written critique.
- A reviewer who signs off on a flawed report is themselves sent
  back into the field by the next reviewer up the chain.

## Calibration: what "lazy" looks like

Examples of patterns reviewers should reject:

- Solution-space map with fewer than 5 distinct approaches.
- "Survey of approaches: I found {ring osc, RC osc}, here's the
  comparison" — at most two topology families.
- All references from one source (single textbook, single
  manufacturer's datasheet, single Wikipedia article).
- No physics derivation in §5 of the report.
- Suspiciously round numbers without citations.
- Negative results section that is empty or says only "no relevant
  failures found".
- Open questions that are vague ("further investigation needed")
  rather than specific.

When in doubt, send the report back. The cost of a redo is small;
the cost of letting weak research propagate downstream is large.
