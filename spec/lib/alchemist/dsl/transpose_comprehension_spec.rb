require 'spec_helper'

describe Alchemist::Dsl::TransposeComprehension do

  describe '#use' do
    it 'adds the specified method to the list of source methods' do
      subject.use :talk
      expect(subject.source_methods).to include(:talk)
    end
  end

  describe '#target' do
    it 'creates a new Target with given method names and block' do
      target_class = Alchemist::Rituals::Transposition::Target
      target_class.stub(:new)

      person_block = Proc.new {}

      subject.target :talk, :walk, &person_block

      expect(target_class).to have_received(:new).with(:talk, :walk, &person_block)
    end
  end

end
