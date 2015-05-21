require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(Tundra::Loggers::NullLogger) do
  it_behaves_like 'a logger'

  it 'returns true to logging attempts' do
    expect(subject.log('test')).to eq(true)
  end
end
