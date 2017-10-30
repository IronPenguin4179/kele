require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @base_uri = "https://www.bloc.io/api/v1"
    response = self.class.post(@base_uri+"/sessions", body: { "email": email, "password": password })
    auth_token = response["auth_token"]
    @authorization = {"authorization": auth_token}
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
    body = {"page": page_number}
    response = get_response("/message_threads", body)
    JSON.parse(response.body)
  end
  
  def create_message(sender, recipient_id, stripped_text, subject = nil, token = nil)
    query = {
      "sender": sender,
      "recipient_id": recipient_id,
      "stripped-text": stripped_text,
      "subject": subject,
      "token": token
    }
    response = self.class.post(@base_uri+"/messages", query: query, headers: @authorization)
    puts response.code
  end
  
  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    body = {"checkpoint_id": checkpoint_id,
            "assignment_branch": assignment_branch,
            "assignment_commit_link": assignment_commit_link,
            "comment": comment,
            "enrollment_id": get_me["current_enrollment"]["id"]
    }
    response = post_response("/checkpoint_submissions", body)
    JSON.parse(response.body)
  end
  #2366806
  private
  def get_response(url_endpoint, body={})
    self.class.get(@base_uri+url_endpoint, body: body, headers: @authorization)
  end
  
  def post_response(url_endpoint, body={})
    self.class.post(@base_uri+url_endpoint, body: body, headers: @authorization)
  end
end