require 'spec_helper'

describe Alchemist do

  let(:street)           { 'Frontage' }
  let(:city)             { 'Townsville' }
  let(:state)            { 'CT' }
  let(:zip)              { '12345' }
  let(:date)             { Date.today }
  let(:compiled_address) { "#{street}, #{city}, #{state}, #{zip}" }

  let(:local_customer) do
    LocalCustomer.new.tap do |l|
      l.first_name       = 'bob'
      l.last_name        = 'smith'
      l.email_address    = 'bob.smith@domain.suffix'
      l.join_date        = date.strftime('%m/%d/%Y')
      l.address          = compiled_address
      l.shipping_address = compiled_address
      l.user_events      = [user_event]
      l.order_history    = {
        in_route:  7,
        delivered: 15
      }
    end
  end

  let(:erp_customer) do
    ErpCustomer.new.tap do |e|
      e.first_name      = 'bob'
      e.last_name       = 'smith'
      e.email           = 'bob.smith@domain.suffix'
      e.date            = date
      e.street          = street
      e.city            = city
      e.state           = state
      e.zip             = zip
      e.orders_in_route = 7
      e.shipped_orders  = 15
      e.events          = [erp_event]
    end
  end

  let(:erp_event) do
    ErpEvent.new.tap do |event|
      event.date    = Date.today
      event.message = 'ZOGM'
    end
  end

  let(:user_event) do
    UserEvent.new.tap do |event|
      event.date = Date.today
      event.memo = 'ZOGM'
    end
  end

  describe 'ErpCustomer to LocalCustomer' do

    let(:transmute) do
      Alchemist.transmute(erp_customer, LocalCustomer)
    end

    subject { transmute }

    its(:first_name)       { should eq(local_customer.first_name) }
    its(:last_name)        { should eq(local_customer.last_name) }
    its(:email_address)    { should eq(local_customer.email_address) }
    its(:join_date)        { should eq(local_customer.join_date) }
    its(:address)          { should eq(local_customer.address) }
    its(:shipping_address) { should eq(local_customer.shipping_address) }
    its(:order_history)    { should eq(local_customer.order_history) }

    context 'user events' do

      subject do
        transmute.user_events
      end

      its(:count) { should eq(local_customer.user_events.count) }

    end

    context 'the data will violate a guard' do

      let(:expected) { Alchemist::Errors::GuardFailure }

      before do
        erp_customer.first_name = 'John'
      end

      it 'should raise an exception' do
        expect { Alchemist.transmute(erp_customer, LocalCustomer) }.to raise_error(expected)
      end

    end

  end

  describe 'ErpCustomer to LocalCustomer with a trait' do

    let(:transmute) do
      Alchemist.transmute(erp_customer, LocalCustomer, :mess_up_email)
    end

    subject { transmute }

    its(:first_name)       { should eq(local_customer.first_name) }
    its(:last_name)        { should eq(local_customer.last_name) }
    its(:join_date)        { should eq(local_customer.join_date) }
    its(:address)          { should eq(local_customer.address) }
    its(:shipping_address) { should eq(local_customer.shipping_address) }
    its(:order_history)    { should eq(local_customer.order_history) }

    it 'should not contain an @ symbol in the email' do
      expect(transmute.email_address).to_not include('@')
    end

    context 'user events' do

      subject do
        transmute.user_events
      end

      its(:count) { should eq(local_customer.user_events.count) }

    end

  end

  describe 'LocalCustomer to ErpCustomer' do

    let(:transmute) { Alchemist.transmute(local_customer, ErpCustomer) }

    subject { transmute }

    its(:first_name)      { should eq(erp_customer.first_name) }
    its(:last_name)       { should eq(erp_customer.last_name) }
    its(:email)           { should eq(erp_customer.email) }
    its(:date)            { should eq(erp_customer.date) }
    its(:street)          { should eq(erp_customer.street) }
    its(:city)            { should eq(erp_customer.city) }
    its(:state)           { should eq(erp_customer.state) }
    its(:zip)             { should eq(erp_customer.zip) }
    its(:orders_in_route) { should eq(erp_customer.orders_in_route) }
    its(:shipped_orders)  { should eq(erp_customer.shipped_orders) }

    context 'events' do

      subject do
        transmute.events
      end

      its(:count) { should eq(erp_customer.events.count) }

    end

  end

  describe 'LocalCustomer to Hash' do

    let(:transmute) { Alchemist.transmute(local_customer, Hash) }

    it 'transfers first_name' do
      expect(transmute[:first_name]).to eq(local_customer.first_name)
    end

    it 'transfers last_name' do
      expect(transmute[:last_name]).to eq(local_customer.last_name)
    end

  end

  describe 'Hash to LocalCustomer' do
    let(:transmute) { Alchemist.transmute(hash, LocalCustomer) }
    subject { transmute }
    let(:hash) do
      {
        first_name: 'Marcellus',
        last_name: 'Wallace'
      }
    end

    its(:first_name) { should eq(hash[:first_name]) }
    its(:last_name)  { should eq(hash[:last_name]) }
  end

end
