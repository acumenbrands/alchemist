require 'spec_helper'

describe Alchemist::Rituals::Transfer do

  context "a single field name is given" do

    let(:source_field) { :title }

    let(:result_string) { 'Report of the Result Object' }
    let(:source_string) { 'Report of the Source Object' }

    let(:source) { OpenStruct.new(title: source_string) }
    let(:result) { OpenStruct.new(title: result_string) }

    context "no block is given" do

      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field) }


      it "updates the value of 'title' on the result object" do 
        expect { transfer.call(source, result) }.to change { result.title }.to(source_string)
      end

    end

    context "a block is given" do

      let(:block) { Proc.new { |value| value.downcase.strip } }
      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, nil, &block) }

      let(:expected_string) { source_string.downcase.strip }

      before do
        transfer.call(source, result)
      end

      it "executes the block on the given field" do
        expect(result.title).to eq(expected_string)
      end

    end

  end

  context "two field names are given" do

    let(:source_field) { :title }
    let(:result_field) { :header }

    let(:source) { OpenStruct.new(title: 'Source Title!') }
    let(:result) { OpenStruct.new(header: 'Header Title!') }

    context "no block is given" do

      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field) }

      before do
        transfer.call(source, result)
      end

      it "updates the value of 'header' to the value of 'title'" do
        expect(result.header).to eq(source.title)
      end

    end

    context "a block is given" do

      let(:block) { Proc.new { |value| value.upcase } }
      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field, &block) }

      let(:expected_string) { source.title.upcase }

      before do
        transfer.call(source, result)
      end

      it "updates the value of 'header' and executes the corresponding block" do
        expect(result.header).to eq(expected_string)
      end

    end

  end

  context "an invalid field is provided" do

    class ResultReport
      attr_reader :text
    end

    let(:source_field) { :body }
    let(:result_field) { :text }

    let(:source) { OpenStruct.new(body: 'All the details of the report') }
    let(:result) { ResultReport.new }

    let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field) }

    let(:expected_error) { Alchemist::Errors::NoResultFieldForTransfer }

    it "should raise a NoResultFieldForTransfer exception" do
      expect { transfer.call(source, result) }.to raise_error(expected_error)
    end

  end

end
