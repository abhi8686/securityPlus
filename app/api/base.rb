module Base
  class Root < Grape::API
    prefix 'api'
    format :json
    # before do
    #   header 'Access-Control-Allow-Origin', '*'
    #   header 'Access-Control-Request-Method', '*'
    # end
    
  end
  
end 