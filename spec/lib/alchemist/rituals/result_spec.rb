require 'spec_helper'

describe Alchemist::Rituals::Result do

  let(:block)  { Proc.new { |user| user.name } }
  let(:finder) { Alchemist::Rituals::Result.new(&block) }

  describe "#call" do

    let(:user) { double(name: 'Timothy') }

    it "invokes the block given and returns the appropriate result" do
      expect(finder.call(user)).to eq("Timothy")
    end

  end

end
