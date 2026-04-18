class Resource < ApplicationRecord
  RESOURCE_TYPES = ["Статья", "Видео", "Сайт", "Кейс"].freeze

  has_one_attached :cover_image

  has_many :case_resources, dependent: :destroy
  has_many :cases, through: :case_resources

  scope :published, -> { where(published: true) }
  scope :by_type, ->(resource_type) { where(resource_type: resource_type) if resource_type.present? }

  before_validation :normalize_url

  validates :title, presence: true
  validates :url, presence: true
  validates :resource_type, inclusion: { in: RESOURCE_TYPES }, allow_blank: true

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  # Safe URL for rendering links. Prepends https:// if the scheme is missing.
  def safe_url
    value = url.to_s.strip
    return value if value.empty?
    return value if value.match?(%r{\Ahttps?://}i)

    "https://#{value}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id resource_type title tags url published created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[case_resources cases]
  end

  private

  def normalize_url
    return if url.blank?

    self.url = url.strip
    return if url.match?(%r{\Ahttps?://}i)

    self.url = "https://#{url}"
  end
end
