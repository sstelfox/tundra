require 'spec_helper'

RSpec.describe(Tundra::Loggers::LogOnce) do
  # This class exists to allow us to continue to use partial double
  # verification by including the module and implementing a very bare minimum
  # API required for the module to function.
  class StubLogger
    include ::Tundra::Loggers::LogOnce

    # All classes including this module needs to call it's initializer to allow
    # it to be used.
    def initialize
      initialize_log_once
    end

    # Logging is the required API the class is required to implement. This does
    # nothing and exclusively exists to allow stubbing replacements of this
    # method.
    def log(_sev, _msg)
    end
  end

  subject { StubLogger.new }

  context '#log_once' do
    let(:key)       { [:a_key, 'a string as well'].sample }
    let(:message)   { 'Just a normal message' }
    let(:severity)  { [:debug, :info, :warn].sample }

    it 'logs the first instance of a message received' do
      expect(subject).to receive(:log).with(severity, message)
      subject.log_once(severity, key, message)
    end

    it 'logs a message again once the keys are cleared' do
      expect(subject).to receive(:log).with(severity, message).twice
      subject.log_once(severity, key, message)
      subject.clear_logged_keys
      subject.log_once(severity, key, message)
    end

    it 'only logs a message once' do
      expect(subject).to receive(:log).with(severity, message).once
      3.times { subject.log_once(severity, key, message) }
    end

    it 'continues to accept symbol keys when the key list is full' do
      stub_const('::Tundra::Loggers::LOG_ONCE_MAX_KEYS', 0)
      expect(subject).to receive(:log).with(severity, message)

      subject.log_once(severity, :test_sym, message)
      expect(subject.send(:logged_keys)).to include(:test_sym)
    end

    it 'silently discards string keys when the key list is full' do
      stub_const('::Tundra::Loggers::LOG_ONCE_MAX_KEYS', 0)
      expect(subject).to_not receive(:log).with(severity, message)

      subject.log_once(severity, 'test key', message)
      expect(subject.send(:logged_keys)).to_not include('test key')
    end
  end
end
