require 'spec_helper'

RSpec.describe(Tundra::Loggers::ExceptionLogging) do
  # This class exists to allow us to continue to use partial double
  # verification by including the module and implementing a very bare minimum
  # API required for the module to function.
  class StubLogger
    include ::Tundra::Loggers::ExceptionLogging

    # Logging is the required API the class is required to implement. This does
    # nothing and exclusively exists to allow stubbing replacements of this
    # method.
    def log(_sev, _msg)
    end
  end

  subject { StubLogger.new }

  let(:sample_exception) { double('Exception') }

  context '#exception' do
    let(:message) { 'Just an exception message' }

    it 'sends the information to the log method' do
      allow(sample_exception).to receive(:backtrace).and_return([])
      allow(sample_exception).to receive(:message).and_return(message)

      expect(subject).to receive(:log)

      subject.exception(sample_exception)
    end

    it 'logs at the error level by default that an exception was raised' do
      allow(sample_exception).to receive(:backtrace).and_return([])
      allow(sample_exception).to receive(:message).and_return(message)

      expect(subject).to receive(:log).with(:error, anything)

      subject.exception(sample_exception)
    end

    it 'logs at the provided error level that an exception was raised' do
      allow(sample_exception).to receive(:backtrace).and_return([])
      allow(sample_exception).to receive(:message).and_return(message)

      expect(subject).to receive(:log).with(:info, anything)

      subject.exception(sample_exception, :info)
    end

    it 'logs the class of the exception' do
      allow(sample_exception).to receive(:backtrace).and_return([])
      allow(sample_exception).to receive(:message).and_return(message)

      expect(subject).to receive(:log).with(:error, /#{sample_exception.class}/)

      subject.exception(sample_exception)
    end

    it 'logs the message of the exception' do
      allow(sample_exception).to receive(:backtrace).and_return([])
      allow(sample_exception).to receive(:message).and_return(message)

      expect(subject).to receive(:log).with(:error, /#{message}/)

      subject.exception(sample_exception)
    end

    it 'logs the contents of the backtrace at the debug level by default' do
      allow(sample_exception).to receive(:backtrace).and_return(['backtrace'])
      allow(sample_exception).to receive(:message).and_return(message)

      # The normal message logging
      allow(subject).to receive(:log).with(:error, anything)
      expect(subject).to receive(:log).with(:debug, /backtrace/)

      subject.exception(sample_exception)
    end
  end

  context '#backtrace_messages' do
    it 'returns a useful log message when a backtrace isn\'t available' do
      allow(sample_exception).to receive(:backtrace).and_return(nil)
      messages = subject.send(:backtrace_messages, sample_exception)

      expect(messages).to be_instance_of(Array)
      expect(messages.length).to eq(1)
      expect(messages.first).to eq('No backtrace available.')
    end

    it 'returns the contents of the backtrace' do
      allow(sample_exception).to receive(:backtrace).and_return(:sample)
      expect(subject.send(:backtrace_messages, sample_exception)).to eq(:sample)
    end
  end
end
