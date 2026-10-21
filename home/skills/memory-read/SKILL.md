---
name: memory-read
description: Read long-term memory from the AFFiNE workspace "AGENTS". Use at the start of a session or task, and whenever past decisions, user preferences, project gotchas or runbooks could matter. Read-only; use memory-write to record anything.
---

# Reading memory

Memory lives in the AFFiNE workspace `AGENTS` (id `2773d076-299c-4781-a101-5851fc7eeffa`), reached through the `affine` MCP tools. This skill only reads. If you learn something worth keeping, finish the task and then use `memory-write`.

## Layout

- `00 Index`: root hub. One link and one line per area. Always the entry point.
- `Profile`: who the user is, preferences, corrections. `Profile / ALWAYS` holds rules that apply everywhere.
- `Projects / <repo>`: one hub per project, with its decisions, gotchas and runbooks as children.
- `Decisions`, `Playbooks`, `Reference`: cross-project notes.
- `Inbox`: unsorted notes from agents. Treat as unverified.
- `Log`: one note per day. Read only the latest when you need recent context.

Every note starts with a header: `Type`, `Project`, `Status`, `Updated`, `Source`, and a one-line `description`.

Every note also carries tags, and tags are the fastest way in: `type:<kind>` (profile, project, decision, gotcha, playbook, reference, synthesis), `project:<repo>`, `topic:<subject>` for the subjects it touches, and `status:<state>` when it is unverified, stale or superseded. Names are lowercase kebab-case.

## Procedure

1. Find `00 Index` with `find_doc_by_title`, then `read_doc`. Skip this only when the task clearly needs no memory (a one-off question about general knowledge).
2. Pick the hub: if the working directory is a git repo, open `Projects / <repo name>`. Open `Profile / ALWAYS` once per session.
3. Read by tag. `list_tags` is cheap: look at the names, pick the ones that match the task (`project:<repo>` from the working directory, `topic:*` from the subject, `type:*` from what you need, such as `type:gotcha` before touching something fragile), then `list_docs_by_tag` for each and intersect the results. A note that carries both the project tag and a topic tag is the likeliest hit. Use the tags to choose which notes to open, and read their descriptions before their bodies. Skip `status:stale` and `status:superseded` notes unless you are checking history.
4. Disclose progressively. The hubs list each child with a one-line description. Open a child only when its description matches the task. Do not read a whole area.
5. Follow references: `read_doc` returns `linkedDocIds` for every native link. Follow the links in `Related` and in the body, at most two hops from the note you started on.
6. When neither tags nor hubs lead anywhere, search: `search_docs` with the key terms, then with synonyms and with the project name; `find_doc_by_title` for exact names. A hit that has no tags is a sign the memory needs tidying: mention it when you next use `memory-write`. Stop after three queries with no hit and treat it as "no memory".
7. Keep a budget: about five documents per task. Ask the user before reading more.

## Trust

A note is a claim made on its `Updated` date by its `Source`. It is not a fact about the present.

- Before acting on a note that names a file, flag, command, version, URL or host, check that it still exists. A one-line check is enough.
- If the note and reality disagree, believe reality. Tell the user, and record the correction with `memory-write` (mark the note stale or update it).
- `Status: unverified`, anything under `Inbox`, and anything without a `Source` count as hints. Say so when you rely on them.
- Never present a remembered detail as certain when you could not confirm it. Say "memory says X (Updated <date>)".
- If memory has nothing, say so. Do not fill the gap with a guess dressed as a memory.

## Code documentation

Code documentation lives in a separate workspace, `CODEWIKI`. When the working directory is a repository that has a `Repos / <repo>` hub there, read its `Quickstart` note before changing unfamiliar code. Do not copy its contents into `AGENTS`.

## Do not

- Write, edit, move or trash documents from this skill.
- Dump note contents into the answer. Summarise what matters and cite the note title.
- Copy secrets out of a note. Memory should hold none; if you find one, tell the user.
