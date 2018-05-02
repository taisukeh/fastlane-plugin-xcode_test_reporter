require 'fastlane/action'
require 'shellwords'
require_relative '../helper/xcode_test_reporter_helper'

module Fastlane
  module Actions
    class XcodeTestReporterAction < Action
      def self.run(params)
        options = {}
        options['--output-directory'] = params[:output_directory] if params[:output_directory]
        options['--path'] = params[:path] if params[:path]
        options['--format'] = params[:format] if params[:format]

        options_str = options.map {|k, v| "#{k} #{v.shellescape}" }.join(" ")

        command = "#{xcode_reporter_path} #{options_str}"

        unless system(command)
          UI.user_error!("xcode-test-reporter command failed.")
        end
      end

      def self.xcode_reporter_path
        __dir__ + "/../../../../../bin/xcode-test-reporter"
      end

      def self.description
        "Generates JUnit or HTML report from Xcode `plist` test report files."
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
                                       description: "Directoy in which the report files should be written to.  Same directory as source by default.",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "XCODE_TEST_REPORTER_PATH",
                                       description: "Path containing the plist files (default: .)",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :path,
                                       env_name: "XCODE_TEST_REPORTER_FORMAT",
                                       description: "The report format to output for (one of 'html', 'junit', or comma-separated values). (default: junit)",
                                       default_value: "junit",
                                       optional: true,
                                       type: String),
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
