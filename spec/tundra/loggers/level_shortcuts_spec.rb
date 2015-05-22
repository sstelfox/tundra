require 'spec_helper'

RSpec.describe(Tundra::Loggers::LevelShortcuts) do
  # This class exists to allow us to continue to use partial double
  # verification by including the module and implementing a very bare minimum
  # API required for the module to function.
  class StubLogger
    include ::Tundra::Loggers::LevelShortcuts

    # Logging is the required API the class is required to implement. This does
    # nothing and exclusively exists to allow stubbing replacements of this
    # method.
    def log(_sev, _msg)
    end
  end

  subject { StubLogger.new }

  let(:sample_message) { 'Irrelevant test string' }

  %i(debug info warn error fatal unknown).each do |level|
    it format('logs at the %s level', level) do
      expect(subject).to receive(:log).with(level, sample_message)
      subject.send(level, sample_message)
    end
  end
end
