require 'spec_helper'

RSpec.shared_examples('a logger') do
  it { expect(subject).to respond_to(:add) }
  it { expect(subject).to respond_to(:log) }

  it { expect(subject).to respond_to(:level) }
  it { expect(subject).to respond_to(:level=) }

  it { expect(subject).to respond_to(:debug) }
  it { expect(subject).to respond_to(:error) }
  it { expect(subject).to respond_to(:fatal) }
  it { expect(subject).to respond_to(:info) }
  it { expect(subject).to respond_to(:warn) }
  it { expect(subject).to respond_to(:unknown) }

  it 'returns true to logging attempts' do
    expect(subject.log(:debug, 'test')).to eq(true)
  end
end
