# frozen_string_literal: true

module Spree
  class Supplier < Spree::Base
    extend FriendlyId
    friendly_id :name, use: :slugged

    attr_accessor :password, :password_confirmation

    belongs_to :address, class_name: 'Spree::Address'
    accepts_nested_attributes_for :address

    if defined?(Ckeditor::Asset)
      has_many :ckeditor_pictures, dependent: :destroy
      has_many :ckeditor_attachment_files, dependent: :destroy
    end

    has_many :supplier_variants, dependent: :destroy
    has_many :variants, through: :supplier_variants
    has_many :products, through: :variants
    has_many :stock_locations, dependent: :destroy
    has_many :shipments, through: :stock_locations
    has_many :admins, class_name: Spree.user_class.to_s, dependent: :destroy
    accepts_nested_attributes_for :admins

    validates :commission_flat_rate, presence: true
    validates :commission_percentage, presence: true
    validates :name, presence: true, uniqueness: true
    validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w(http https)), allow_blank: true }

    before_validation :check_url

    before_create :set_commission
    after_create :create_stock_location
    after_create :send_welcome, if: -> { SolidusMarketplace::Config[:send_supplier_email] }

    self.whitelisted_ransackable_attributes = %w[name active]

    scope :active, -> { where(active: true) }

    def deleted?
      deleted_at.present?
    end

    def admin_ids_string
      admin_ids.join(',')
    end

    def admin_ids_string=(admin_ids)
      self.admin_ids = admin_ids.to_s.split(',').map(&:strip)
    end

    # Retreive the stock locations that has available
    # stock items of the given variant
    def stock_locations_with_available_stock_items(variant)
      stock_locations.select { |sl| sl.available?(variant) }
    end

    protected

    def check_url
      return if url.blank? || url =~ (URI::DEFAULT_PARSER.make_regexp(%w(http https)))

      self.url = "http://#{url}"
    end

    def create_stock_location
      return unless stock_locations.empty?

      location = stock_locations.build(
        active: true,
        country_id: address.try(:country_id),
        name: name,
        state_id: address.try(:state_id)
      )
      # It's important location is always created.  Some apps add validations that shouldn't break this.
      location.save validate: false
    end

    def send_welcome; end

    def set_commission
      return if changes.key?(:commission_flat_rate)

      self.commission_flat_rate = SolidusMarketplace::Config[:default_commission_flat_rate]
      return if changes.key?(:commission_percentage)

      self.commission_percentage = SolidusMarketplace::Config[:default_commission_percentage]
    end
  end
end
