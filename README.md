# Micro-Investment Venture Fund

[![make](https://github.com/yegor256/seedramp/actions/workflows/make.yml/badge.svg)](https://github.com/yegor256/seedramp/actions/workflows/make.yml)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/seedramp)](https://hitsofcode.com/view/github/yegor256/seedramp)
[![Availability at SixNines](https://www.sixnines.io/b/bbf6)](https://www.sixnines.io/h/bbf6)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/seedramp/blob/master/LICENSE.txt)

[SeedRamp] is a venture fund.

We give you cash to cover the next calendar month (up to $20k),
  you give us [SAFE].

We make investment decisions instantly after a one-hour interview ([FAQ]).

## How to Contribute

This is a hand-made static website.
To build it, just run this:

```bash
bundle update
make
```

In the absence of errors, the content goes to the `target/` directory.
You must have [Ruby] 3+ installed.

Once your changes go to the `master` branch,
  GitHub Actions automatically deploys a new version of the site to the
  `gh-pages` branch, which makes them published to the
  [GitHub Pages].

[SAFE]: https://www.seedramp.com/safe.html
[FAQ]: https://www.seedramp.com/faq.html
[SeedRamp]: https://www.seedramp.com
[Ruby]: https://www.ruby-lang.org/en/
[GitHub Pages]: https://pages.github.com/
