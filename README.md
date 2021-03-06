# Kintone CLI

[![Build Status](https://travis-ci.org/miya0001/kintone-cli.svg?branch=master)](https://travis-ci.org/miya0001/kintone-cli)

Manage Kintone from command line interface.

This project is in progress...

## Requires

* Ruby 2.2 or later

## Development

Install dependencies.

```
$ git clone git@github.com:miya0001/kintone-cli.git
$ cd kintone-cli
$ bundle install --path vendor/bundle
```

Run CLI.

```
$ bundle exec exe/kt
```

## Automated testing.

Add environment variables like following.

```
export KINTONE_SUBDOMAIN=xxxx
export KINTONE_USER=yyyy
export KINTONE_PASSWORD=zzzz
```

Then run rspec.

```
$ bundle exec rspec
```
