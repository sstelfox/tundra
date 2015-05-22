require 'spec_helper'

RSpec.describe(Tundra::RingBuffer) do
  let(:buffer_size) { 5 }
  subject { described_class.new(buffer_size) }

  it 'initializes to the provided max size' do
    expect(subject.instance_variable_get(:@ring_size)).to eq(buffer_size)
  end

  it 'initializes with no contents' do
    expect(subject).to be_empty
  end

  context '#clear' do
    it 'empties the contents of the buffer' do
      subject << rand(50)
      expect(subject).to_not be_empty
      subject.clear
      expect(subject).to be_empty
    end
  end

  context '#count' do
    it 'returns the number of items in the buffer' do
      contents = rand(buffer_size).times.to_a

      subject.ring = contents
      expect(subject.count).to eq(contents.count)
    end
  end

  context '#<<' do
    it 'appends new elements to itself' do
      new_element = rand(50)
      subject << new_element
      expect(subject.to_a.last).to eq(new_element)
    end

    it 'removes earlier objects when full' do
      # Create a zero index 'full' buffer, and the next number
      max_contents = buffer_size.times.to_a
      additional_element = buffer_size

      subject.ring = max_contents
      subject << additional_element

      expect(subject.to_a.first).to eq(1)
      expect(subject.to_a.last).to eq(additional_element)
    end

    it 'returns objects that get removed' do
      # Create a zero index 'full' buffer, and the next number
      max_contents = buffer_size.times.to_a
      additional_element = buffer_size

      subject.ring = max_contents
      expect(subject << additional_element).to eq(0)
    end
  end

  context 'as an enumerable object' do
    it 'can provide it\'s contents as an array' do
      expect(subject.to_a).to be_instance_of(Array)
    end

    it 'can provide it\'s contents as an enumerator' do
      expect(subject.to_enum).to be_instance_of(Enumerator)
    end

    it 'can not be modified through it\'s to_a method' do
      correct_contents = [1, 2]

      subject.ring = correct_contents
      subject.to_a.push(3)

      expect(subject.to_a).to_not include(3)
      expect(subject.to_a).to eq(correct_contents)
    end
  end

  context '#ring=' do
    it 'can have it\'s ring replaced' do
      new_contents = [1, 2, 3]

      expect(subject.to_a).to_not eq(new_contents)
      subject.ring = new_contents
      expect(subject.to_a).to eq(new_contents)
    end

    it 'replaces the contents with the last items if there are too many' do
      new_contents = [1, 2, 3, 4, 5, 6]
      subject.ring = new_contents

      expect(subject.to_a).to eq([2, 3, 4, 5, 6])
    end
  end

  context 'with initialized contents' do
    let(:contents) { (buffer_size / 2).times.map { rand(10) } }
    subject { described_class.new(buffer_size, contents) }

    it 'can start with contents provided' do
      expect(subject.to_a).to eq(contents)
    end
  end
end
