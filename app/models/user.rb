class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # has_one_attatched :photo *****
  has_many :notifications, dependent: :destroy
  has_many :image_results, dependent: :destroy
  has_many :cells, through: :image_results

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18 }
  validates :user_name, presence: true, uniqueness: true
end
