class User < ActiveRecord::Base
  # prvent mass assignment vulnerability
  # allows the active_cord method: update_attributes
  attr_accessible :name, :email

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
  				    :length     => { :maximum => 50},
					:uniqueness => true

  validates :email, :presence   => true,
					:format     => { :with => email_regex}, 
					:uniqueness => { :case_sensitive => false}
end
