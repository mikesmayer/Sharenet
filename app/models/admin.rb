class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable,
         :registerable,
         :trackable,
         #:recoverable,
         :validatable

#  :database_authenticatable, :registerable,
#      :recoverable, :rememberable, :trackable, :validatable
end