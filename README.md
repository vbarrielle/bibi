# bibi
A simple tool for organizing a collection of papers and references

# Design

`bibi` is both a storage spec and a collection of tools to store and interact
with a set of references, stored in a latex `library.bib` file. Each reference
has a unique name (its bibtex id), and this unique name `ref_name` is used to
store additional data (pdf, notes, ...) in the paths `pdfs/ref_name.pdf` and
`notes/ref_name.md`.

It is therefore safe to modify manually any part of `library.bib` *except* the
bibtex id. In case of manual edit of the id, `bibi repair` can be used to
re-match orphan folders with orphan bibtex ids.

To add a pdf, use `bibi pdf add ref_name path_to_pdf`. If the ref name does not
exist, a new bibtex entry will be created by parsing the relevant information
from the pdf, and displaying `$(EDITOR)` to enable manual correction.

To add a reference from the contents of the clipboard, use `bibi add ref_name`.
If the clipboard content fails to parse as a valid bibtex, a temporary file will
be opened in `$EDITOR` to enable manual specification of the reference.

To edit the bibtex corresponding to a reference, use `bibi edit ref_name`. This
will load the bibtex in `$(EDITOR)`.

To takes notes (in markdown) on a reference, use `bibi notes ref_name`. The
notes file will be stored under `nots/ref_name.md`.
