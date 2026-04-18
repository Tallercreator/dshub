class ResourcesController < ApplicationController
  def index
    @resource_types = Resource::RESOURCE_TYPES
    @selected_types = Array(params[:resource_type]).reject(&:blank?)

    scope = Resource.published.order(created_at: :desc)
    scope = scope.where(resource_type: @selected_types) if @selected_types.any?
    @resources = scope
  end
end
