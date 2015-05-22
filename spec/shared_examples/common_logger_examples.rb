require 'spec_helper'

RSpec.shared_examples('a logger') do
  it { expect(subject).to respond_to(:add) }
  it { expect(subject).to respond_to(:log) }

  it { expect(subject).to respond_to(:level) }
  it { expect(subject).to respond_to(:level=) }

  it 'exception logging mixin to be included' do
    expect(described_class.ancestors)
      .to(include(::Tundra::Loggers::ExceptionLogging))
  end

  it 'level shortcuts mixin to be included' do
    expect(described_class.ancestors)
      .to(include(::Tundra::Loggers::LevelShortcuts))
  end
end
