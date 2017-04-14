class Users < Grape::API
  prefix 'api/user'
  format :json


  desc "register a user"
  params do
    requires :public_key , allow_blank: false, type:String
    requires :email , allow_blank: false, type:String, regexp:  /.+@.+/
    requires :password , allow_blank: false, type:String, regexp: /.{6,}/
    requires :full_name, allow_blank: false, type:String
  end

  put 'register' do
    user =  User.new(email: params[:email],
                         password: params[:password],
                         full_name: parmas[:full_name]
                         )

    if user.valid?
       user.save
       GlobalKey.new(public_key: params[:public_key] , user_id: user.id)
      { message: "registered user" }
    else
      error_builder user.errors.full_messages,500
    end
  end

  desc "User Login"
  params do
    requires :email, allow_blank: false, type:String
    requires :password, allow_blank: false, type:String
  end

  post 'login' do
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      ApplicationHelper::create_jwt_token(user)
      user.update_attribute(:online, true)
      user.update_attribute(:jwt_token,user.jwt_token)
      { :key => user.jwt_token,:user_details => user.transform , notifications: user.get_notifications, preferences: user.preferences.inject({}) { |hash,pref| hash.merge ( pref.transform ) } }
    else
      error_builder 'Please enter valid credentials', 500
    end
  end


  desc "User Logout"

  post "logout" do
    user = logged_in User
    user.update_attribute(:jwt_token,nil)
    user.update_attribute(:device_token,nil)
    user.update_attribute(:online, false)
    { message: "Successfully Logged Out "}
  end


  desc "user messages"

  get "/messages/check" do 
    user = logged_in User
    messages = Message.where(recevier_id: user.id).group_by(&:conversation_id)
    messages.destroy_all
    { messages: messages, message: "add"}
  end

  desc "start conversation"
  params do 
    requires :user_id, allow_blank: :false, type:String
  end
  post "/user_profile" do 
    user = User.find(params[:user_id])
    {message: "found user", user: user, public_key: user.global_key.public_key}
  end

  desc "get all registered_users"
  get "/users/all" do 
    users = User.all
    {message: "nil", users: users}
  end

  desc "create message"
  params do 
    requires :user_id, allow_blank: :false, type:String
    requires :content, allow_blank: :false, type: String
  end
  post "/message/new" do 
    user  = logged_in user
    a = Conversation.where(user_1: user.id, user_2: params[:user_id]).first

    b = Conversation.where(user_2: user.id, user_1: params[:user_id]).first
    if a
      c = a
    else
      c =b
    end
    Message.create(sender_id: user.id, recevier_id: params[:user_id], content: params[:content], conversation_id: c.id)
    {message: "message created"}
  end
end