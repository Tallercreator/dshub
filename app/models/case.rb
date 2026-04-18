class Case < ApplicationRecord
  INDUSTRIES = %w[Foodtech Fintech Ecom Proptech Edtech Medtech HRtech].freeze
  CASE_TYPES = ["Экспертное интервью", "Открытый кейс"].freeze
  COMPANY_TYPES = ["Стартап", "Студия", "Бигтех", "Госкомпания", "Продукт"].freeze
  MATERIALS = ["Фигма", "Сайт", "ГитХаб"].freeze
  CASE_FORMATS = ["Экспертное интервью", "Обзор"].freeze

  ALLOWED_COVER_TYPES = %w[image/png image/jpeg image/webp image/svg+xml].freeze
  MAX_COVER_SIZE = 10.megabytes

  has_one_attached :cover_image
  has_one_attached :hero_image

  has_many :case_resources, dependent: :destroy
  has_many :recommended_resources, through: :case_resources, source: :resource

  has_many :term_cases, dependent: :destroy
  has_many :mentioned_terms, through: :term_cases, source: :term

  scope :published, -> { where(published: true) }
  scope :by_industry, ->(values) {
    values = Array(values).reject(&:blank?)
    where(industry: values) if values.any?
  }
  scope :by_case_type, ->(values) {
    values = Array(values).reject(&:blank?)
    where(case_type: values) if values.any?
  }
  scope :by_company_type, ->(values) {
    values = Array(values).reject(&:blank?)
    where(company_type: values) if values.any?
  }
  scope :by_focus, ->(values) {
    values = Array(values).reject(&:blank?)
    next if values.empty?

    clauses = values.map { |_v| "tags ILIKE ?" }.join(" OR ")
    params = values.map { |v| "%#{v}%" }
    where(clauses, *params)
  }
  scope :by_materials, ->(values) {
    values = Array(values).reject(&:blank?)
    next if values.empty?

    clauses = values.map { |_v| "materials ILIKE ?" }.join(" OR ")
    params = values.map { |v| "%#{v}%" }
    where(clauses, *params)
  }

  validates :company, presence: true
  validates :ds_name, presence: true
  validates :industry, inclusion: { in: INDUSTRIES }, allow_blank: true
  validates :case_type, inclusion: { in: CASE_TYPES }, allow_blank: true
  validates :company_type, inclusion: { in: COMPANY_TYPES }, allow_blank: true
  validates :case_format, inclusion: { in: CASE_FORMATS }, allow_blank: true
  validate :validate_cover_image
  validate :validate_hero_image

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def material_list
    materials.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id company ds_name card_title tags accent_color industry case_type case_format company_type materials focus_description speaker_role artifacts intro published created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[cover_image_attachment cover_image_blob case_resources recommended_resources]
  end

  private

  def validate_cover_image
    return unless cover_image.attached?

    unless ALLOWED_COVER_TYPES.include?(cover_image.content_type)
      errors.add(:cover_image, "должно быть PNG, JPEG, WEBP или SVG")
    end

    if cover_image.blob.byte_size > MAX_COVER_SIZE
      errors.add(:cover_image, "не больше 10 МБ")
    end
  end

  def validate_hero_image
    return unless hero_image.attached?

    unless ALLOWED_COVER_TYPES.include?(hero_image.content_type)
      errors.add(:hero_image, "должно быть PNG, JPEG, WEBP или SVG")
    end

    if hero_image.blob.byte_size > MAX_COVER_SIZE
      errors.add(:hero_image, "не больше 10 МБ")
    end
  end
end
