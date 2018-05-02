require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class XcodeTestReporterHelper
      # class methods that you define here become available in your action
      # as `Helper::XcodeTestReporterHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the xcode_test_reporter plugin helper!")
      end
    end
  end
end
