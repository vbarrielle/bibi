# bibi
A simple tool for organizing a collection of papers and references

# Design

`bibi` is both a storage spec and a collection of tools to store and interact
with a set of references, stored in a latex `library.bib` file. Each reference
has a unique name (its bibtex id), and this unique name `ref_name` is used to
store additional data (pdf, notes, ...) in the folder `data/ref_name`.

It is therefore safe to modify manually any part of `library.bib` *except* the
bibtex id. In case of manual edit of the id, `bibi repair` can be used to
re-match orphan folders with orphan bibtex ids.

To add a pdf, use `bibi pdf ref_name path_to_pdf`.

To add a reference from the contents of the clipboard, use `bibi add ref_name`.

To edit the bibtex corresponding to a reference, use `bibi edit ref_name`.

To takes notes (in markdown) on a reference, use `bibi notes ref_name`. The
notes file will be stored under `data/ref_name/notes.md`.
