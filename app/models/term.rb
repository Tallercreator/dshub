class Term < ApplicationRecord
  CATEGORIES = [
    "Архитектура",
    "Процесс",
    "Инструменты",
    "Инфраструктура",
    "Метрики",
    "Команда",
    "Термины DS"
  ].freeze

  ALLOWED_IMAGE_TYPES = %w[image/png image/jpeg image/webp image/svg+xml image/gif].freeze
  MAX_IMAGE_SIZE = 10.megabytes

  has_one_attached :image
  has_many_attached :examples

  has_many :term_cases, dependent: :destroy
  has_many :mentioned_in_cases, through: :term_cases, source: :case

  scope :published, -> { where(published: true) }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  validates :term, presence: true
  validates :definition, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validate :validate_image
  validate :validate_examples

  def to_param
    "#{id}-#{term.to_s.parameterize}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id term category sources purpose context published created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[image_attachment image_blob examples_attachments examples_blobs]
  end

  private

  def validate_image
    return unless image.attached?

    unless ALLOWED_IMAGE_TYPES.include?(image.content_type)
      errors.add(:image, "должно быть PNG, JPEG, WEBP, SVG или GIF")
    end

    if image.blob.byte_size > MAX_IMAGE_SIZE
      errors.add(:image, "не больше 10 МБ")
    end
  end

  def validate_examples
    return unless examples.attached?

    examples.each do |example|
      unless ALLOWED_IMAGE_TYPES.include?(example.content_type)
        errors.add(:examples, "должны быть PNG, JPEG, WEBP, SVG или GIF")
        break
      end
      if example.blob.byte_size > MAX_IMAGE_SIZE
        errors.add(:examples, "каждое не больше 10 МБ")
        break
      end
    end
  end
end
