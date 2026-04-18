class HomeController < ApplicationController
  def index
    @cases = Case.published.with_attached_cover_image.order(
      Arel.sql("CASE WHEN company = 'Dodo Brands' THEN 0 WHEN company = 'Ozon' THEN 1 ELSE 2 END, created_at DESC")
    ).limit(5)
    @logo_cases = Case.published.where(company: [ "ОТП Банк", "Альфа", "Сбер", "Dodo Brands", "Авито", "МТС Финтех" ]).index_by(&:company)
    @terms = Term.published.order(:term).limit(8)
    @resources = Resource.published.with_attached_cover_image.order(created_at: :desc).limit(6)
    @case_application = CaseApplication.new
  end
end
