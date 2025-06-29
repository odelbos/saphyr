# frozen_string_literal: true

require_relative "lib/saphyr/version"

msg = "Simple DSL to design validation schemas for JSON document (or Hash / Array structure)"

Gem::Specification.new do |spec|
  spec.name = "saphyr"
  spec.version = Saphyr::VERSION
  spec.authors = ["odelbos"]
  spec.email = ["od@phibox.com"]

  spec.summary = msg
  spec.description = msg
  spec.homepage = "https://github.com/odelbos/saphyr"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "homepage_uri"     => spec.homepage,
    "changelog_uri"    => "https://github.com/odelbos/saphyr/blob/main/CHANGELOG",
  }

  spec.files = Dir['lib/**/*', 'rdoc/*'] + %w(CHANGELOG LICENSE)
  spec.extra_rdoc_files = ['CHANGELOG', 'LICENSE'] + Dir['rdoc/*']

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
