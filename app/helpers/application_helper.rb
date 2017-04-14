module ApplicationHelper
  include ConfigFile
  def self.create_jwt_token profile
    # binding.pry
    profile_info  = { :id => profile.id , :email=> profile.email, :full_name=> profile.full_name }
    token = JWT.encode profile_info, ConfigFile::SECRET_KEY, ConfigFile::HASH
    profile.jwt_token = token
    profile.save
  end

  def self.get_profile_from_token token, profile_class
    decoded_token = JWT.decode token, ConfigFile::SECRET_KEY, true, { :algorithm => ConfigFile::HASH }
    profile ||= profile_class.where(id: decoded_token[0]['id'], email: decoded_token[0]['email']).first
  end
end
