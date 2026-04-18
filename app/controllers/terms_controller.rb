class TermsController < ApplicationController
  def index
    @categories = Term::CATEGORIES
    @selected_category = params[:category]
    @terms = Term.published.with_attached_image.by_category(@selected_category).order(:term)
  end

  def show
    @term = Term.published.with_attached_image.with_attached_examples.find(params[:id])
    @mentioned_cases = @term.mentioned_in_cases.published.with_attached_cover_image.limit(6)
    @more_terms = Term.published.where.not(id: @term.id).with_attached_image.order("RANDOM()").limit(5)
  end
end
