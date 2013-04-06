class Stypi
  def self.fetch
    HTTParty.get(STYPI_SOURCE).body
  end
end
