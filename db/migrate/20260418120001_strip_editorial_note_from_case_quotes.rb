class StripEditorialNoteFromCaseQuotes < ActiveRecord::Migration[8.0]
  FRAGMENT = /\s*Примечание:\s*цитаты приведены из расшифровки интервью\.\s*Для публикации в сервисе рекомендуется оставлять\s*1[–\-]2 предложения и подписывать роль респондента\.\s*/m

  def up
    Case.where("quotes ILIKE ?", "%расшифровки интервью%").find_each do |kase|
      cleaned = kase.quotes.gsub(FRAGMENT, "").strip
      kase.update_column(:quotes, cleaned.presence)
    end
  end

  def down
    # No-op: editorial note is not restored.
  end
end
