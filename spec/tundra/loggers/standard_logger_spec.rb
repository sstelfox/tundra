require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(Tundra::Loggers::StandardLogger) do
  it_behaves_like 'a logger'

  let(:log_double) { double('Logger') }
  let(:prog_name) { Tundra::Loggers::LOG_NAME }

  it 'logs a message at the provided severity' do
    message = 'Test message'

    expect(subject).to receive(:logger).and_return(log_double)
    expect(log_double).to receive(:log).with(0, message, prog_name)

    subject.log(:debug, message)
  end

  it 'looks up the severity symbol using #severity_lookup' do
    expect(subject).to receive(:logger).and_return(log_double)
    expect(::Tundra::Loggers::LevelLookup).to receive(:severity_lookup)
      .with(:stub).and_return(-5)
    expect(log_double).to receive(:log).with(-5, 'msg', prog_name)

    subject.log(:stub, 'msg')
  end

  context '#level' do
    it 'defaults to the info log level' do
      expect(subject.level).to eq(:info)
    end
  end

  context '#level=' do
    it 'can set the log level' do
      expect(subject.level).to eq(:info)
      subject.level = :warn
      expect(subject.level).to eq(:warn)
    end
  end
end
