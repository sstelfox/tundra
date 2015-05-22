require 'spec_helper'

RSpec.describe(::Tundra::Stat) do
  context '#any_data?' do
    it 'initializes with no data' do
      expect(subject.any_data?).to be(false)
    end

    it 'has data after a data point has been recorded' do
      subject.record(rand(10))
      expect(subject.any_data?).to be(true)
    end

    it 'doesn\'t have any data after a reset' do
      subject.record(rand(10))
      expect(subject.any_data?).to be(true)
      subject.reset
    end
  end

  context '#initialize' do
    it 'calls reset when instantiated' do
      expect_any_instance_of(described_class).to receive(:reset)
      subject
    end
  end

  context '#reset' do
    before(:each) do
      4.times { subject.record(rand(50) + 1) }
    end

    it 'resets the count to 0.0' do
      expect(subject.count).to_not eq(0.0)
      subject.reset
      expect(subject.count).to eq(0.0)
    end

    it 'resets the maximum to nil' do
      expect(subject.maximum).to_not be_nil
      subject.reset
      expect(subject.maximum).to be_nil
    end

    it 'resets the minimum to nil' do
      expect(subject.minimum).to_not be_nil
      subject.reset
      expect(subject.minimum).to be_nil
    end

    it 'resets the sum to 0.0' do
      expect(subject.sum).to_not be(0.0)
      subject.reset
      expect(subject.sum).to be(0.0)
    end

    it 'resets the sum_of_squares to nil' do
      expect(subject.sum_of_squares).to_not be(0.0)
      subject.reset
      expect(subject.sum_of_squares).to be(0.0)
    end
  end
end
