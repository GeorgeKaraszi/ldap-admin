# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ldap/version'

Gem::Specification.new do |spec|
  spec.name          = %q{ldap-admin}
  spec.version       = LdapAdmin::VERSION
  spec.authors       = ["George Karaszi"]
  spec.email         = ["GeorgeKaraszi@gmail.com"]

  spec.summary       = "Performs search query and returns into a json block"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/GeorgeKaraszi/interfacer-admin"
  spec.required_ruby_version = ">= 2.0.0"

  spec.files = `git ls-files`.split $/
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 11.0"

  spec.add_dependency('net-ldap', '~> 0.14.0')
  spec.add_dependency('devise', '~> 3.5', '>= 3.5.6')

  spec.add_development_dependency('rdoc', '~> 4.2', '>= 4.2.2')
  spec.add_development_dependency('rails', '~> 4.2', '>= 4.2.6')
  spec.add_development_dependency('sqlite3','~> 1.3', '>= 1.3.11')
  spec.add_development_dependency('factory_girl_rails', '~> 1.0')
  spec.add_development_dependency('factory_girl', '~> 2.0')
  spec.add_development_dependency('rspec-rails', '~> 3.4', '>= 3.4.2')

  %w{database_cleaner capybara launchy}.each do |dep|
    spec.add_development_dependency(dep)
  end
end
