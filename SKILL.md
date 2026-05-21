---
name: paper-reading
description: Single-paper reading assistant. Use when a research paper's content is already in the conversation context (pasted text, a PDF that was read, fetched URL content, etc.) and the user asks to summarize it, ask questions about it, explain terms or formulas from it, or critically review it. Trigger keywords include summarize this paper, TL;DR, what is this paper about, how does this method work, what does this formula mean, what are the contributions, what are the problems, 5C, critical reading, peer review.
---

# Paper Reading

Assist with reading a single research paper: summary, Q&A, term/formula explanation, and critical review.

## Preconditions

The paper's content must already be in the conversation context (pasted text, a PDF that was Read, WebFetched URL content, etc.). If it isn't, stop and ask the user to provide it — do NOT pretend to have read it.

## Core principles (apply to every mode)

- **Match the user's language**: if they ask in Chinese, answer in Chinese; in English, answer in English. The instructions in this skill are in English, but the response language follows the user.
- **Ground every claim**: every factual statement must be traceable to a specific location in the paper (section / paragraph / figure / table number). If something isn't in the paper, say so explicitly — don't fill gaps with outside knowledge.
- **Don't invent citations**: never fabricate references or author names that don't appear in the paper.
- **Default to brief**: short answers by default; expand only when the user asks.
- **Don't write files**: conversation output only.

## Four modes

### 1. Quick summary

Triggers: user asks to "summarize", "TL;DR", "what is this paper about", "give me a one-liner".

Default: a structured 5-point short summary (~150-250 words in the response language):
- **Problem**: what the paper sets out to solve
- **Method**: the core technical approach
- **Key insight**: the most important idea or contribution
- **Results**: the main empirical data points
- **Limitations**: limits the authors acknowledge, or that are obvious

If the user says "one sentence" → compress to 1-2 sentences; "go deeper" → expand to ~400-600 words.

Do NOT inject your own evaluation here (evaluation belongs to mode 4).

### 2. Q&A

Triggers: the user asks a specific question about the paper's content.

- Answer directly, no preamble.
- Cite the paper location for every factual claim ("§3.2 says...", "Table 2 shows...").
- If the paper doesn't discuss it, say "the paper doesn't discuss this" — do not backfill with general knowledge.
- Don't expand to unrelated topics.

### 3. Term / formula / algorithm / passage explanation

Triggers: user asks "what does X mean", "what does this formula mean", "how does this algorithm work", "explain this part / section / passage", "用中文解释这部分", "这段在讲什么", "翻译解释".

Distinguish two sub-cases. **When in doubt, default to the lighter sub-case (b).**

#### (a) Single concept / term / formula / algorithm

Three-part structure:
1. **In the paper's context**: what this concept refers to here (ground it first).
2. **In general**: the standard meaning (background — skip if the user already knows it).
3. **Analogy / minimal example**: make it click.

For formulas specifically: break down each symbol, explain the physical/intuitive meaning, give a minimal numeric example.

#### (b) Passage / section / paragraph (e.g. "explain this part", "用中文解释这部分")

Default: a **short paraphrase** — roughly 1-3 sentences per paragraph, ≤ 200 words total, surfacing the 2-3 most non-obvious terms inline if needed.

DO NOT:
- Quote the original passage sentence by sentence with a "解读" for each
- Reproduce the original text verbatim
- Apply the three-part structure from (a) to every sentence

Sentence-by-sentence (逐句) treatment **only** when the user explicitly asks ("逐句解释", "逐句", "sentence by sentence", "go through it line by line").

If the user wants more after the paraphrase, they will say so — always default to the lightest version.

### 4. Critical review

Triggers: user says "evaluate", "review", "what's wrong with this", "how is this paper", "5C", "three-pass", "critical review".

**This is the heaviest mode.** Load `references/critical-review.md` and walk through its checklist item by item.

Output structure:
- **5C overview**: Category / Context / Correctness / Contributions / Clarity, one or two sentences each
- **Implicit assumptions**: assumptions the argument relies on but the authors don't state
- **Method/experiment issues**: baseline choice, ablation completeness, statistical significance, dataset bias, etc.
- **Missing related work or comparisons**: prior work the paper should cite or compare against but doesn't
- **Reproducibility**: code/data availability, hyperparameter disclosure, compute cost

Length typically 400-800 words.
