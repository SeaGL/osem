# About this branch

Our goal is to run [upstream] OSEM without modifications to its codebase. We currently still make a few modifications in this interim branch:

- [ ] Fix access to the version history of organization-level roles [#2654](https://github.com/openSUSE/osem/pull/2654)
- [ ] Add setting to disable email notifications of comments [#3059](https://github.com/openSUSE/osem/pull/3059)
- [ ] Add surveys during CFP response [#3058](https://github.com/openSUSE/osem/pull/3058)
- [ ] Don’t automatically select a difficulty level [#3140](https://github.com/openSUSE/osem/pull/3140)
- [ ] Corrections to proposal help text [#3243](https://github.com/openSUSE/osem/pull/3243)
- [ ] Resolve inability to schedule events [#3244](https://github.com/openSUSE/osem/pull/3244)
- [ ] Restrict commercial management to organizers [`hide-commercials`](https://github.com/AndrewKvalheim/osem/tree/hide-commercials)
- [ ] Add notifications of user registrations [`982407e`](https://github.com/SeaGL/osem/commit/982407e68cf8f6726ab5bb96464b2cdf68286ec6)
- [ ] Configure deployment to Dokku [`0ff909a`](https://github.com/SeaGL/osem/commit/0ff909a5fbb6830dbaf80b2d2a120b4acd287d85)
- [ ] Work around [titusfortner/webdrivers#254](https://github.com/titusfortner/webdrivers/issues/254) [`347c929`](https://github.com/SeaGL/osem/commit/347c929973fc906994b2661752aeb1c4a1c6f33c)
- [ ] Allow disabling of account creation via environment variable [`0f9715a`](https://github.com/SeaGL/osem/commit/0f9715a659c0246f7ebff3c3d2a336e5bc58eccd)

These divergences from upstream should be seen as a to-do list, where completing an item means either solving its need in a general way upstream, or adjusting our procedures to accommodate upstream’s existing capabilities or limitations.

## Guidelines

Don’t develop on this branch. It follows upstream by regularly **rebasing** the above modifications. When a modification is no longer necessary, it will be dropped during the rebase. When there are no remaining modifications, this branch will be deleted.

[upstream]: https://github.com/openSUSE/osem
