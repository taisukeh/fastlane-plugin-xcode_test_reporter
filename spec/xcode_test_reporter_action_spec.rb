describe Fastlane::Actions::XcodeTestReporterAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:user_error!).with("xcode-test-reporter command failed.")

      Fastlane::Actions::XcodeTestReporterAction.run({})
    end
  end
end
