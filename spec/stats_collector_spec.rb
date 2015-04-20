require 'spec_helper'

RSpec.describe(StatsCollector) do
  it 'has a version number' do
    expect(StatsCollector::VERSION).not_to be nil
  end
end
