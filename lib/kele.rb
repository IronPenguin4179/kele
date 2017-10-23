require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(email, password)
    response = self.class.post(url("/sessions"), body: { "email": email, "password": password })
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
  
  def get_my_mentor_availability
    me = get_me
    get_mentor_availability(me["current_enrollment"]["mentor_id"].to_s)
  end
  
  def show_roadmap(roadmap_id)
    response = get_response("/roadmaps/"+roadmap_id)
    JSON.parse(response.body)
  end
  
  def get_checkpoint(checkpoint_id)
    response = get_response("/checkpoints/"+checkpoint_id)
    JSON.parse(response.body)
  end
  
  private
  def get_response(url_endpoint)
    self.class.get("https://www.bloc.io/api/v1"+url_endpoint, headers: @authorization)
  end
end