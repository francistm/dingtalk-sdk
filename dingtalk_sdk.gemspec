# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dingtalk_sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'dingtalk_sdk'
  spec.version       = DingtalkSdk::VERSION
  spec.authors       = ['francis']
  spec.email         = ['francis.tm@gmail.com']

  spec.summary       = 'Dingtalk integration'
  spec.description   = 'Dingtalk ruby SKD'
  spec.homepage      = 'https://github.com/francistm/dingtalk-sdk'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/francistm/dingtalk-sdk'
    # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '> 2.4'

  spec.add_runtime_dependency     'activesupport', '~> 6.0'
  spec.add_runtime_dependency     'httparty', '~> 0.18'

  spec.add_development_dependency 'bundler', '~> 2.1.0'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
