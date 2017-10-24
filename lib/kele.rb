require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @base_uri = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_uri+"/sessions", body: { "email": email, "password": password })
    @auth_token = response["auth_token"]
    @authorization = {"authorization": @auth_token}
  end
  
  def get_me
    response = get_response("/users/me")
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = get_response("/mentors/"+mentor_id+"/student_availability")
    JSON.parse(response.body)
  end
  
  private
  def get_response(url_endpoint)
    self.class.get(@base_uri+url_endpoint, headers: @authorization)
  end
end