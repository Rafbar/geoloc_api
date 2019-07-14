class GeoLocation < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validate :ip_address_valid?
  validate :key_processable?

  URL_REGEX = /(^$)|(^(http|https)?:?\/?\/?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  def stripped_key
    key.gsub('https://', '').gsub('http://','')
  end

  private

  def key_processable?
    unless IPAddress.valid?(self.key) || (self.key =~ URL_REGEX)
      errors.add(:key, "Key not ip or url")
    end
  end

  def ip_address_valid?
    return if self.ip.nil?
    unless IPAddress.valid?(self.ip)
      errors.add(:ip, 'Ip in wrong format')
    end
  end
end
