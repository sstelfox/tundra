require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(::Tundra::Loggers::MemoryLogger) do
  it_behaves_like 'a logger'

  it 'ignores attempts to change it\'s log level' do
    expect { subject.level = :error }.to_not change { subject.level }
  end

  it 'operates as if it was in debug mode' do
    expect(subject.level).to eq(:debug)
  end

  it 'stores log messages in the internal buffer' do
    buffer_double = instance_double('::Tundra::RingBuffer')
    message = 'Log message'

    expect(subject).to receive(:messages).and_return(buffer_double)
    expect(buffer_double).to receive(:<<).with([:info, message])

    subject.log(:info, message)
  end

  it 'uses a ring buffer internally' do
    expect(subject.send(:messages)).to be_instance_of(::Tundra::RingBuffer)
  end

  context '#dump_to_logger' do
    let(:log_double) { instance_double('::Tundra::Loggers::StandardLogger') }
    let(:message)    { 'some random message' }
    let(:severity)   { :warning }

    it 'dumps stored messages into another logger' do
      expect(log_double).to receive(:log).with(severity, message)

      subject.log(severity, message)
      subject.dump_to_logger(log_double)
    end

    it 'empties the internal buffer after dumping the messages' do
      allow(log_double).to receive(:log).with(severity, message)
      expect(subject.send(:messages)).to receive(:clear!)

      subject.log(severity, message)
      subject.dump_to_logger(log_double)
    end
  end
end
