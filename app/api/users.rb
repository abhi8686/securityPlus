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
                         full_name: params[:full_name]
                         )

    if user.valid?
       user.save
       GlobalKey.create(public_key: params[:public_key] , user_id: user.id)
      { message: "registered user" , user: user}
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
    if  user.valid_password?(params[:password])
      ApplicationHelper::create_jwt_token(user)
      user.update_attribute(:jwt_token, user.jwt_token)
      { :key => user.jwt_token }
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


  desc "user update private key for conversation"
  params do 
    requires :user_id, allow_blank: :false, type:String
    requires :public_key, allow_blank: :false, type: String
  end
  post "public_key" do
    user1 = User.find(params[:user_id])
    user2 = logged_in User
    a = Conversation.where(user_1: user1.id, user_2: user2.id).first
    b = Conversation.where(user_2: user1.id, user_1: user2.id).first
    if a
      c = a
    elsif b
      c =b
    else
    end
    if c 
      if c.user_1 == user1.id
        c.user_1_public = params[:public_key]
        c.save
      elsif c.user_2 == user1.id
        c.user_2_public = params[:public_key]
        c.save
      else

      end
    else
      c = Conversation.create(user_1: user1.id, user_2: user2.id, user_2_public: params[:public_key], user_1_public: user1.global_key.public_key)
    end
    {messages: "updated conversation"}
  end

  desc "user messages"
  get "/messages/check" do 
    user = logged_in User
    messages = Message.where(recevier_id: user.id, seen: false)
    messages.map{|x| x.seen = true; x.save}
    { messages: messages}
  end

  desc "start conversation"
  params do 
    requires :user_id, allow_blank: :false, type:String
  end
  post "/user_profile" do 
    user1 = User.find(params[:user_id])
    user2 = logged_in User
    a = Conversation.where(user_1: user1.id, user_2: user2.id).first
    b = Conversation.where(user_2: user1.id, user_1: user2.id).first
    if a
      c = a
    elsif b
      c =b
    else

    end
    if c 
      if c.user_1 == user1.id
        d = c.user_1_public
      else
        d = c.user_2_public
      end
    else
      d = user1.global_key.public_key
    end
    {message: "found user", user: user1, public_key: d }
  end

  desc "get all registered_users"
  get "/all" do 
    user = logged_in User
    users = User.where.not(id: user.id)
    data = {}
    users.map{|x| data[x.id] = {id: x.id, email: x.email, full_name: x.full_name}}
    {message: "list of all users", users: data}
  end

  desc "create message"
  params do 
    requires :user_id, allow_blank: :false, type:String
    requires :content, allow_blank: :false, type: String
  end

  post "/message/new" do 
    user  = logged_in User
    a = Conversation.where(user_1: user.id, user_2: params[:user_id]).first

    b = Conversation.where(user_2: user.id, user_1: params[:user_id]).first
    if a
      c = a
    elsif b
      c = b
    else
    end
    if c 
    else
      c = Conversation.create(user_1: user.id, user_2: params[:user_id])
    end
    Message.create(sender_id: user.id, recevier_id: params[:user_id], content: params[:content], conversation_id: c.id)
    {message: "message created"}
  end
end
