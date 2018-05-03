describe Fastlane::Actions::XcodeTestReporterAction do
  describe '#run' do
    it 'prints a message' do
      expect do
        Fastlane::Actions::XcodeTestReporterAction.run({})
      end.to raise_error(FastlaneCore::Interface::FastlaneError)
    end
  end
end
