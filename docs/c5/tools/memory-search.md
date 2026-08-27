---
title: Memory search
description: How C5 searches everything your agents have written, and the one-time download it needs.
order: 5
---

# Memory search

C5 keeps an index of the notes, memories and documents your agents produce, so an agent
can find what it — or another agent — wrote weeks ago without you pointing at the file.

Two kinds of search sit behind it:

- **Keyword search** finds documents containing the words you typed.
- **Semantic search** finds documents that mean the same thing, even when they use
  different words. Asking about "customer churn" can surface a note titled "why people
  cancel".

Keyword search works the moment C5 starts. Semantic search needs language models, and
those are the one thing C5 does not ship inside the download.

## The one-time model download

The models come to about **2 GB**. Bundling them would roughly quadruple the size of
every C5 download to save a fetch that happens once, so C5 gets them the first time it
starts instead.

You do not have to do anything. C5 downloads them in the background, keeps working while
they arrive, and says so in its startup log:

```
[mcp] QMD: fetching embedding, reranking, generation model(s) in the background (~2 GB, one time)
```

When they land, semantic search turns on by itself. Until then C5 tells you what is still
missing rather than reporting a fault:

```
[mcp] QMD query limited without download requirements
```

That line means C5 is running normally with keyword search, and the models have not
arrived yet. Nothing is broken.

## Where they go

Everything lives inside your C5 directory rather than scattered through your system:

```
~/.growther/qmd/
```

On Windows that is `%USERPROFILE%\.growther\qmd`.

You will find a `README.md` in there listing every model, its size, and the exact path
for your machine. It is written when C5 first starts, and C5 never overwrites your own
notes in it.

## If the machine has no internet

On a restricted or air-gapped network, fetch the models somewhere that can reach the
internet and copy them across:

1. Download all three from HuggingFace:

   - **embedding** — <https://huggingface.co/ggml-org/embeddinggemma-300M-GGUF>
   - **reranking** — <https://huggingface.co/ggml-org/Qwen3-Reranker-0.6B-Q8_0-GGUF>
   - **generation** — <https://huggingface.co/tobil/qmd-query-expansion-1.7B-gguf>

2. Rename each to the exact filename listed in `~/.growther/qmd/README.md` and put them
   in the folder that file names.

   **The name matters.** C5 finds a model by its filename. The right file under the wrong
   name is ignored, and C5 tries to download it again.

3. Restart C5. There is nothing to configure.

You do not have to take all three. Each one adds something on its own — the embedding
model alone enables semantic search.

## Fetching them yourself

To pull the models on your own schedule — before taking a laptop somewhere without
signal, say — run:

```bash
growther qmd-run pull
```

To stop C5 fetching them automatically, start it with `GROWTHER_QMD_NO_AUTO_DOWNLOAD=1`.

## Checking it

```bash
growther qmd-run doctor
```

This reports which models C5 can see and whether the search index is healthy.

## Windows on ARM

Windows on ARM has no build of the component C5 uses for semantic search. On that
platform keyword search, indexing and document access all work normally; semantic search
does not. Every other platform has the full set.
