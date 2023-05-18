# frozen_string_literal: true

require_relative 'lib/staccato/version'

Gem::Specification.new do |spec|
  spec.name          = 'staccato'
  spec.version       = Staccato::VERSION
  spec.authors       = ['Tony Pitale']
  spec.email         = ['tpitale@gmail.com']
  spec.description   = 'Ruby Google Analytics Measurement'
  spec.summary       = 'Ruby Google Analytics Measurement'
  spec.homepage      = 'https://github.com/tpitale/staccato'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          *%w[
            bin/ test/ spec/ features/ .git .circleci appveyor
          ]
        )
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'faraday'
end
