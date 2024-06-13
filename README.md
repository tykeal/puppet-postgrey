# postgrey

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with postgrey](#setup)
    - [What postgrey affects](#what-postgrey-affects)
    - [Setup requirements](#setup-requirements)
    - [Beginning with postgrey](#beginning-with-postgrey)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

[![Build
Status](https://gitlab.com/tykeal/puppet-postgrey/badges/main/pipeline.svg)](https://gitlab.com/tykeal/puppet-postgrey/-/tree/main)

This module installs and configures postgrey on a system. By default it sets it
up almost exactly like the default configuration. The only difference is that
quiet and privacy options are enabled.

## Setup

### What postgrey affects

### Setup Requirements

-   `puppetlabs/stdlib` is required for this module to work

### Beginning with postgrey

This module is designed to "just work" Configuration is done against the
following hiera locations:

-   `postgrey::install`
-   `postgrey::config`
-   `postgrey::service`

## Usage

To use simply do the following:

```puppet
include ::postgrey
```

## Limitations

This module is presently only developed for RedHat and CentOS 8 systems. It may
work on 7.

Other distros are welcome to open Merge Requests.

## Development

Development for this module is happening at
https://gitlab.com/tykeal/puppet-postgrey

To contribute please open a Merge Request

A [DCO](https://developercertificate.org/) line indicated by a Signed-off-by in
the commit footer of _every_ commit of a patch series, not just your merge
request is _required_. If any of the commits in the series do not contain this,
the request will be rejected.
