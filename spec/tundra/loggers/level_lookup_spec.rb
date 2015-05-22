require 'spec_helper'

RSpec.describe(Tundra::Loggers::LevelLookup) do
  context '#level_lookup' do
    it 'returns a Hash' do
      expect(subject.level_lookup).to be_instance_of(Hash)
    end

    it 'returns the :debug symbol when provided with the DEBUG constant' do
      expect(subject.level_lookup[::Logger::DEBUG]).to be(:debug)
    end

    it 'returns the :info symbol when provided with the INFO constant' do
      expect(subject.level_lookup[::Logger::INFO]).to be(:info)
    end

    it 'returns the :warn symbol when provided with the WARN constant' do
      expect(subject.level_lookup[::Logger::WARN]).to be(:warn)
    end

    it 'returns the :error symbol when provided with the ERROR constant' do
      expect(subject.level_lookup[::Logger::ERROR]).to be(:error)
    end

    it 'returns the :fatal symbol when provided with the FATAL constant' do
      expect(subject.level_lookup[::Logger::FATAL]).to be(:fatal)
    end

    it 'returns the :unknown symbol when provided with the UNKNOWN constant' do
      expect(subject.level_lookup[::Logger::UNKNOWN]).to be(:unknown)
    end
  end

  context '#severity_lookup' do
    it 'returns the DEBUG constant when provided with :debug' do
      expect(subject.severity_lookup(:debug)).to eq(::Logger::DEBUG)
    end

    it 'returns the INFO constant when provided with :info' do
      expect(subject.severity_lookup(:info)).to eq(::Logger::INFO)
    end

    it 'returns the WARN constant when provided with :warn' do
      expect(subject.severity_lookup(:warn)).to eq(::Logger::WARN)
    end

    it 'returns the ERROR constant when provided with :error' do
      expect(subject.severity_lookup(:error)).to eq(::Logger::ERROR)
    end

    it 'returns the FATAL constant when provided with :fatal' do
      expect(subject.severity_lookup(:fatal)).to eq(::Logger::FATAL)
    end

    it 'returns the UNKNOWN constant when provided with :unknown' do
      expect(subject.severity_lookup(:unknown)).to eq(::Logger::UNKNOWN)
    end

    it 'returns the value of the UNKNOWN constant when provided a bad value' do
      expect(subject.severity_lookup('what?')).to eq(::Logger::UNKNOWN)
    end

    it 'can return a provided constant when provided with a bad value' do
      result = subject.severity_lookup('weooo', :info)
      expect(result).to eq(::Logger::INFO)
    end
  end
end
