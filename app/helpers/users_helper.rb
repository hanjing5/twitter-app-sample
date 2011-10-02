module UsersHelper

	# :size sets te default Gravatar size to 50x50
	def gravatar_for(user, options={:size => 50})
		gravatar_image_tag(user.email.downcase, :alt => user.name,
												:class => 'gravatar',
												:gravatar=>options)
	end
end
