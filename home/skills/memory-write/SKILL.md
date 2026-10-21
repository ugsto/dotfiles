---
name: memory-write
description: Write or update long-term memory in the AFFiNE workspace "AGENTS". Use when something durable was learned that future sessions need and that is not derivable from code or git history, such as a user preference or correction, a decision and its reason, a gotcha, a runbook, or a pointer to an external resource.
---

# Writing memory

Memory lives in the AFFiNE workspace `AGENTS` (id `2773d076-299c-4781-a101-5851fc7eeffa`). Read `memory-read` first if you have not: it describes the layout and how to trust notes.

## What is worth writing

Write only what is durable, will matter in a later session, and cannot be recovered from the repository, git history or the docs of a tool.

- Yes: user preferences and corrections (with the reason), decisions with their reason, gotchas that cost time, runbooks, pointers to external resources, project facts that live outside the repo.
- No: code structure, file contents, git history, the current task's progress, anything that expires today, secrets, tokens, passwords, private keys, personal data beyond what the user told you to keep.
- When the user says "remember this", save it. If it is derivable from the repo, ask what was non-obvious about it and save that.

## One note, one claim

- One fact or decision per note. The title is the claim, for example "Kanidm does not support resource indicators", not "Kanidm notes".
- Header at the top of every note, as plain paragraphs: `description` (one line, what the note says and when it matters), `Type` (profile, project, decision, gotcha, playbook, reference, synthesis), `Project`, `Status` (active, unverified, stale, superseded), `Updated` (date), `Source`.
- `Source` is mandatory and specific: "user said, session of 2026-10-20", "file path @ commit", "URL", "command and its output". A note with no source is not allowed.
- Body: the claim, the reason, and how to apply it. Keep it short. Use flat lists, because markdown import flattens nested lists.
- End with `Related`: native links to related notes (see Links).

## Before writing: search

1. `search_docs` with the key terms and with synonyms; `find_doc_by_title` with the likely title; `list_children` of the hub where it would live.
2. A note on the same claim exists: update it (`update_block`, or `append_block`), pass `expectedRevision` from `read_doc`, and refresh `Updated` and `Source`. Do not create a second note.
3. An existing note contradicts the new fact: do not overwrite silently. Set the old note `Status: superseded`, link to the new one, and state the date and the reason in both.
4. Nothing exists: create the note.

## Where it goes

- Create with `create_doc_from_markdown` and set `parentDocId` to the hub of its area or project, so it is hung in the tree. A note without a parent is a bug.
- Not sure where it belongs, or not sure it is true: create it under `Inbox` with `Status: unverified`.
- A new project: create `Projects / <repo name>` first, then add it to `00 Index`.
- Add the new note to its hub as a native link with its one-line description, so the hub stays the index.

## Tags

Tags are how a future session finds the note without knowing its title. Decide them while you write, not afterwards.

- Namespaces: `type:<kind>` (profile, project, decision, gotcha, playbook, reference, synthesis), `project:<repo>`, `topic:<subject>`, `status:<state>` (unverified, stale, superseded, needs-research). Lowercase kebab-case, singular, English. `type` and `project` repeat the header; the tag is what queries use.
- Every note gets exactly one `type:` tag, a `project:` tag for each project it concerns (none for cross-project notes), one to three `topic:` tags, and a `status:` tag whenever `Status` is not `active`. Five tags is the ceiling.
- Reuse first. Run `list_tags` before tagging and look for the same idea under another spelling (`db` or `database`, `k8s` or `kubernetes`, `auth` or `authentication`). Use the existing one, whatever its spelling, and do not add a synonym.
- Create a new tag (`create_tag`, then `add_tag_to_doc`) only when no existing tag covers the idea and it names a subject that other notes will plausibly share. A tag that would hold one note forever is noise: leave it out.
- A topic tag names a subject, not a property of this note. `topic:oauth` is a topic; `topic:important` or `topic:todo` is not.
- Keep the namespace prefix in every name. A bare tag such as `kanidm` is wrong; `topic:kanidm` is right.
- Tags move with the claim. When you set `Status: stale` or `superseded`, add the matching `status:` tag in the same step. When you update a note so its subject changes, fix its tags.
- Confirm: after tagging, `list_docs_by_tag` for one of the new tags and check that the note appears.
- Do not delete or rename tags. There is no safe tool for it; ask the user.

## Links

`[[Title]]` in markdown stays literal text, and a markdown `[text](url)` is a plain hyperlink. Neither creates a link between documents. Use a native reference: `append_block` with `type: paragraph` and `text` as a JSON delta array,

```
[{"insert": "See: "}, {"insert": " ", "attributes": {"reference": {"type": "LinkedPage", "pageId": "<docId>"}}}]
```

Get the `docId` from `find_doc_by_title` or `search_docs`. Check that the target exists before linking. After writing, `read_doc` the note and confirm `linkedDocIds` holds the target.

## Anti-hallucination rules

- Record only what you observed or were told. Do not record inferences as facts. Label an inference `Status: unverified` and say what would verify it.
- Verify against the present state first: open the file, run the command, fetch the URL. Then write what you saw, with the source.
- Quote exact names, flags, paths and error text. Never reconstruct them from memory.
- Put the date on everything. "Currently" and "now" mean nothing in a note.
- Do not invent a Source, a link or a docId. If a search finds no target, leave the link out and say so.
- Corrections from the user outrank anything in memory. Record them as soon as they happen, in one imperative sentence, under `Profile`.
- Never delete. Mark `stale` or `superseded`. Trashing is the user's decision.
- After writing, read the note back and check it says what you meant.
- Write in English, except `Profile` when the user wrote in Portuguese.

## Session log

At the end of a session in which you wrote or changed anything, append a short entry to today's `Log` note (create it under `Log` if missing): what changed, which notes (as native links), and why.
