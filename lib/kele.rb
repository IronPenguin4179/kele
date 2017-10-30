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
  
  def get_messages(page_number="1")
    response = self.class.get(@base_uri+"/message_threads", headers: @authorization, body: {"page": page_number})
    JSON.parse(response.body)
  end
  
  def create_message(
    sender, ##="justin.walker4179@email.bakersfieldcollege.edu",
    recipient_id, ##="2376054",
    token = nil,
    subject = nil,
    stripped_text ##="Something cool to tell you about.")
    )
    response = self.class.post(@base_uri+"/messages", body: {
      "sender": sender,
      "recipient_id": recipient_id,
      "token": token,
      "subject": subject,
      "stripped-text": stripped_text
    }, headers: @authorization)
    JSON.parse(response.body)
  end
  
  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    enrollment_id = get_me["current_enrollment"]["id"]
    response = self.class.post(@base_uri+"/checkpoint_submissions", body: {
      "checkpoint_id": checkpoint_id,
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "comment": comment,
      "enrollment_id": enrollment_id
    }, headers: @authorization)
    JSON.parse(response.body)
  end
  
  private
  def get_response(url_endpoint)
    self.class.get(@base_uri+url_endpoint, headers: @authorization)
  end
end