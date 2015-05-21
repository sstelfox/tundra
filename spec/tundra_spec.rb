require 'spec_helper'

RSpec.describe(Tundra) do
  it 'has a version number' do
    expect(Tundra::VERSION).not_to be nil
  end

  context 'logger singleton' do
    let(:default_logger) { Tundra::Loggers::StandardLogger }

    after(:each) do
      # We need to reset the state of the logger singleton to ensure the tests
      # run consistently and don't have a weird state afterwards.
      described_class.instance_variable_set(:@logger, nil)
    end

    it 'initializes to a standard logger when one isn\'t set' do
      expect(described_class.instance_variable_get(:@logger)).to be_nil
      expect(described_class.logger).to be_instance_of(default_logger)
      expect(described_class.instance_variable_get(:@logger)).to_not be_nil
    end

    it 'returns the same instance everytime' do
      expect(described_class.logger).to be(described_class.logger)
    end

    it 'allows replacing the instance with another one' do
      replacement = double
      described_class.logger = replacement

      expect(described_class.logger).to eq(replacement)
    end
  end
end
