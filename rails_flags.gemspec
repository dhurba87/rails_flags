require_relative "lib/rails_flags/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_flags"
  spec.version     = RailsFlags::VERSION
  spec.authors     = [ "Dhurba Baral" ]
  spec.email       = [ "dhurba87@gmail.com" ]
  spec.homepage    = "https://github.com/dhurbabaral/rails_flags"
  spec.summary     = "Feature flags for Rails."
  spec.description = "Feature flags for Rails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dhurbabaral/rails_flags"
  spec.metadata["changelog_uri"] = "https://github.com/dhurbabaral/rails_flags/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "redis", "~> 5.0"
  spec.add_development_dependency "rspec-rails"
end
