class GeoLocation < ApplicationRecord
  include Workflow
  validates :key, presence: true, uniqueness: true
  validate :ip_address_valid?
  validate :key_processable?

  # This is a simplified regexp to accomplish url validation,
  # for prod it should most likely rely on a lib that is updated or moved to own module/class.
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

  scope :delayed, -> { where(workflow_state: 'delayed') }

  after_create :enqueue_ip_resolver

  def stripped_key
    key.gsub('https://', '').gsub('http://','')
  end

  def cache_key
    'geolocation/' + key.to_s
  end

  def self.find_by_id_or_key(id_or_key)
    if id_or_key.is_a?(Numeric) || /^\d+$/ =~ id_or_key || id_or_key.blank?
      find_by(id: id_or_key)
    else
      find_by(key: id_or_key)
    end
  end

  def enqueue_ip_resolver
    GeolocationResolverWorker.perform_async(self.key)
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
