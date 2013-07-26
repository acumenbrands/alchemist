require 'spec_helper'

describe Alchemist::Rituals::SourceMethod do

  let(:result_object) { OpenStruct.new(rank: 'Private') }

  let(:block)         { Proc.new { |method| self.rank = method } }
  let(:source_method) { Alchemist::Rituals::SourceMethod.new(method, &block) }

  context "a valid source object field is given" do

    let(:method)        { :rank }
    let(:source_object) { OpenStruct.new(rank: 'Colonel') }

    it "receives the appropriate block and arguments" do
      result_object.should_receive(:instance_exec)
        .with(source_object.rank, &block)
        .and_call_original
      source_method.call(source_object, result_object)
    end

  end

  context "an invalid source object field is given" do

    let(:method)        { :invalid_field }
    let(:source_object) { Class.new }

    let(:expected_error) { Alchemist::Errors::InvalidSourceMethod }

    it "raises an InvalidSourceMethod" do
      expect { source_method.call(source_object, result_object) }.to raise_error(expected_error)
    end

  end

end
