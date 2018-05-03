require 'fastlane/action'
require 'shellwords'
require 'json'
require_relative '../helper/xcode_test_reporter_helper'

module Fastlane
  module Actions
    class XcodeTestReporterAction < Action
      def self.run(params)
        params[:path] ||= Actions.lane_context[Actions::SharedValues::SCAN_GENERATED_PLIST_FILE] if Actions.lane_context[Actions::SharedValues::SCAN_GENERATED_PLIST_FILE]
        params[:path] ||= Actions.lane_context[Actions::SharedValues::SCAN_DERIVED_DATA_PATH] if Actions.lane_context[Actions::SharedValues::SCAN_DERIVED_DATA_PATH]

        options = {}
        options['--output-directory'] = params[:output_directory] if params[:output_directory]
        options['--path'] = params[:path] if params[:path]
        options['--format'] = params[:format] if params[:format]
        options['--output-json'] = true

        options_str = options.map do |k, v|
          v.is_a?(String) ? "#{k} #{v.shellescape}" : "#{k}"
        end.join(' ')

        command = "#{xcode_reporter_path} #{options_str}"

        resultText = `#{command}`
        unless $?.success?
          UI.user_error!("xcode-test-reporter command failed.")
        end

        result = {}
        JSON.parse(resultText).each
        result.each do |report|
          result[report["file"]] = report["success"]
          UI.message "Generated: #{report["file"]}"
          UI.test_failure!("Tests failed") if fail_build && !report["success"]
        end

        return result
      end

      def self.xcode_reporter_path
        __dir__ + "/../../../../../bin/xcode-test-reporter"
      end

      def self.description
        "Generates JUnit or HTML report from Xcode `plist` test report files"
      end

      def self.authors
        ["HORI Taisuke"]
      end

      def self.return_value
      end

      def self.details
        # Optional:
        "The `Xcode Test Reporter` Generates JUnit or HTML report from Xcode `plist` test report files."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :output_directory,
                                       env_name: "XCODE_TEST_REPORTER_OUTPUT_DIRECTORY",
                                       description: "Directoy in which the report files should be written to",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "XCODE_TEST_REPORTER_PATH",
                                       description: "Path containing the plist files",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :format,
                                       env_name: "XCODE_TEST_REPORTER_FORMAT",
                                       description: "The report format to output for (one of 'html', 'junit', or comma-separated values)",
                                       default_value: "junit",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :fail_build,
                                       env_name: "XCODE_TEST_REPORTER_FAIL_BUILD",
                                       description: "Should this step stop the build if the tests fail?",
                                       default_value: false,
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
