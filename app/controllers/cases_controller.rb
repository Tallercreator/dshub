class CasesController < ApplicationController
  FOCUSES = ["Архитектура", "Токены", "Документация", "Компоненты"].freeze

  def index
    @industries = Case::INDUSTRIES
    @case_types = Case::CASE_TYPES
    @focuses = FOCUSES
    @company_types = Case::COMPANY_TYPES
    @materials = Case::MATERIALS

    @selected_industries = Array(params[:industry]).reject(&:blank?)
    @selected_case_types = Array(params[:case_type]).reject(&:blank?)
    @selected_focuses = Array(params[:focus]).reject(&:blank?)
    @selected_company_types = Array(params[:company_type]).reject(&:blank?)
    @selected_materials = Array(params[:materials]).reject(&:blank?)

    @sort = %w[newest oldest].include?(params[:sort]) ? params[:sort] : "newest"
    # Экспертные интервью всегда идут первыми, затем обзоры
    interview_first = Arel.sql("CASE WHEN case_format = 'Экспертное интервью' THEN 0 ELSE 1 END ASC")
    created_order = @sort == "oldest" ? :asc : :desc

    @cases = Case.published
      .with_attached_cover_image
      .by_industry(@selected_industries)
      .by_case_type(@selected_case_types)
      .by_focus(@selected_focuses)
      .by_company_type(@selected_company_types)
      .by_materials(@selected_materials)
      .order(interview_first)
      .order(created_at: created_order)

    @any_filter_active = [
      @selected_industries, @selected_case_types, @selected_focuses,
      @selected_company_types, @selected_materials
    ].any?(&:any?)
  end

  def show
    @case = Case.published.with_attached_cover_image.includes(:recommended_resources).find(params[:id])
    @recommended_resources = @case.recommended_resources.where(published: true).order(:resource_type, :title)
    @mentioned_terms = @case.mentioned_terms.published.with_attached_image.order(:term)
  end
end
