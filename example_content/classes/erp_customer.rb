class ErpCustomer

  attr_accessor :name, :orders, :email_address

  attr_reader :event_log

  def initialize
    @event_log = []
  end

end

class ErpEvent

  attr_accessor :name, :datetime, :note

  def initialize(name=nil, datetime=nil, note=nil)
    self.name     = name
    self.datetime = datetime
    self.note     = note
  end

end
