---
name: memory-daydream
description: Background consolidation pass over the AFFiNE "AGENTS" memory. Connects related notes, triages the Inbox, fills shallow notes, and logs every change in the "DAYDREAM" workspace. Meant to run in an unattended loop, started by the user. Do not use it during normal work.
disable-model-invocation: true
---

# Daydreaming

You are a gardener, not an author. You tidy and connect the memory in the AFFiNE workspace `AGENTS` (id `2773d076-299c-4781-a101-5851fc7eeffa`) so that later sessions find more, faster. You run unattended and cheaply. Follow `memory-read` for reading and `memory-write` for the format of notes and links; this skill only adds the rules for running alone.

The log workspace is `DAYDREAM`. Find its id with `list_workspaces`. If it does not exist, or the `mcp@` account cannot see it, stop and report that. Do not create workspaces.

## Budget

- One run does at most 10 changes and reads at most 25 documents. Then stop.
- Look at metadata first: `list_workspace_tree`, `get_orphan_docs`, `list_docs`, `list_tags`. Read a document only when the metadata says it needs work.
- Start from where the last run stopped: read the `State` note in `DAYDREAM`. Update it at the end with the date and where you stopped.
- Nothing to do is a valid result. Log it in one line and stop.

## Work, in this order

1. Inbox: for each note, check the claim against its source. If it holds, move it under the right hub with `move_doc`, set its status, add it to the hub. If it does not hold or cannot be checked, mark it `unverified` and leave it.
2. Orphans: `get_orphan_docs`. Attach each to the hub where it belongs, or link it from a related note.
3. Missing links: for notes that share a project, tag or key terms but do not link to each other, add native links in `Related`. Add only links you can justify in one sentence.
4. Shallow notes: a note with no `Related`, no `Source`, or a one-line body, flagged `needs-research`. Research it only from primary sources (official docs, the repository, the standard). Add what you found with the URL and the date. If you find nothing solid, say so in the note and move on.
5. Synthesis: when three or more notes point at one pattern, create one `synthesis` note that names the pattern and links the evidence. `Source: daydream`, `Status: unverified`.
6. Staleness: a note whose `Updated` is old and that names a file, version or URL you can cheaply check. If it is wrong, mark it `stale` and link to the correction if one exists.
7. Tags: `list_tags` and `list_docs_by_tag` first, bodies later. Look for (a) notes with no `type:` tag or no tags at all, (b) near-duplicate tags (`topic:db` and `topic:database`, plural and singular, hyphen variants), (c) a tag holding a single note that fits an existing broader tag, (d) a tag holding more than about 25 notes that splits into clear subtopics, (e) a note whose subject no longer matches its topic tags, (f) a `Status` that disagrees with the `status:` tag.

   Fix by retagging, one note at a time: add the canonical tag first (`add_tag_to_doc`), confirm with `list_docs_by_tag`, then remove the duplicate from that note (`remove_tag_from_doc`). Create a new tag only for a split and only when at least two notes need it. Add missing `type:`, `project:` and `topic:` tags to untagged notes after reading their header and description.

   You cannot delete or rename tags. When a tag ends up with no notes, or the right fix is a rename, write a "tag suggestion" entry in the log (old name, new name, reason, number of notes) for the user to apply, and leave it.

## Limits

- Additive only. You may add links, add notes, move notes under a hub, change `Status`, and add tags. You may remove a tag from a note only in the same step that you replace it with its canonical equivalent. You may not rewrite the text of a claim someone else wrote, and you may not touch `Profile`.
- Never delete or trash. Merging means marking the weaker note `superseded` with a link to the stronger one.
- Pass `expectedRevision` on every edit. If the revision changed, someone else wrote meanwhile: skip it, log it.
- No secrets, no guesses. A connection you cannot justify is not made.
- Do not web-search more than 5 times per run.

## The log

Every run creates one note under the `Runs` hub in `DAYDREAM`, titled `YYYY-MM-DD HH:MM run`. For each change write one entry:

- what: the action (linked, moved, retagged, flagged stale, created synthesis, researched)
- where: the changed document, as a native link
- why: the reason in one sentence, with the evidence or source
- before and after: the old and new status or link, so the change can be undone by hand

End the note with counts (read, changed, skipped) and where the run stopped. The log must be enough for the user to find out exactly what changed, when and why, without opening the changed notes.
