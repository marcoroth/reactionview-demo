## ReActionView demos

A Rails application where every page is rendered by [Herb](https://github.com/marcoroth/herb) and
[ReActionView](https://github.com/marcoroth/reactionview). Each demo is plain ERB with a few states declared at the top of the template. There is no component framework and no client-side template language, so what the browser updates is the same markup the server rendered.

### The demos

#### Apps

| Page | What it shows |
| --- | --- |
| [`/chat`](app/views/chat/show.html.erb) | Optimistic messages, live search, filters, editing, bulk selection |
| [`/music`](app/views/music/show.html.erb) | An album library with an expanding detail row and a now playing bar |
| [`/dashboard`](app/views/dashboard/show.html.erb) | Parallel scoped tiles and a polling clock |

#### Slots and state

| Page | What it shows |
| --- | --- |
| [`/status`](app/views/status/show.html.erb) | A live status board, every value re-read from the server in place |
| [`/activity`](app/views/activity/show.html.erb) | A filterable team feed where the server renders every branch |
| [`/cascade`](app/views/cascade/show.html.erb) | Continent, country and state selects driven by bound values |
| [`/deferred`](app/views/deferred/show.html.erb) | Async and lazy blocks that load after the page |

#### UI patterns

| Page | What it shows |
| --- | --- |
| [`/tooltips`](app/views/tooltips/show.html.erb) | Instant client tooltips and a server hovercard |
| [`/overlays`](app/views/overlays/show.html.erb) | A dialog, a sliding side panel and a full-screen alert |
| [`/drawers`](app/views/drawers/show.html.erb) | A sheet you drag to dismiss, with the physics in a behavior |
| [`/toasts`](app/views/toasts/show.html.erb) | A stack you can swipe away, fed from JavaScript or from a Rails flash |
| [`/components`](app/views/components/show.html.erb) | Tabs, accordion, switches, dropdown, toast, command palette, pagination |

### Running it

You need Ruby 4.0.6, Node, and Yarn Classic. The app is on Rails 8.1 with SQLite.

```bash
bundle install
yarn install
bin/rails db:prepare
bin/dev
```

`bin/dev` runs the server together with the JavaScript and CSS watchers from `Procfile.dev`. It
serves on port 3000 unless you set `PORT`.

Only the chat demo touches the database, which holds one `messages` table. Every other page reads
from plain Ruby modules in `app/models`, so `Music`, `Geo` and `Ops` are ordinary constants with no
persistence behind them.

### How it is wired

`config/initializers/reactionview.rb` is the whole setup. It intercepts ERB, turns on debug mode,
asks for client slots, and installs the two transform visitors the demos rely on. `ScopedStyle`
turns a `<style scoped>` block into selectors anchored on a generated `data-herb-scope-*`
attribute, and `SourceAttributionVisitor` stamps each element with the template it came from.

`app/javascript/application.js` starts the runtime and hands it to [moly-ui](https://github.com/marcoroth/moly),
which supplies the unstyled drawer and toaster behaviors. Those behaviors only write data
attributes and custom properties, so the look comes from `@import "moly-ui/themes/default.css"` in
`app/assets/stylesheets/application.tailwind.css`. Everything else is Tailwind v4, built by
`yarn build:css`.

Pages that need their own CSS use `<style scoped>` in the template instead of adding to the global
stylesheet.

### Dependency pins

The demo usually runs ahead of the published releases, so `herb` and `reactionview` are pulled from
their `main` branches in the `Gemfile`, and the npm packages are pinned to
[pkg.pr.new](https://pkg.pr.new) builds in `package.json`. Update those pins together, because the
gem and the browser client agree on a manifest format that is matched per version.
