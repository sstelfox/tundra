require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(::Tundra::Loggers::ChainLogger) do
  it_behaves_like 'a logger'

  let(:first_logger) { double('::Tundra::Loggers::NullLogger') }
  let(:second_logger) { double('::Tundra::Loggers::NullLogger') }

  it 'adds loggers to it\'s targets' do
    subject.add_logger(first_logger)
    expect(subject.send(:target_loggers)).to include(first_logger)
  end

  it 'defaults it\'s log level to :debug with no loggers' do
    expect(subject.level).to eq(:debug)
  end

  context 'with multiple loggers' do
    before(:each) do
      subject.add_logger(first_logger)
      subject.add_logger(second_logger)
    end

    it 'sends a log to each configured logger' do
      expect(first_logger).to receive(:log).with(:debug, 'test message')
      expect(second_logger).to receive(:log).with(:debug, 'test message')

      subject.log(:debug, 'test message')
    end

    it 'sets the level on all loggers' do
      expect(first_logger).to receive(:level=).with(:warn)
      expect(second_logger).to receive(:level=).with(:warn)

      subject.level = :warn
    end

    it 'returns the minimum agreed severity to log by it\'s targets' do
      allow(first_logger).to receive(:level).and_return(:warn)
      allow(second_logger).to receive(:level).and_return(:error)

      expect(subject.level).to eq(:error)
    end
  end
end
