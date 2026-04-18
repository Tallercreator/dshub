class CaseApplicationsController < ApplicationController
  def create
    @case_application = CaseApplication.new(case_application_params)

    if @case_application.save
      redirect_to root_path(anchor: "share-case"), notice: "Спасибо! Мы свяжемся с вами в Telegram."
    else
      redirect_to root_path(anchor: "share-case"), alert: @case_application.errors.full_messages.to_sentence
    end
  end

  private

  def case_application_params
    params.require(:case_application).permit(:name, :telegram, :company, :other_contact)
  end
end
