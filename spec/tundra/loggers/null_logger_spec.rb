require 'spec_helper'
require 'shared_examples/common_logger_examples'

RSpec.describe(Tundra::Loggers::NullLogger) do
  it_behaves_like 'a logger'
end
