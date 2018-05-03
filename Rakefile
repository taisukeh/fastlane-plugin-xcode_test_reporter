require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

require 'fastlane/plugin/xcode_test_reporter/version'

task(:bump_release) do
  version = Fastlane::XcodeTestReporter::VERSION
  latest_version = `curl -L -s https://api.github.com/repos/taisukeh/fastlane-plugin-xcode_test_reporter/tags | jq -r '.[0].name'`.strip
  fail unless $?.success?

  if latest_version == "v#{version}"
    version_file = "lib/fastlane/plugin/xcode_test_reporter/version"

    versions = version.split('.')
    new_version = "#{versions[0]}.#{versions[1]}.#{versions[2].to_i + 1}"
    `sed -i -e /#{version}/#{new_version}/ #{version_file}`
    fail unless $?.success?

    `git add #{version_file} && git commit -m '[skip ci] bump version #{new_version} && git push`
    fail unless $?.success?
  end

  Rake::Task['release'].invoke
end

task(default: [:spec, :rubocop])
