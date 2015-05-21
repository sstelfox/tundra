require 'spec_helper'

RSpec.describe(Tundra::Loggers::LevelShortcuts) do
  # This class exists to allow us to continue to use partial double
  # verification by including the module and implementing a very bare minimum
  # API required for the module to function.
  class StubLogger
    include ::Tundra::Loggers::LevelShortcuts

    def log(_sev, _msg)
    end
  end

  subject { StubLogger.new }

  let(:sample_message) { 'Irrelevant test string' }

  it 'logs at the debug level' do
    expect(subject).to receive(:log).with(:debug, sample_message)
    subject.debug(sample_message)
  end

  it 'logs at the info level' do
    expect(subject).to receive(:log).with(:info, sample_message)
    subject.info(sample_message)
  end

  it 'logs at the warn level' do
    expect(subject).to receive(:log).with(:warn, sample_message)
    subject.warn(sample_message)
  end

  it 'logs at the error level' do
    expect(subject).to receive(:log).with(:error, sample_message)
    subject.error(sample_message)
  end

  it 'logs at the fatal level' do
    expect(subject).to receive(:log).with(:fatal, sample_message)
    subject.fatal(sample_message)
  end

  it 'logs at the unknown level' do
    expect(subject).to receive(:log).with(:unknown, sample_message)
    subject.unknown(sample_message)
  end
end
