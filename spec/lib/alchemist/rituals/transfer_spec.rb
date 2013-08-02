require 'spec_helper'

describe Alchemist::Rituals::Transfer do

  context "a single field name is given" do

    let(:source_field) { :title }

    let(:result_string) { 'Report of the Result Object' }
    let(:source_string) { 'Report of the Source Object' }

    let(:source) { OpenStruct.new(title: source_string) }
    let(:result) { OpenStruct.new(title: result_string) }

    let(:context) { Alchemist::Context.new(source, result) }

    context "no block is given" do

      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field) }


      it "updates the value of 'title' on the result object" do 
        expect { transfer.call(context) }.to change { result.title }.to(source_string)
      end

    end

    context "a block is given" do

      let(:block) { Proc.new { |value| value.downcase.strip } }
      let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, nil, &block) }

      let(:expected_string) { source_string.downcase.strip }

      before do
        transfer.call(context)
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

    let(:context) { Alchemist::Context.new(source, result) }

    context "no block is given" do

      context "target method is a mutator" do

        let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field) }

        before do
          transfer.call(context)
        end

        it "updates the value of 'header' to the value of 'title'" do
          expect(result.header).to eq(source.title)
        end

      end

      context "target method is not a mutator" do

        let(:datetime_string)  { Time.now.to_s }
        let(:alt_source_field) { :datetime }
        let(:alt_result_field) { :parse_datetime }

        let(:transfer) { Alchemist::Rituals::Transfer.new(alt_source_field, alt_result_field) }

        before do
          source.stub(:datetime) { datetime_string }
        end

        it "calls the target method with the result of source_field" do
          result.should_receive(alt_result_field).with(datetime_string)
          transfer.call(context)
        end

      end

    end

    context "a block is given" do

      let(:block) { Proc.new { |value| value.upcase } }

      let(:expected_string) { source.title.upcase }

      context "target method is a mutator" do

        let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field, &block) }

        before do
          transfer.call(context)
        end

        it "updates the value of 'header' and executes the corresponding block" do
          expect(result.header).to eq(expected_string)
        end

      end

      context "target method is not a mutator" do

        let(:alt_result_method) { :parse_arbitrary_string }

        let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, alt_result_method, &block) }

        it "calls the target method with the result of the block" do
          result.should_receive(alt_result_method).with(expected_string)
          transfer.call(context)
        end

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

    let(:context) { Alchemist::Context.new(source, result) }

    let(:transfer) { Alchemist::Rituals::Transfer.new(source_field, result_field) }

    let(:expected_error) { Alchemist::Errors::InvalidResultMethodForTransfer }

    it "should raise a InvalidResultMethodForTransfer exception" do
      expect { transfer.call(context) }.to raise_error(expected_error)
    end

  end

end
