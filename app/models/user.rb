class User < ActiveRecord::Base
  # prvent mass assignment vulnerability
  # allows the active_cord method: update_attributes
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
						   :dependent => :destroy

  has_many :reverse_relationships, :foreign_key => "followed_id",
								   :class_name => "Relationship",
								   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :followed
  has_many :following, :through => :relationships, :source => :followed

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
  				    :length     => { :maximum => 50},
					:uniqueness => true

  validates :email, :presence   => true,
					:format     => { :with => email_regex}, 
					:uniqueness => { :case_sensitive => false}

  validates :password, :presence => true,
					   :confirmation => true,
					   :length => { :within => 6..40 }
  # encypt it before saving it
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password
  def has_password?(submitted_password)
	  # Compare encrypted_password with the encrypted version of submitted_password
	  puts salt
	  puts encrypted_password
	  puts encrypt(submitted_password)
	  encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
	user = find_by_email(email)
	return nil if user.nil?
	return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
	user = find_by_id(id)
	(user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
	relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
	relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
	relationships.find_by_followed_id(followed).destroy
  end

  def feed
	Micropost.from_users_followed_by(self)
  end

  private

	def encrypt_password
	  # self is NOT optional when assigning to an attribute
	  # check to see if passsword is present to prevent nil 
	  # from being saved as a password
	  if password.present?
	  	self.salt = make_salt if new_record?
      	self.encrypted_password = encrypt(password)
	  end
	end

	def encrypt(string)
	  secure_hash("#{salt}--#{string}")
	end

	def make_salt
	  secure_hash("#{Time.now.utc}--#{password}")
	end

	def secure_hash(string)
	  Digest::SHA2.hexdigest(string)
	end

end
