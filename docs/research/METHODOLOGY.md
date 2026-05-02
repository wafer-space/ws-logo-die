# Research methodology

This document is the **contract** that every research agent (and every
human researcher) on this project follows. Read this in full before
producing any work product. The structure exists because the user has
explicitly demanded *exhaustive, comprehensive, accurate, and
cross-checked* research on every item in [`TODO.md`](../../TODO.md).
"Pick one approach and call it good" is **not acceptable**.

> "Laziness won't be tolerated." — project owner

## Why this is structured the way it is

The chip is a novelty. The *research* is meant to be useful for far
more serious work — it is a public demonstration of what
exhaustive AI-assisted engineering research looks like at its best.
A poor job here is not just a poor business card; it undermines the
broader claim that AI is a useful and powerful tool for engineering.

Every researcher should hold themselves to the standard of "this
report could plausibly be cited by a future mission-critical project."

## The six stages

```
        ┌────────────────────────┐
        │ Stage 1: Expansive     │
        │ surveys (parallel,     │
        │ multi-angle)           │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │ Stage 2: First-        │
        │ principles & gap       │
        │ analysis               │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │ Stage 3: Synthesis     │
        │ → 3–5 viable options   │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │ Stage 4: Deep dives    │
        │ on shortlisted options │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │ Stage 5: Parallel      │
        │ implementation         │
        │ attempts               │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │ Stage 6: Compare       │
        │ results vs research    │
        └────────────────────────┘
```

### Stage 1 — Expansive survey

For each item in `TODO.md`, multiple researchers work **in parallel**
from **different angles** to map the entire solution space:

- What approaches are currently used in commercial / industrial silicon?
- What approaches are reported in the academic / research literature?
- What approaches have been *tried and found lacking* — and under what
  exact conditions? Our requirements may differ; an approach
  abandoned for cellphones at 1 ppm accuracy might be perfect for our
  ±20 % twinkle clock.
- What are the simplest "dumb" approaches and what are the most
  sophisticated ones? Both ends of the spectrum must be represented.

**Parallel angles for Stage 1.** Each item gets at least two
independent Stage-1 researchers, each working a different angle:

- `stage1-industry-survey/` — datasheets, app notes, patents,
  open-source IP cores, RTL repositories, SoC reference designs.
- `stage1-academic-survey/` — peer-reviewed papers, conference
  proceedings (ISSCC, VLSI Symposium, CICC, A-SSCC, RFIC, IMS,
  Solid-State Circuits Conference, JSSC, IEEE Transactions on
  Circuits and Systems, etc.), theses, technical reports.
- `stage1-first-principles/` — written *without* surveying prior
  art (or while ignoring it as much as possible). Reasons from
  physics, information theory, and the GF180MCU PDK constraints to
  derive what *should* be possible. This is the deliberate
  red-team-from-scratch perspective.

**A red flag.** If two parallel Stage-1 reports come back too
similar — same references, same architecture preferences, same
omissions — that means at least one of them was lazy. Both go back to
the field.

### Stage 2 — First-principles & gap analysis

After Stage 1 reports are in, a Stage-2 agent reads all of them and
asks:

1. What approaches do **all** Stage-1 reports cover?
2. What approaches does **only one** Stage-1 report cover? (Possibly
   under-explored.)
3. What approaches do **none** of the Stage-1 reports cover but that
   physics, the PDK, or the requirements would seem to permit?
4. Where do the reports' numbers contradict each other? Resolve.
5. Where do the reports' numbers look *too good to be true*?
   Apply Carnot/Shannon/Friis/etc. limits and re-verify.
6. Where could our requirements *relax* a constraint that the prior
   art treats as binding (e.g. "we don't need 1 ppm — we need
   ±20 %"; "we don't need fully duplex — we need TX-only")?

Output: `stage2-synthesis/gap-analysis.md` plus any new candidate
approaches identified.

### Stage 3 — Synthesis & shortlisting

A Stage-3 agent (often a different one from Stage 2) consolidates all
the surveyed approaches and the new candidates from Stage 2 into a
**comprehensive comparison matrix**, scored against the project's
actual requirements (not the requirements of prior-art's original
problem domain).

The deliverable is `stage2-synthesis/option-comparison.md`, which:

- Lists every approach found, in a single comparison table.
- Justifies, in writing, the elimination of every approach that didn't
  make the shortlist. **No approach is silently dropped.**
- Names the 3–5 shortlisted approaches with explicit reasoning.
- Identifies what each shortlisted option needs in Stage 4 to be
  evaluated more deeply.

### Stage 4 — Deep dives

Fresh agents (one per shortlisted option per item) take a single
candidate approach and produce a deep-dive report covering:

- Detailed architecture, block-by-block.
- Sized-up sub-block specs (impedances, gains, noise, areas).
- Process / PVT / temperature corner expectations.
- Failure modes and mitigations.
- Cost in mm² of die area, mW of power, weeks of design effort.
- Replication: cite at least one published silicon implementation,
  with measured results, that backs the proposed numbers. If no such
  prior art exists, say so explicitly and explain how risk will be
  managed.

Output: `stage3-deep-dives/<option-name>.md`.

### Stage 5 — Parallel implementation attempts

Hands-on work: schematics, RTL, layout sketches, simulator runs.
Multiple options proceed in parallel where feasible. **Both
positive and negative results are committed.** A failed approach is
just as informative as a successful one and **must be recorded**.

### Stage 6 — Comparison vs research

After Stage 5, every implementation is compared back to the predictions
in its Stage-4 deep-dive report. Discrepancies are written up — those
are the most valuable artefacts of the whole project, because they
show where the research process under- or over-estimated reality.

## Cross-cutting rules (binding on every researcher)

### Reference verification

- Every reference cited **must be checked to actually exist and be
  accessible** at the URL / DOI / archive given.
- If a paper is paywalled, this is recorded and an open-access
  alternative or pre-print is sought.
- Every cited reference is **mirrored locally** under
  `references-cache/` (PDFs of papers, snapshots of webpages, copies
  of datasheets). If a reference cannot be mirrored due to
  copyright, that is noted explicitly and the SHA-256 of the
  authoritative source URL's response is recorded.
- **Reviewers verify that the local cached copy matches the original
  source.** A mismatch is a serious finding and must be raised.

### Negative results

A research log is not a marketing brochure. Approaches that *don't*
work, or that were tried by others and abandoned, are *required*
content. Each negative result must include:

1. What was tried.
2. What happened.
3. Under what exact conditions (process, frequency, power budget,
   temperature, etc.).
4. Whether the failure mode applies to *our* requirements or only to
   the original use case.

### First-principles sanity checks

When a number looks too good to be true, **stop and check the
physics**:

- Power: does the harvested-power claim violate Friis / Faraday /
  Carnot?
- Bandwidth: does the data-rate claim violate Shannon at the stated
  SNR?
- Capacitance: does the on-die µF claim require unphysical area at
  the PDK's known cap density?
- Q: does the on-die LC tank claim require a Q above what's plausible
  for an on-die inductor at the stated frequency and node?

When a number is plausible *only* if some specific condition holds,
state that condition explicitly.

### Justification

Every decision (including "we eliminated approach X") is justified
in writing. Justifications cite either:

- A primary source (paper, datasheet, measurement);
- A first-principles calculation (with the math shown);
- An explicit appeal to the project's specific requirements, with
  reasoning.

"It just seemed worse" is not a justification.

### Commits

> "Anything which isn't committed to this repository does not
> exist." — project owner

- Researchers write to files. **Researchers do not commit.** The
  orchestrating agent (the parent) commits research products
  incrementally, ideally one commit per agent's output.
- Commit messages identify the item, stage, agent angle, and
  finding category.
- Reviews are committed too — including when a reviewer finds the
  researcher was lazy and demands a redo.
- Both positive and negative findings are committed.

### Concurrent review

Reviewer agents run **continuously, not just at the end**. Their
job:

- Read the in-progress research files.
- Cross-check claims against the cited sources.
- Verify every reference URL / DOI exists and is accessible.
- Verify every cached local copy matches the upstream source.
- Push back on laziness: "you cited two RC oscillators and called it
  done — where are the LC, ring, relaxation, and self-biased
  variants?"
- Push back on premature narrowing: "you've spent 80 % of this
  report on one approach; redo with even coverage."
- File written reviews under each item's `reviews/` subdirectory.

### Iteration

Researchers are sent back into the field as many times as needed.
"Done" is when the reviewer signs off, not when the researcher
declares completion.

## Standard report structure

Every Stage-1 / Stage-2 / Stage-4 report follows the layout in
[`TEMPLATE.md`](TEMPLATE.md). Reports that don't follow the template
get sent back without further review.

## Naming conventions

```
docs/research/
├── METHODOLOGY.md            ← this file
├── TEMPLATE.md               ← report template
├── INDEX.md                  ← status tracker, kept up to date
├── <item>/
│   ├── README.md             ← per-item brief and status
│   ├── stage1-industry-survey/
│   │   ├── report.md         ← main findings
│   │   ├── components.md     ← needed sub-blocks
│   │   ├── solutions.md      ← architectures / topologies surveyed
│   │   ├── references.md     ← annotated bibliography
│   │   └── open-questions.md ← what's still unknown
│   ├── stage1-academic-survey/    ← same structure
│   ├── stage1-first-principles/   ← same structure
│   ├── stage2-synthesis/
│   │   ├── gap-analysis.md
│   │   └── option-comparison.md
│   ├── stage3-deep-dives/
│   │   └── <option>.md            ← one file per shortlisted option
│   ├── references-cache/
│   │   └── <citation-id>/         ← mirrored sources, organised by ID
│   └── reviews/
│       └── <reviewer>-<date>.md   ← review reports
```

Items are named `<letter>-<short-name>`, matching the labels in
`TODO.md`.

## Definition of done (per item)

An item is "research-complete" when:

- [ ] At least three Stage-1 surveys (industry, academic,
      first-principles) exist and have been signed off by a
      reviewer.
- [ ] A Stage-2 gap-analysis report exists and has resolved every
      contradiction between the Stage-1 surveys.
- [ ] A Stage-3 option-comparison report exists, names 3–5
      shortlisted options, and justifies the elimination of every
      approach that didn't make the shortlist.
- [ ] At least one Stage-4 deep dive exists per shortlisted option,
      each independently reviewed.
- [ ] Every cited reference has been verified to exist, mirrored
      locally where possible, and the local mirror checked against
      the source by a reviewer.
- [ ] Every numerical claim has either been independently
      reproduced from the cited source or recalculated from first
      principles.
- [ ] A summary in `INDEX.md` reflects the current state.

A separate "implementation-ready" gate (Stages 5–6) follows, but is
out of scope for the initial research pass.
