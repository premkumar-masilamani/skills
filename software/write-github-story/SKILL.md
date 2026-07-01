---
name: write-github-story
description: Interview the user to refine a feature idea, probe technical layers, review the codebase, and create a GitHub issue. Make sure to use this skill whenever the user mentions writing a story, creating a GitHub issue, planning a feature, writing a spec, or taking a feature from idea to ticket.
---

# Write Story Skill

This skill guides the agent in interviewing the user about a feature idea, analyzing the technical implications across all layers of the stack, and automatically publishing a fully scoped specification as a GitHub issue.

## Usage Guidelines

### 1. Relentless Requirement Gathering (The Interview Phase)
- Ask the user about their feature idea.
- Ask questions **one at a time** to walk down the decision tree and resolve ambiguities.
- For each question, provide your recommended answer or technical suggestion.
- Proactively probe the following technical layers:
  - **Frontend UI/UX:** User interactions, UI states, component changes, styling, and responsive behaviors.
  - **Backend / APIs:** New or modified endpoints, request/response payloads, parameter validation, and rate-limiting.
  - **Database Schema Changes:** New tables, fields, relationships, constraints, indexes, or updates to existing schemas.
  - **One-Time Data Updates:** Data migrations, seeding, or database backfills required for existing production records.
  - **Security & Permissions:** Authorization rules, authentication changes, or access control level policies.

### 2. Codebase Review
- During the interview, explore the codebase to understand the current architecture and identify files, packages, or services that will be affected.
- Keep the codebase exploration details in mind to inform your questions and recommendations.

### 3. GitHub Issue Creation
- Once the specification is scoped and agreed upon, compile the spec into a clean markdown document.
- **Do not** write a file-by-file implementation plan. Instead, focus on high-level functional and technical scoping.
- ALWAYS use this exact template for the specification:
```markdown
# [Feature Name]

## Overview / User Story
[Clean summary of what is being built and why]

## Acceptance Criteria
- [ ] [Clear, testable bullet point describing the target behavior]
- [ ] [Another testable criterion]

## Technical Specification
### Frontend
[UI/UX, components, state changes]

### Backend
[API endpoints, payloads, logic]

### Database & Migrations
[Schema changes, data seeding, backfills]

### Security
[Permissions, auth rules]
```

- Use the GitHub CLI (`gh`) to create the issue in the current repository:
  ```bash
  gh issue create --title "[Feature] <Short Description>" --body-file <spec-file-path>
  ```
  *(If `gh` is not authenticated, output the issue body in markdown for the user to copy, or ask for credentials).*
