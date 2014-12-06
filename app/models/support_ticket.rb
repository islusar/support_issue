class SupportTicket < ActiveRecord::Base
  before_create :generate_code
  after_create :send_mail

  validates :user_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :question, presence: true, length: { maximum: 300 }
  validates :subject, presence: true

  def send_mail
    UserMailer.support_question(self).deliver
  end

  def generate_code
    code =[]
    code << ('a'..'z').to_a.sample(3).join
    code << SecureRandom.hex(1)
    code << ('a'..'z').to_a.sample(3).join
    code << SecureRandom.hex(1)
    code << ('a'..'z').to_a.sample(3).join
    self.code = code.join('-')
  end
end