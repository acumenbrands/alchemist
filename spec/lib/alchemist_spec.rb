require 'spec_helper'
require 'time'
require 'date'

describe Alchemist do

  let(:first_name)  { 'Jimmy' }
  let(:last_name)   { 'John' }
  let(:name)        { first_name + ' ' + last_name }
  let(:order_count) { 6 }
  let(:orders)      { "6" }
  let(:email)       { 'jimmyjohn@jimmy.com' }
  let(:type)        { 'Customer' }
  let(:date)        { Date.today }
  let(:time)        { Time.now }
  let(:user_event)  { UserEvent.new(type, date, time) }
  let(:datetime)    { "#{date} #{time}" }

  describe "LocalCustomer to ErpCustomer" do

    context "LocalCustomer is converted successfully" do

      let(:local) do
        LocalCustomer.new.tap do |local|
          local.first_name  = first_name
          local.last_name   = last_name
          local.email       = email
          local.order_count = order_count
          local.user_events << user_event
        end
      end

      let(:transmute) { Alchemist.transmute(local, ErpCustomer) }

      pending "sets 'first_name' and 'last_name' to 'name'" do
        # expect(transmute.name).to eq(local.full_name)
      end

      it "sets 'order_count' to 'order'" do
        expect(transmute.orders).to eq(local.order_count.to_s)
      end

      it "sets 'email' to 'email_address'" do
        expect(transmute.email_address).to eq(local.email)
      end

      context "sets 'user_events' to 'event_log'" do

        it "sets 'type' to 'name'" do
          expect(transmute.event_log.first.name).to eq(local.user_events.first.type)
        end

        it "sets 'date' and 'time' to 'datetime'" do
          expect(transmute.event_log.first.datetime).to eq(datetime)
        end

        it "sets 'note' to default note" do
          expect(transmute.event_log.first.note).to eq('Created by Alchemist')
        end

      end

    end

    context "LocalCustomer fails to convert" do
    end

  end

  describe "ErpCustomer to LocalCustomer" do

    context "ErpCustomer converts successfully" do

      let(:event_name) { 'existential breakdown' }
      let(:datetime)   { '3/4/2013 16:34:21 pm' }
      let(:note)       { 'User needs to be told nihilism is lazy' }

      let(:parsed_date) { Date.parse(datetime) }
      let(:parsed_time) { Time.parse(datetime) }

      let(:erp) do
        ErpCustomer.new.tap do |erp|
          erp.name          = name
          erp.orders        = order_count
          erp.email_address = email
          erp.event_log << erp_event
        end
      end

      let(:erp_event) { ErpEvent.new(event_name, datetime, note) }

      let(:transmute) { Alchemist.transmute(erp, LocalCustomer) }

      context "name" do

        it "sets 'first_name'" do
          expect(transmute.first_name).to eq(first_name)
        end

        it "sets 'last_name'" do
          expect(transmute.last_name).to eq(last_name)
        end

      end

      it "sets 'email_address' to 'email'" do
        expect(transmute.email).to eq(email)
      end

      context "sets 'event_log' to 'user_events'" do

        it "sets 'name' to 'type'" do
          expect(transmute.user_events.first.type).to eq(event_name)
        end

        it "splits 'datetime' into 'date'" do
          expect(transmute.user_events.first.date).to eq(parsed_date)
        end

        it "splits 'datetime' into 'time'" do
          expect(transmute.user_events.first.time).to eq(parsed_time)
        end

      end

    end

  end
end
