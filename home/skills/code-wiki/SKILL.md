---
name: code-wiki
description: Document a code repository into the AFFiNE workspace "CODEWIKI" (architecture, algorithms, decisions, trade-offs), or update that documentation from a git diff. Plans first and asks before spending tokens. Started by the user, never automatically.
disable-model-invocation: true
---

# Code wiki

Turn a repository into linked, evidence-backed notes in the AFFiNE workspace `CODEWIKI`, through the `affine` MCP tools. The design follows OpenWiki: plan the smallest complete structure, one worker per page, every material statement tied to versioned evidence, and updates driven by what changed. Use `codegraph` to find and read code, because it costs far fewer tokens than reading files.

Find the workspace id with `list_workspaces`. If `CODEWIKI` is missing or `mcp@` cannot see it, stop and say so. Do not create workspaces. Follow `memory-write` for note headers, tags and native links; this skill adds the code-specific rules and replaces its parent-based placement with folders.

## Structure: folders first

Organise the workspace with AFFiNE's sidebar folders (the organize tools: `list_organize_nodes`, `create_folder`, `move_organize_node`, `add_organize_link`, `rename_folder`), one level per idea. A folder holds notes and subfolders. A note is placed with `folderId` when it is created. Do not use `parentDocId` to place these notes: one placement per note.

```
Repos/
  <repo>/
    Quickstart                  task-routing map ("to change X, read A and B")
    Manifest                    source of truth for updates
    Architecture/
      Overview                  what the group covers, with a link to each child
      <module note>
      <subsystem>/              only when a group has too many notes
        Overview
        <note>
    Workflows/
    Decisions/
    Operations/
    Integrations/
    Testing/
Concepts/
  Algorithms/
  Data structures/
  <other domains>/
```

Rules for the tree:

- Group by owned system or runtime domain, not by the repository's directory layout.
- Depth at most four below `Repos`. A folder with a single child is flattened into its parent. A folder with more than eight children is split into subfolders by theme.
- Every folder except `Repos` and `Concepts` starts with an `Overview` note: one paragraph on what the folder covers, then a native link to each child with its one-line description. Folders cannot hold text, so the overview is the index.
- Create a group only when it will hold at least two notes. No flat dump of unrelated pages at any level.
- Folder names are short noun phrases in title case, the same words every run. `Concepts` subfolders are generic domains (`Algorithms`, `Data structures`, `Concurrency`, `Storage`, `Networking`), never repository names.
- `Quickstart` and `Manifest` sit directly in the repo folder, not in a group.
- Before creating a folder, `list_organize_nodes` and reuse the existing one. Never create a second folder with the same name or a near variant.

If the organize tools are not available in this session (they are `experimental`, and the `authoring` and `core` profiles of the server omit them), stop and tell the user. Do not flatten the tree. The user can enable them by serving the MCP with the `full` profile and `AFFINE_DISABLED_GROUPS=admin,cleanup,destructive,users.write,users.auth` and `AFFINE_DISABLED_TOOLS=create_workspace_blueprint`.

Four kinds of note: `module` (what a system owns, its entrypoints and responsibilities), `algorithm` (how it works, complexity, why this variant), `decision` (a choice, the alternatives, the trade-off), `flow` (a path through several modules).

## Tags

Tag every note: `type:module`, `type:algorithm`, `type:decision` or `type:flow`; `project:<repo>`; and one to three `topic:<subject>` tags for the concepts and technologies it concerns (`topic:oauth`, `topic:sorting`). Reuse the tags `memory-write` describes, and run `list_tags` before creating one. Concept notes carry `topic:` and `type:concept` only, never a `project:` tag, so a topic tag finds both the concept and every repository note that uses it.

## Isolation rules

These keep unrelated documentation from interfering.

1. One entity per note. The note of algorithm A talks about A only. It never describes B.
2. A concept note is generic. `Quicksort` explains quicksort in general, cites primary sources, and never mentions a repository or who uses it.
3. A repo note holds only what is local: which variant, which parameters, why here. The generic part is a native link to the concept, never a copy of it.
4. Backlinks do the reverse lookup. Whoever opens `Quicksort` sees every note that links to it. Do not list users inside the concept.
5. A worker writes only its assigned page, plus its entry in the hub, plus a missing concept note. It never edits another repo note, and it never edits the text of an existing concept. If a concept is wrong or incomplete, add a `Suggestion` entry to the concept's comment thread (`create_comment`) and tell the user.
6. A comparison between two things is its own `decision` note, linking both.
7. Before creating a concept, search for it under every common spelling ("Quick sort", "quicksort", "Quicksort"). One canonical title, singular, normal capitalisation. Create a duplicate and you have broken rule 4.

## Preflight: plan, then ask

Do this before any generation, and stop for the user's answer.

1. `codegraph status` for files and symbols. Read the top-level layout, the README, the build file and the entrypoints. Run `codegraph explore` on each major area. Do not stop at directory names or one representative file, and do not inventory every file.
2. Propose the smallest complete structure as a folder tree, indented like the diagram above, with every note under its folder. For every note give its kind, title, a one-line purpose and `seedPaths` (files or symbols to start from). Seeds are starting points, not research boundaries. Folder and page titles are final once the user approves.
3. List the concepts you expect to link to, in their `Concepts` folder, and mark which already exist (`list_organize_nodes`, then search).
4. Report the size: number of notes, number of source files and symbols covered, and a rough token estimate (about 15k tokens per note as a working figure; say it is a guess). Then ask whether to proceed, whether to narrow the scope, and show the plan as a list the user can edit.
5. If the user asks for one module, document only that module. A narrow request is not permission for a broad refresh.

## Writing one note (one worker, one page)

For each page in turn:

1. Research with `codegraph explore`, `node`, `callers`, `callees`, then read only the line ranges you need. Seeds are a start; follow the code until you can explain responsibilities, entrypoints, data and control flow, invariants, persistence, security and extension points.
2. Write the note. Header as in `memory-write`, plus `Kind`, `Commit` (the commit documented) and `Repo`. Then explanation sections, a `Concepts` line with native links, and `Claims`.
3. Separate what the code shows from what you infer. Intent ("probably chosen for speed") goes under `Inferred`, labelled, never mixed into claims. Use `git log` and `git blame` messages as evidence for intent when they exist.
4. Explain, do not inventory. A note is about behaviour and reasoning, not a list of files.
5. Read the note back and compare it with its claims.

## Claims and evidence

A claim is an independently verifiable statement about the system: a responsibility, a flow, an invariant, a persistence rule, a security property, an extension boundary. Test of materiality: if it were false, would a reader misunderstand, misimplement, misoperate or unsafely change the system? Existence of a symbol is not a claim. One claim is one coherent idea, which may cite several places. Completeness beats a small claim count.

Every claim cites evidence in this form, with a line range and the commit:

`repo://<repo>/<path>#L<start>-L<end>@<short sha>`

A bare path is invalid. Verify each citation before you keep it: read those lines and confirm they support the claim. Do not cite lines you have not read. If you cannot verify a claim, drop it or move it to `Inferred`.

The body of the note and its claims must agree.

## Manifest

The `Manifest` note of `Repos / <repo>` has one line per note: title, linked doc, the `Commit` documented, the seed files and symbols, and a fingerprint of the sources it covers. Compute the fingerprint from the files the note cites, for example `git ls-tree HEAD -- <paths> | sha256sum`. Record the repository's remote URL and the indexed branch at the top.

## Update from a diff

1. Read `Manifest`. Take the oldest recorded commit as the baseline per note, not one global commit.
2. `git diff --name-only <baseline>..HEAD`, then `codegraph sync`. For each changed symbol run `codegraph impact <symbol>` to reach its dependents. A note is stale when a changed or impacted file or symbol is among its sources, or when its fingerprint differs.
3. Nothing stale and no fingerprint change: report "no update needed" and stop. No model work.
4. Preflight again: list the stale notes and the size, and ask. A change in a single file does not justify a broad refresh.
5. For each stale note, re-check every claim against the current code: confirm it, revise it, or retract it. Keep the claims that are unchanged and still verified, and do not rewrite accurate text; change only what current evidence requires. Update `Commit` and the fingerprint.
6. A deleted or renamed source marks its claims stale. Do not trash notes. Mark the note `stale` and tell the user.
7. If notes were added or removed, refresh `Quickstart`. Never delete it.
8. If the repository changed while you were working, re-check the HEAD at the end. If it moved, do not advance any commit in the manifest, and report the run as interrupted.

## Links, in order

Native links need document ids, so generate in this order:

1. Create the folders top-down, then every planned note in its folder (`folderId`) with an empty `Related`.
2. Fill the notes, one at a time.
3. Link pass: add `Related` links to the most useful conceptual and workflow neighbours, and the links to concept notes. Verify with `read_doc` that `linkedDocIds` contains each target.
4. Write `Quickstart` last, so it links only to notes that exist.
5. Check `get_orphan_docs`. Every note you created must have a parent and at least one incoming link.

## Reorganise an existing wiki

Use this when a previous run left notes loose or in the wrong place. It changes where notes live, never what they say.

1. List the notes of the repository (`list_docs`, `list_workspace_tree`, `list_organize_nodes`) and read only their titles, headers and `Kind`. Do not read bodies.
2. Propose the target folder tree, with each existing note under its folder, as in the preflight, and mark notes that have no clear home. Ask before moving anything.
3. After approval: create the missing folders, then `move_organize_node` (or `add_organize_link` for a note that has no folder yet) one note at a time. Add the `Overview` notes. Do not rename, edit or trash existing notes, except to add the `Overview`.
4. Report what moved: from, to, count. Finish with `get_orphan_docs` and list what is still loose.

## Do not

- Start generating before the user approves the plan.
- Write secrets, tokens, internal hostnames or credentials found in the code or config. Say that they exist, not what they are.
- Copy unrelated context into a note. Each note holds what its own page needs.
- Invent behaviour, a docId, a citation or a commit.
- Delete anything.
