class GeoLocation < ApplicationRecord
  include Workflow
  validates :key, presence: true, uniqueness: true
  validate :ip_address_valid?
  validate :key_processable?

  URL_REGEX = /(^$)|(^(http|https)?:?\/?\/?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  workflow do
    state :new do
      event :enqueue, :transitions_to => :enqueued
    end
    state :enqueued do
      event :resolve, :transitions_to => :resolved
      event :delay, :transitions_to => :delayed
      event :fail_permanently, :transitions_to => :failed_permanently
    end
    state :delayed do
      event :resolve, :transitions_to => :resolved
      event :fail_permanently, :transitions_to => :failed_permanently
    end
    state :resolved
    state :failed_permanently
  end

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
