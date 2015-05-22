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

  context '#mean' do
    it 'returns nil when there aren\'t any data points' do
      expect(subject.mean).to be_nil
    end

    mean_values = [
      [[1, 1, 1], 1.0],
      [[2, 3, 4], 3.0],
      [[17], 17.0],
      [[3.0, 7.0, 10.0, 10.0, 0.0], 6.0]
    ]

    mean_values.each do |values, mean|
      it format('returns the mean %2.1f with data %s', mean, values.inspect) do
        values.each { |i| subject.record(i) }
        expect(subject.mean).to eq(mean)
      end
    end
  end

  context '#record' do
    it 'increments the count when a data point is recorded' do
      expect { subject.record(rand(10)) }.to change { subject.count }
        .from(0).to(1)
    end

    it 'adds the recorded value to the sum' do
      expect { subject.record(-10) }.to change { subject.sum }
        .from(0).to(-10)
    end

    it 'updates the maximum value when the data point is larger' do
      subject.record(12)
      expect { subject.record(17) }.to change { subject.maximum }
        .from(12).to(17)
    end

    it 'doesn\'t update the maximum value when the data point is smaller' do
      subject.record(9)
      expect { subject.record(5) }.to_not change { subject.maximum }
    end

    it 'updates the minimum value when the data point is smaller' do
      subject.record(5)
      expect { subject.record(-10) }.to change { subject.minimum }
        .from(5).to(-10)
    end

    it 'doesn\'t update the minimum value when the data point is larger' do
      subject.record(4)
      expect { subject.record(10) }.to_not change { subject.minimum }
    end

    it 'sets the sum of squares to 0 with only one value' do
      subject.record(11)
      expect(subject.sum_of_squares).to eq(0.0)
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
