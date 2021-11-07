class SearchAnalytic < AnalyticsRecord
  belongs_to :user
  before_save :increase_count

  def increase_count
    self.count += 1 unless text_changed? && new_record?
  end
end
