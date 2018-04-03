# frozen_string_literal: true

class User < ApplicationRecord
  # mail
  after_create :send_welcome_email
  # cloudinary upload
  mount_uploader :photo, PhotoUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :brands
  has_many :reviews
  has_many :shopping_carts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def current_shopping_cart
    shoppingCart = ShoppingCart.where(user: self, status: false).first
    if shoppingCart.nil?
      # 4 if we don't have a shopping cart, we create one
      shoppingCart = ShoppingCart.create(user: self, status: false)
    end
    shoppingCart
  end

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

end
