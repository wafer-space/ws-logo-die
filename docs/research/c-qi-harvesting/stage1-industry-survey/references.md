# References (item c, Stage 1 industry-survey)

## Verification status

| ID | Citation | Verification | Cache |
|---|---|---|---|
| W2 | WPC, *Qi Power Class 0 specification v1.2.3*, full PDF | VERIFIED 2026-05-02 | `references-cache/wpc-qi-pc0-v1.2.3a/` |
| W1 | WPC, *Qi v1.3 Introduction*, January 2021 | VERIFIED 2026-05-02 | `references-cache/wpc-qi-v13-intro/` |
| D1 | TI bq51013B datasheet (SLUSC65A), September 2018 | VERIFIED 2026-05-02 | `references-cache/ti-bq51013b-ds/` |
| D2 | IDT/Renesas P9221-R datasheet | VERIFIED 2026-05-02 | `references-cache/idt-p9221-r-ds/` |
| D3 | TI bq51003 datasheet | snippet — flagged | n/a |
| D4 | TI bq51050B datasheet | VERIFIED 2026-05-02 | `references-cache/ti-bq51050b-ds/` |
| D5 | ST STWLC38 data brief | TIMEOUT — needs re-fetch | n/a |
| D6 | Infineon WLC1115 datasheet (transmitter, surveyed for context) | snippet | n/a |
| D7 | TI bq500412 transmitter datasheet | snippet only — flagged | n/a |
| W3 | Infineon AN234970 *FOD-tuning guide*, 2023-02-06 | VERIFIED 2026-05-02 | `references-cache/infineon-fod-tuning/` |
| W4 | NXP AN5075 / AN4937 wireless-charging app notes | snippets only — flagged | n/a |
| W5 | ROHM ML7630/7631 (Lapis) NFC-charging IC | snippet only | n/a |
| W6 | Würth WE-WPCC combination coils datasheet | snippet only | n/a |
| W7 | Hackaday "Qi DIY" write-up, 2019-04-11 | snippet only | n/a |
| W8 | PCH wireless-charging design guide | VERIFIED 2026-05-02 | `references-cache/pch-design-guide/` |
| W9 | Wireless Power Wiki — main page | VERIFIED 2026-05-02 | n/a |
| W10 | WPC web pages (qi-wireless-charging.net redirect) | snippet | n/a |
| W11 | Infineon WLC1115 product page | VERIFIED 2026-05-02 | n/a |
| W12 | Wireless Power Wiki — FOD page | VERIFIED 2026-05-02 | n/a |
| A1 | Lee & Mok, *IEEE TBioCAS* — active rectifier | snippet — paywalled | n/a |
| A2 | Lu & Ki, *JSSC* — adaptive delay-comp synchronous rectifier | snippet — paywalled | n/a |
| A3 | Cha *et al.*, *MDPI Energies* 2018/2021 | snippet | n/a |
| A4 | Petzel, MSc thesis, *Qi/NFC coexistence* (TU Graz, 2020) | VERIFIED 2026-05-02 | `references-cache/petzel-2018-thesis/` |
| O1 | Vinod S. Tanur, ATtiny13A Qi free-rider, github.com/vinodstanur/qi_wireless_receiver_attiny13 | VERIFIED 2026-05-02 | n/a |

## Notes

- **Petzel 2020 [A4]** is the single most useful document of the
  survey. Its §3.6.4 specifically quantifies what happens to an
  NFC-card IC under Qi-class fields, with closed-form formulas
  for both the over-voltage and the over-current case.
- **PDF-fetch friction.** WebFetch on PDF URLs returns binary
  that the model can't parse. In this pass we cached the priority
  PDFs locally and ran `pdftotext` on each. Future researchers
  should use the cached `.txt` extracts.
- **Apple MagSafe spec proper is members-only** (relevant to
  Qi 2 MPP-mode authentication). Not surveyed.
