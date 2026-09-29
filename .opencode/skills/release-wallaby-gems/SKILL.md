---
name: release-wallaby-gems
description: Use when bumping a Wallaby gem version or preparing a release, including editing version.rb, gemspec dependency constraints, and CHANGELOG.md. Trigger on "release", "bump version", "cut a release", "version.rb".
---

# Releasing Wallaby gems

Five independently versioned gems live in this monorepo. Version bumps must
respect the dependency direction, because a downstream gem's gemspec constrains
an upstream gem's version.

## Dependency order (bump low → high)

```
wallaby-view  →  wallaby-core  →  wallaby-active_record  →  wallaby
wallaby-cop   (standalone; nothing depends on it, it depends on gitlab-styles)
```

Constraints that must stay in sync after a bump:

- `wallaby-core` depends on `wallaby-view '~> 0.1.2'`.
- `wallaby-active_record` depends on `wallaby-core '~> 0.3.1'`.
- `wallaby` depends on `wallaby-active_record '~> 0.3.0'` and unpinned
  `wallaby-core`. Its gemspec comment says this determines `wallaby-core`'s
  version.

## Version constants

| Gem | File | Constant |
| --- | --- | --- |
| `wallaby` | `wallaby/lib/wallaby/version.rb` | `Wallaby::VERSION` |
| `wallaby-core` | `wallaby-core/lib/wallaby/core/version.rb` | `Wallaby::Core::VERSION` |
| `wallaby-active_record` | `wallaby-active_record/lib/wallaby/active_record/version.rb` | `Wallaby::ActiveRecordGem::VERSION` |
| `wallaby-view` | `wallaby-view/lib/wallaby/view/version.rb` | `Wallaby::View::VERSION` |
| `wallaby-cop` | `wallaby-cop/lib/wallaby-cop.rb` | `Wallaby::Cop::VERSION` |

`wallaby-cop` has no `version.rb`; its constant lives in the gem entry file.

## Steps

1. Ask which gem(s) and what SemVer bump (major / minor / patch). Do not guess.
   These gems have real users.
2. Update the constant and, if the gem constrains another, the gemspec
   constraint. Keep the constraint consistent with the new upstream version.
3. Move the relevant `## [Unreleased]` entries in that gem's `CHANGELOG.md`
   under a new version heading. Keep a Changelog + SemVer. The heading style is
   `## [X.Y.Z](https://github.com/wallaby-rails/wallaby/releases/tag/X.Y.Z) - YYYY-MM-DD`.
4. Do not commit `Gemfile.lock` — it is gitignored.
5. Run `bundle exec rubocop` on the touched files before finishing.

## Notes

- Bumping a lower gem may require bumping its dependents even if their code did
  not change, to keep the constraint resolvable.
- If the release changes behavior, update the gem's `README.md` too.
