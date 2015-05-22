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
    end
  end
end
