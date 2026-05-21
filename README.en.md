# paper-reading

> Single-paper reading assistant — a Claude Code Skill
>
> 📖 [中文版](./README.md)

Drop any paper into Claude (paste the text, read a PDF, fetch a URL — any of these), then ask in plain language. The skill activates automatically and responds in one of four modes: **quick summary / Q&A / term & formula explanation / critical review**. No commands to memorize, no learning curve.

## Features

- **Strong grounding**: every factual claim cites a location in the paper (section / paragraph / figure / table). If something isn't in the paper, the skill says so explicitly — no hallucinated facts.
- **No invented citations**: never fabricates references or author names that don't appear in the paper.
- **Language-matching**: ask in English, get English; ask in Chinese, get Chinese.
- **Lazy loading**: lightweight modes run from the main file; the critical-review checklist (5C + third-pass methodology from Keshav) is only loaded when you actually request a critical review — so daily use stays fast.
- **Minimal surface**: pure semantic triggering, no slash commands.
- **No side effects**: conversation output only; never writes files.

## Installation

### Option 1: Use `npx skills` (easiest)

```bash
npx skills add CUTEPKQ/paper-reading -a claude-code -g
```

> ⚠️ Known issue [vercel-labs/skills#851](https://github.com/vercel-labs/skills/issues/851): `npx skills` sometimes installs to `~/.agents/skills/` without creating the symlink at `~/.claude/skills/`, so Claude Code can't see it. Patch manually:
>
> ```bash
> ln -s ~/.agents/skills/paper-reading ~/.claude/skills/paper-reading
> ```

### Option 2: Clone directly into the skills directory

```bash
git clone https://github.com/CUTEPKQ/paper-reading.git ~/.claude/skills/paper-reading
```

### Option 3: Clone anywhere + symlink (recommended if you want to track upstream)

```bash
git clone https://github.com/CUTEPKQ/paper-reading.git ~/code/paper-reading
cd ~/code/paper-reading && ./install.sh
```

`install.sh` symlinks the repo to `~/.claude/skills/paper-reading`. Future `git pull`s take effect immediately.

### Verify the install

Start a new Claude Code session and ask:

```
List available skills
```

You should see `paper-reading` in the list.

## Recommended companion: Marginalia

[Marginalia](https://github.com/chenhaoqcdyq/marginalia-releases) is a macOS desktop app — read a PDF on the left, an embedded Claude Code terminal on the right. Text you highlight in the PDF, the full paper, and the conversation history for each paper are all auto-injected into Claude's context.

**A perfect pairing with this skill**:
- **Marginalia** handles "getting the paper into Claude's context" — open a PDF and ask, no copy-paste, no manual `Read`
- **paper-reading** handles "actually understanding, answering, evaluating, explaining" once the paper is there

Workflow: open a paper in Marginalia → say "summarize" or "5C analysis" in the right-side terminal → the skill auto-triggers and grounds its answer in §3.2 / equation 4 directly.

## Usage

**Prerequisite**: the paper's content must be in the conversation context. Common ways:

- **Use [Marginalia](https://github.com/chenhaoqcdyq/marginalia-releases) (smoothest)**: open a PDF and the content is auto-injected; highlighted selections track automatically
- Paste the paper text directly
- Have Claude `Read` a local PDF
- Have Claude `WebFetch` a URL (arXiv link, HTML paper, etc.)

**Then just ask in plain language** — the skill auto-selects a mode:

| What you want | How to ask (examples) |
|---|---|
| A summary | "summarize this", "TL;DR", "what is this paper about", "give me a one-liner" |
| A specific question | "how does this method solve X", "what dataset did they use", "why this baseline" |
| Explain a term/formula | "what does equation 3 mean", "what is attention", "how does this algorithm work" |
| Critical review | "evaluate this paper", "5C analysis", "peer review this", "what's wrong with it" |

## The Four Modes

### 1. Quick Summary

Default: a structured 5-point short summary (~150-250 words):
- **Problem**: what the paper sets out to solve
- **Method**: the core technical approach
- **Key insight**: the most important idea
- **Results**: main empirical data points
- **Limitations**: limits the authors acknowledge, or that are obvious

Say "one sentence" → compressed to 1-2 sentences. Say "go deeper" → expanded to 400-600 words.

### 2. Q&A

Direct answers about the paper's content. Every factual claim cites a paper location ("§3.2 says…", "Table 2 shows…"). If the paper doesn't discuss something, the skill says "the paper doesn't discuss this" rather than backfilling with general knowledge.

### 3. Term / Formula / Algorithm Explanation

Three-part structure:
1. **In the paper's context**: what this concept refers to here (ground it first)
2. **In general**: the standard meaning (background — skipped if you already know it)
3. **Analogy / minimal example**: make it click

Formulas: break down each symbol → physical/intuitive meaning → minimal numeric example.

### 4. Critical Review (the heaviest mode)

Loads `references/critical-review.md` and walks through its full checklist, then produces:

```
## 5C overview
- Category / Context / Correctness / Contributions / Clarity

## Implicit assumptions
## Method / experiment issues
## Missing comparisons or related work
## Reproducibility
```

Typically 400-800 words. Based on the 5C framework + the third-pass "virtual re-implementation" mindset from [S. Keshav, *How to Read a Paper*](https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf).

## Design Philosophy

1. **Lazy loading**: lightweight modes inline in the main file; heavy methodology in `references/`, loaded on demand. Fast for everyday use, thorough when it matters.
2. **Strong grounding**: every principle reinforces "don't make things up, don't invent citations, always traceable" — the key anti-hallucination mechanism for paper reading.
3. **Minimal surface**: pure semantic triggering, no commands. Input is prepared by the user or other tools; the skill focuses on one thing — understanding and explaining.

## File Structure

```
paper-reading/
├── SKILL.md                       # main file: YAML frontmatter + core principles + four modes
└── references/
    └── critical-review.md         # critical review methodology (5C + third-pass checklist + output template)
```

## Explicit Non-Goals (YAGNI)

- No PDF parsing / no URL fetching / no arXiv scraping (Claude's built-in tools handle this)
- No literature surveys, cross-paper comparison, or citation graph analysis
- No integration with any notes system
- No slash commands
- No persistence of any output

## Acknowledgments

The critical review methodology adapts the 5C framework and three-pass approach from [S. Keshav, *How to Read a Paper*](https://web.stanford.edu/class/ee384m/Handouts/HowtoReadPaper.pdf).

## License

[MIT](./LICENSE)
