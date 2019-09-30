class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :password, presence: true
  has_many :job_cards, foreign_key: "created_by_id"

  has_many :petty_cashes, foreign_key: 'created_by_id'
  def is?(role)
    self.role == role
  end
end
