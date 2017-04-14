# require 'grape-swagger'

module API
  class Root < Grape::API
    prefix 'api'
    format :json
    
    before do
      header 'Access-Control-Allow-Origin', '*'
      header 'Access-Control-Request-Method', '*'
    end


    helpers do

      def transform_items items
        items.map(&:transform)
      end

      def error_builder messages, code
        error!({errors: messages, code: code}, code)
      end

      def authenticate class_name
        error_builder "Unauthorized", 501 unless logged_in class_name
      end

      def logged_in class_name
        token = headers['Token']
        error_builder "Unauthorized #{class_name}", 501 unless token
        profile = ApplicationHelper::get_profile_from_token token, class_name
        if profile.nil? || (profile.jwt_token!=token)
           error_builder "UnAuthorized #{class_name}", 501
        end
        profile
      end
    end


    rescue_from :all do |e|
      error!({ errors: e.backtrace ,message: e.message , code: 500}, 500)
    end

    
  mount Users
  end


  
end 