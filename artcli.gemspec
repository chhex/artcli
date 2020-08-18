require_relative 'lib/artcli/version'

Gem::Specification.new do |spec|
  spec.name          = "artcli"
  spec.version       = Artcli::VERSION
  spec.authors       = ["Christoph Henrici"]
  spec.email         = ["chhenrici@gmail.com"]

  spec.summary       = %q{Artifactory Command Client}
  spec.description   = %q{Artifactory Command Client using the Ruby Artifactory Client.}
  spec.homepage      = "http://chesnb.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/chhex/artcli.git"

  spec.add_dependency 'slop',  '~> 4.8', '>= 4.8.2'
  spec.add_dependency  'highline',  '~> 2.0', '>= 2.0.1'
  spec.add_dependency 'artifactory', '3.0.5'
  spec.add_dependency 'bcrypt','~> 3.1', '3.1.15 '
  spec.add_dependency 'filecache',  '~> 1.0', '>= 1.0.2'

  # Specify which files should be added to the gem when it is released.f
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = 'artcli'
  spec.require_paths = ["lib"]
end
