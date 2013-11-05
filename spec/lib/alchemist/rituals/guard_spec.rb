require 'spec_helper'

describe Alchemist::Rituals::Guard do

  let(:field) { :name }

  let(:result) { double }

  let(:guard) { Alchemist::Rituals::Guard.new(field, &block) }
  let(:context) { Alchemist::Context.new(source, result) }

  let(:execute_guard) { guard.call(context) }

  context "normal operation" do

    let(:block) { Proc.new { |name| name.class == String } }

    context "the given block returns true" do

      let(:source) { double(name: 'Sarah') }

      it "does not raise an exception" do
        expect { execute_guard }.to_not raise_error
      end

    end

    context "the given block returns a falsy value" do

      let(:source) { double(name: ['Sarah', 'McFadden', 'Regean']) }

      it "raises an exception" do
        expect { execute_guard }.to raise_error(Alchemist::Errors::GuardFailure)
      end

    end

  end

  context "the given block raises an exception" do

    let(:source) { double(name: "Shoggoth") }

    let(:block) { Proc.new { |name| raise StandardError.new("Oh snap, son") } }

    it "does not suppress the error from the block" do
      expect { execute_guard }.to raise_error(StandardError)
    end

  end

end
