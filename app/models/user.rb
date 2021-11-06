class User < ApplicationRecord
  enum role: {
    admin: 'admin',
    regular: 'regular'
  }

  before_save :downcase_email
  has_secure_password

  STRONG_PASSWORD = /(?=.*[a-zA-Z])(?=.*[0-9]).{6,10}/.freeze

  validates :password, presence: true, format: { with: STRONG_PASSWORD }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_confirmation_of :password_confirmation,
                            message: 'password does match confirmation',
                            on: :create

  after_initialize :assign_basic_role, if: :new_record?

  def downcase_email
    self.email = email.strip.downcase
  end

  def assign_basic_role
    self.role = User.roles[:regular]
  end
end
