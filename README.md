# Saphyr

The purpose of `Saphyr` gem is to provide a simple DSL to easily and quickly
design a validation schema for JSON document.  

_**Note :**_

There are already a bunch of gem doing this job, like: `json-schema`, `json_schema`,
`json_schemer` all based on the [JSON Standard](https://json-schema.org/understanding-json-schema/index.html) to define a validation schema.
It's a really nice crafted standard but his usage is not really intuitive.

Actually the `Saphyr` gem volontary does not support the `json-schema` standard to describe
the validation schema and focus on simlicity with an easy to use DSL.

## Installation

Add it to your Gemfile:

    $ bundle add saphyr

Install the gem:

    $ gem install saphyr

# Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/odelbos/saphyr](https://github.com/odelbos/saphyr).

# License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
