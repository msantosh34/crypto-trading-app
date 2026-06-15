class User < ApplicationRecord
  include RailsJwtAuth::Authenticatable

  enum role: { user: 0, admin: 1 }

  has_one :profile, dependent: :destroy
  has_one :kyc, dependent: :destroy
  has_many :wallets, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :trades, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  after_create :create_profile
  after_create :create_wallets
  after_create :send_welcome_email

  def create_profile
    Profile.create!(user: self)
  end

  def create_wallets
    Currency.all.each do |currency|
      Wallet.create!(user: self, currency: currency, balance: 0)
    end
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
