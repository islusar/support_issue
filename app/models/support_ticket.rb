class SupportTicket < ActiveRecord::Base
  before_create :generate_code
  after_create :send_question_mail
  after_update :send_answer_mail

  belongs_to :admin

  validates :user_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :question, presence: true, length: { maximum: 300 }
  validates :subject, presence: true

  STATUS_WAIT_STAFF = 1
  STATUS_WAIT_CUSTOMER = 2
  STATUS_ON_HOLD = 3
  STATUS_CANCELED = 4
  STATUS_COMPLETED = 5
  STATUSES = [STATUS_WAIT_STAFF, STATUS_WAIT_CUSTOMER, STATUS_ON_HOLD, STATUS_CANCELED]

  scope :new_ticket, -> {where(status: STATUS_WAIT_STAFF, admin_id: nil)}
  scope :opened, -> {where(status: STATUS_WAIT_STAFF).where.not(admin_id: nil)}
  scope :on_hold, -> {where(status: STATUS_ON_HOLD)}
  scope :closed, -> {where(status: [STATUS_CANCELED, STATUS_COMPLETED])}

  def send_question_mail
    SendMail.perform_async(:support_question, self.attributes)
  end

  def send_answer_mail
    SendMail.perform_async(:support_answer, self.attributes) if self.answer_changed?
  end

  def generate_code
    code = 5.times.map do |i|
      i % 2 == 0 ? ('a'..'z').to_a.sample(3).join : SecureRandom.hex(1)
    end
    self.code = code.join('-').upcase
  end

  def change_ownership!(admin)
    self.admin = admin
    self.save!
  end

  def self.search(key)
    search_like = key.gsub(" ", "%")
    where('code = :search OR subject = :search OR question LIKE :search_like', search: key, search_like: "%#{search_like}%")
  end
end