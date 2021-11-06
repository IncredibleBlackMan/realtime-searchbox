class Article < ApplicationRecord
  enum status: {
    draft: 'draft',
    published: 'published'
  }

  belongs_to :user

  validates :title, :introduction, :content, :status, presence: true

  after_initialize :assign_draft_status, if: :new_record?

  def assign_draft_status
    self.status = Article.statuses[:draft]
  end
end
