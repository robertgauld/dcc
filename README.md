[![Gem Version](https://badge.fury.io/rb/dcc.png)](http://badge.fury.io/rb/dcc)
[![Build Status](https://secure.travis-ci.org/robertgauld/dcc.png?branch=main)](http://travis-ci.org/robertgauld/dcc)
[![Coveralls Status](https://coveralls.io/repos/robertgauld/dcc/badge.png?branch=main)](https://coveralls.io/r/robertgauld/dcc)
[![Code Climate](https://codeclimate.com/github/robertgauld/dcc.png?branch=main)](https://codeclimate.com/github/robertgauld/dcc)

## Ruby Versions
This gem supports the following versions of ruby, it may work on other versions but is not tested against them so don't rely on it.

* ruby:
  * 2.7.0 - 2.7.1


## DCC

Work with the NMRA's Digital Command Control standards.

Details of the gem's API can be found at <https://rubydoc.info/github/robertgauld/dcc/main>

## Installation

If you're using bundler then add it to your Gemfile and run the bundle command.

```ruby
gem 'dcc', '~> 0.1'
```

If you're not using bundler then install it from the command line.
```bash
gem install dcc -v '~> 0.1'
```

## Usage

### Setup

```ruby
require 'dcc'    # Unless you're using Bundler
```

### Examples

#### Work with long loco addresses
```ruby
# Get the values of CVs 17 and 18 for a given address
cv17, cv18 = Dcc.long_loco_address_bytes 1234
# it returns [196, 210] so cv17 is 196, and cv18 is 210

# Get an address given the values of CVs 17 and 18
Dcc.long_loco_address 196, 210
# returns 1234
```

#### Work with CV29

```ruby
# Make a value for writing to CV29
cv29 = Dcc.cv29 :speed_steps, :railcom, :long_address
# cv29 is 42

# Query a value read from CV29
Dcc.cv29? cv29, :reverse_direction   # returns false
Dcc.cv29? cv29, :speed_steps         # returns true
Dcc.cv29? cv29, :dc_operation        # returns false
Dcc.cv29? cv29, :railcom             # returns true
Dcc.cv29? cv29, :complex_speed_curve # returns false
Dcc.cv29? cv29, :long_address        # returns true
```

## Versioning

We follow the [Semantic Versioning](http://semver.org/) concept.
