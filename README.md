# HMPPS Tech Team docs

The documentation for users of the HMPPS Tech Team services.

It's built using the [GDS Tech Docs Template][tech-docs], and hosted
using [GitHub Pages][gh-pages].

## Previewing

Preview changes locally by running this command:

```bash
make preview
```

This will run a preview web server on http://localhost:4567

This is only accessible on your computer, and won't be accessible
to anyone else.

## Making changes

To make changes, create a branch and edit the appropriate Markdown
and ERB files in the `source` directory.

Every change should be reviewed in a pull request, no matter how
minor, and we've enabled [branch protection][] to enforce this.

GDS Tech Docs (and therefore this site) uses [kramdown][] for its
Markdown processing.

[kramdown]: https://kramdown.gettalong.org/syntax.html

## Composing & Ordering Pages

Every page of the site needs a `source/[page name].html.md.erb`
file.

This file lists the partials which comprise the page, in the
order in which they should appear. By convention, all such
partials are in the `source/documentation` directory.

These `source/[page name].html.md.erb` files have a 'weight' attribute
which determines the order in which they will appear. Higher weights
are further down in the list.

For more information, see the [Tech Docs Template documentation][tech-docs-multipage]
for a basic multipage site.

## Publishing changes

There is a [Github Action][] which will publish your
changes automatically, when your branch is merged into `main`

The markdown files in the `source` directory are compiled to HTML, and the
resulting files are pushed to a [second repository] from where they are
published via Github Pages.

So, you should not need to do anything else in order to update
the user guide website.

The github action is defined in `.github/workflows/publish.yml`

## Link-checking

The publishing process automatically checks both internal and external links in
the site. If you want to do the same check locally, run:

```
make check
```

## Updating the docker image

If you need to make any changes to the docker image (i.e. if you make any
changes to the Dockerfile or Gemfile), please use the github web interface to
create a new [release]. A github action will build the docker image and push
it to docker hub, tagged with the release number.

After changing the tag, you need to update the reference to the image in
`.github/workflows/publish.yml` and the `makefile`.

[branch protection]: https://help.github.com/articles/about-protected-branches/
[tech-docs-multipage]: https://tdt-documentation.london.cloudapps.digital/multipage.html#repo-folder-structure
[release]: https://github.com/ministryofjustice/hmpps-tech-docs/releases
[Github Action]: https://github.com/features/actions
[tech-docs]: https://tdt-documentation.london.cloudapps.digital/
[gh-pages]: https://pages.github.com/
[second repository]: https://github.com/ministryofjustice/hmpps-tech-docs-publish
