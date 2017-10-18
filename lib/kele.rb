require 'httparty'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  
  def initialize(e, p)
    @auth = {email: e, password: p}
    self.class.post('https://www.bloc.io/api/v1/sessions', @auth)
  end

end