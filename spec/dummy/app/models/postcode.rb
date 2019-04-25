class Postcode
  attr_accessor :postcode, :locality, :state, :long, :lat, :id, :dc, :type, :status

  def initialize(hash)
    hash.each do |k, v|
      public_send "#{k}=", v
    end
  end
end
