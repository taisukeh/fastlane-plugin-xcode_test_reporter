describe Fastlane::Actions::XcodeTestReporterAction do
  describe '#run' do
    it 'prints a message' do
      expect {
        Fastlane::Actions::XcodeTestReporterAction.run({})
      }.to raise_error(FastlaneCore::Interface::FastlaneError)
    end
  end
end
