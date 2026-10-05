# Security Policy

Wallaby autocompletes resourceful admin interfaces, so its security posture
depends heavily on how the host application wires authentication and
authorization. Before deploying a Wallaby mount, read the
[security guide](docs/security.md).

## Supported versions

Security fixes are provided for the latest release of each gem. Older releases
may be updated on a best-effort basis.

| Gem | Supported |
| --- | --- |
| `wallaby` | latest `8.x` |
| `wallaby-core` | latest `0.3.x` |
| `wallaby-active_record` | latest `0.3.x` |
| `wallaby-view` | latest `0.1.x` |
| `wallaby-cop` | latest `0.1.x` |

## Reporting a vulnerability

Please **do not** open a public issue for security problems.

Report privately through GitHub's
[private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
on the [repository](https://github.com/wallaby-rails/wallaby-rails/security/advisories/new),
or email the maintainer at <me@tian.im>.

Include, where possible:

- the affected gem(s) and version(s),
- a description of the issue and its impact,
- a minimal reproduction (or the request/params that trigger it),
- any suggested remediation.

We aim to acknowledge reports within a few business days and to coordinate a
disclosure timeline with you.

## Scope

In scope:

- the five gems in this monorepo (`wallaby`, `wallaby-core`,
  `wallaby-active_record`, `wallaby-view`, `wallaby-cop`),
- the shipped views, helpers, generators and JavaScript assets,
- the install/util generators' generated code.

Out of scope:

- the test-only dummy application under `spec/dummy`,
- the documented expectation that hosts configure authentication and
  authorization (see [docs/security.md](docs/security.md)),
- vulnerabilities in dependencies (report those upstream; a `bundler-audit`
  check runs in CI).
