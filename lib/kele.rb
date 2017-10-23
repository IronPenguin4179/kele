require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(email, password)
    @base_uri = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_uri+"/sessions", body: { "email": email, "password": password })
    @auth_token = response["auth_token"]
  end
  
  def get_me
    response = self.class.get(@base_uri+"/users/me", headers: {"authorization": @auth_token})
    JSON.parse(response.body)
  end

end