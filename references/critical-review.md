# Critical Review: methodology and checklist

This reference is loaded when the user asks for a critical review, peer review, or evaluation of a paper. It is based on Keshav's *How to Read a Paper* (the 5C framework and the third-pass "virtual re-implementation" mindset).

Walk through the framework below in order. The final output follows the template at the bottom.

## 5C framework

### Category

What kind of paper is this? Pick one or combine:
- **Measurement**: empirical study of an existing system or phenomenon
- **System design / artifact**: a new system, tool, prototype
- **Theoretical**: proofs, models, formal results
- **Survey / position**: synthesizing or arguing about a field
- **Hybrid**: combines the above

Failure modes: a paper that claims to be one type but is structured like another (e.g., claims a "system contribution" but the experiments are pure benchmark numbers).

### Context

Which prior works does this paper directly engage with? Which theoretical or methodological tradition? Is this a new problem, a new method on an old problem, or a new analysis of existing methods?

Checklist:
- Can you name the 2-3 most-related prior works the paper builds on?
- Does the paper acknowledge them fairly, or strawman them?
- Is the problem framing standard or novel?

### Correctness

Do the assumptions hold? Are there counter-examples? Are the theoretical premises too strong?

Checklist:
- List every load-bearing assumption (often unstated).
- Try to construct a counter-example for each.
- Check if the assumptions hold in realistic deployments, not just toy settings.
- For theoretical results: are the conditions of the theorems actually checked in the experiments?

### Contributions

What are the actual contributions, as distinct from the claimed ones?

Checklist:
- The paper's own list of contributions (usually in the introduction).
- For each: is it (a) genuinely new, (b) a known result restated, (c) an engineering optimization, or (d) primarily packaging?
- Are any major contributions buried (in an appendix, in a side experiment)?

### Clarity

Can a domain reader grasp the thrust in five minutes?

Checklist:
- Is the abstract self-contained?
- Are the figures readable without the caption? With?
- Are terms defined before use? Used consistently?
- Does the structure (sections, subsections) match the argument?

## Third-pass checklist (virtual re-implementation)

Imagine re-implementing the paper under the authors' assumptions. What would you need? What would surprise you? Contrast with what the paper actually does.

### Implicit assumptions
- Especially around generalization: "we tested on X" → "we claim it works for Y" — what bridges X and Y?
- Around scale: small-scale results extrapolated to large-scale claims?
- Around data: in-distribution evaluation extrapolated to out-of-distribution claims?
- Around fairness of comparison: did the baselines get the same compute and tuning budget?

### Experimental design red flags
- Baseline fairness: were baselines tuned with comparable effort?
- Ablation completeness: are all components ablated, or only the convenient ones?
- Seeds / runs: single run vs averaged? Variance reported?
- Significance: confidence intervals, hypothesis tests, or just point estimates?
- Cherry-picking: dataset selection, metric selection, hyperparameter selection on the test set.
- Leakage: any chance the test data influenced training or model selection?

### Missing comparisons / related work
- Obvious baselines absent?
- Prior work that would weaken the contribution if cited?
- Concurrent work that should be acknowledged?

### Claim vs evidence calibration
- Where do the claims (in abstract, introduction, conclusion) overshoot the evidence?
- Any "we show X" claims where the evidence is actually "we observed X on dataset Y"?

### Reproducibility
- Hyperparameters fully disclosed?
- Data splits, preprocessing, random seeds?
- Code / model weights released?
- Compute cost stated?

## Output template

Use these headings verbatim (in English). The bullet content under each heading should match the user's language.

```
## 5C overview
- Category: ...
- Context: ...
- Correctness: ...
- Contributions: ...
- Clarity: ...

## Implicit assumptions
1. ...
2. ...

## Method / experiment issues
1. ...
2. ...

## Missing comparisons or related work
- ...

## Reproducibility
- ...
```

Length target: 400-800 words total. If a section has nothing notable, write "Nothing of concern" rather than padding.
