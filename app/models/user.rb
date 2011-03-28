class User < ActiveRecord::Base
  has_many :saved_properties
  has_many :properties, :through => :saved_properties

  has_many :authentications
  has_many :preferences
  has_one :user_info
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def apply_omniauth(omniauth)  
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])  
  end
  
  def password_required?
    print "HEREEEEEEEEE", authentications.empty?, !password.blank?, password.present?, !persisted?, "\n"
    puts authentications.empty? || !password.blank? || password.present? || !persisted?
    (authentications.empty? || !password.blank? || password.present?) && super
  end
end
