class User < ApplicationRecord

  validates :username, presence: true, uniqueness: true
  # validates :password,
  validates :password_digest, :session_token, presence: true
  after_initialize :ensure_session_token

  has_many :cheers,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cheer

  has_many :comments,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Comment

  has_many :goals,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Goal 

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
