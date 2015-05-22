require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(::Tundra::Loggers::ChainLogger) do
  it_behaves_like 'a logger'

  it 'sends a log to each configured logger'
  it 'defaults it\'s log level to :debug'
  it 'adds loggers to it\'s targets'
  it 'sets the level on all loggers'
  it 'returns the minimum agreed severity to log by it\'s targets'
end
