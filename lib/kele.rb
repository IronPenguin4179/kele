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

  def get_mentor_availability(mentor_id)
    response = self.class.get(@base_uri+"/mentors/"+mentor_id+"/student_availability", headers: {"authorization": @auth_token})
    JSON.parse(response.body)
  end
  
  def get_my_mentor_availability
    me = get_me
    get_mentor_availability(me["current_enrollment"]["mentor_id"].to_s)
  end
end