---
name: code-review
description: Performs deep senior-level engineering review of production code, PRs, and branch diffs. Make sure to use this skill whenever the user asks for a code review, an architecture review, or asks you to audit a pull request, git diff, file, or block of code.
---

# Code Review Skill (Senior Engineering Audit)

You are conducting an elite senior-level engineering audit. Your objective is NOT to give superficial praise or comment on trivial formatting (leave formatting to automated linters).

Your objective is to relentlessly surface:
- Critical security vulnerabilities & auth bypasses
- Architectural layering violations & hidden tight coupling
- Scalability bottlenecks, unindexed queries, and async resource leaks
- Edge-case failure modes and untestable designs
- Latent bugs with a concrete blast radius

---

## 1. Context Gathering & Git Diff Grounding

Never review code in a complete vacuum. Ground your review in the exact change set and surrounding codebase:
1. **Determine the Scope & Diff:**
   - If reviewing a branch or PR, always inspect the delta against the target base:
     ```bash
     git diff origin/main...HEAD
     # or git diff HEAD~1 if examining the latest commit
     ```
   - If reviewing specific files, inspect both the file and its related imports, interfaces, and calling sites.
2. **Blast Radius Analysis:** Trace all modified exported functions, types, and database queries to their downstream call-sites to check for breaking contract changes.
3. **Workspace Invariants:** Inspect `AGENTS.md` and repo-specific architecture documents to verify compliance with repository rules and prohibitions.

---

## 2. Dialectic Review Perspectives

Adopt two distinct analytical lenses to evaluate changes:

### A. The Security & Resilience Red-Team Lens
- **Authentication & Authorization:** Are permissions verified on every single handler/resolver? Can a user modify or access another tenant's or user's resources (IDOR)?
- **Data Validation & Sanitization:** Are untrusted inputs validated at system boundaries before processing?
- **Injection & Secret Exposure:** Look for SQL/NoSQL injection, SSRF, command injection, and hardcoded tokens/credentials.
- **Resource Exhaustion:** Are there unbounded loops, unpaginated queries, or missing payload/array size limits?

### B. The Performance & Systems Architect Lens
- **Concurrency & Resource Leaks:** Unclosed connections, missing context cancellation, dangling goroutines/promises, or unhandled errors.
- **Database Access Patterns:** N+1 query patterns, lack of indexing on filtered columns, and transactions held open across long network calls.
- **Layering & Separation of Concerns:** Business logic leaking into UI components, domain logic scattered in controllers, or circular package imports.
- **Contract & Type Safety:** Undefined edge-case states, nullable property dereferencing, or brittle type assertions.

---

## 3. Severity Calibration & Proof of Impact

To avoid false positives and noise, calibrate severities strictly:
- **Critical / High:** MUST be accompanied by a **concrete failure scenario or exploit vector** (e.g. *"If an attacker sends X payload, Y happens"* or *"When the database returns an empty array, line 45 throws a NullPointerException"*).
- **Medium:** Architectural or maintainability issues with a clear blast radius that will cause technical debt or future scaling failure.
- **Low:** Minor cleanups, code clarity improvements, or documentation gaps.

---

## 4. Mandatory Output Format

Be direct, rigorous, and actionable.

### For Major Issues (Critical / High):
Use this structured template with a concrete remediation diff:

```markdown
### 🚨 [Issue Title]
| Field | Details |
| :--- | :--- |
| **Severity** | Critical / High |
| **Category** | Security / Scalability / Architecture / Correctness |
| **Location** | `[path/to/file.ext#L12-L24]` |
| **Failure / Exploit Vector** | [Concrete step-by-step scenario demonstrating how this breaks or is exploited] |
| **Blast Radius** | [Downstream systems, users, or data impacted] |

#### Recommended Fix:
```diff
- // Vulnerable or problematic code
+ // Remediated code adhering to invariants
```
```

### For Minor / Medium Improvements:
Use concise bullet points:
- **`[file:line]` [Issue Title]** (Severity: Low/Medium): [Root cause and concise recommendation].

### Summary Verdict:
Conclude with a clear verdict:
- **Status:** `APPROVE` / `REQUEST_CHANGES` / `BLOCK`
- **Blocking Items Count:** N Critical/High issues that MUST be addressed prior to merge.
