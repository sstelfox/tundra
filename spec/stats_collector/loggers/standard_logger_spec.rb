require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(StatsCollector::Loggers::StandardLogger) do
  it_behaves_like 'a logger'

  let(:log_double) { double('Logger') }
  let(:prog_name) { StatsCollector::Loggers::LOG_NAME }

  it 'logs a message at the provided severity' do
    message = 'Test message'

    expect(subject).to receive(:logger).and_return(log_double)
    expect(log_double).to receive(:log).with(0, message, prog_name)

    subject.log(:debug, message)
  end

  it 'looks up the severity symbol using #severity_lookup' do
    expect(subject).to receive(:logger).and_return(log_double)
    expect(subject).to receive(:severity_lookup).and_return(-5)
    expect(log_double).to receive(:log).with(-5, 'msg', prog_name)

    subject.log(:stub, 'msg')
  end

  context 'severity methods' do
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

  context '#severity_lookup' do
    it 'returns the DEBUG constant when provided with :debug' do
      expect(subject.send(:severity_lookup, :debug)).to eq(::Logger::DEBUG)
    end

    it 'returns the INFO constant when provided with :info' do
      expect(subject.send(:severity_lookup, :info)).to eq(::Logger::INFO)
    end

    it 'returns the WARN constant when provided with :warn' do
      expect(subject.send(:severity_lookup, :warn)).to eq(::Logger::WARN)
    end

    it 'returns the ERROR constant when provided with :error' do
      expect(subject.send(:severity_lookup, :error)).to eq(::Logger::ERROR)
    end

    it 'returns the FATAL constant when provided with :fatal' do
      expect(subject.send(:severity_lookup, :fatal)).to eq(::Logger::FATAL)
    end

    it 'returns the UNKNOWN constant when provided with :unknown' do
      expect(subject.send(:severity_lookup, :unknown)).to eq(::Logger::UNKNOWN)
    end

    it 'returns the value of the UNKNOWN constant when provided a bad value' do
      expect(subject.send(:severity_lookup, 'what?')).to eq(::Logger::UNKNOWN)
    end
  end
end
