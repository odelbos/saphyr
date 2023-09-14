# frozen_string_literal: true

require_relative "lib/saphyr/version"

Gem::Specification.new do |spec|
  spec.name = "saphyr"
  spec.version = Saphyr::VERSION
  spec.authors = ["odelbos"]
  spec.email = ["od@phibox.com"]

  spec.summary = "The saphyr gem is used to validate JSON document."
  spec.description = "The purpose of Saphyr is to provide a nice and simple DSL to easily and quickly design a validation schema for JSON document."
  spec.homepage = "https://github.com/odelbos/saphyr"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "homepage_uri"     => spec.homepage,
    "source_code_uri"  => "https://github.com/odelbos/saphyr",
    "changelog_uri"    => "https://github.com/odelbos/saphyr/CHANGELOG",
  }

  spec.files = Dir['lib/**/*'] + %w(CHANGELOG LICENSE)
  spec.extra_rdoc_files = ['CHANGELOG', 'LICENSE']

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
