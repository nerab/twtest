# twtest

Helpers for writing [TaskWarrior](http://taskwarrior.org/) tests in Ruby. It isolates tests by running TaskWarrior tests in their own data directory, independent from any default data directory you may have on your workstation.

[![Build Status](https://secure.travis-ci.org/nerab/twtest.png?branch=master)](http://travis-ci.org/nerab/twtest)

## Installation

Add this line to your application's Gemfile:

    gem 'twtest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twtest

## Usage

Have a look at the [example](test/unit/test_example.rb).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
