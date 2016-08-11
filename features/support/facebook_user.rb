class FacebookUser

  attr_accessor :response, :user_access_token, :id, :login_url, :email, :password

  def initialize response
    self.response = response
    self.user_access_token = response["access_token"]
    self.id = response ["id"]
    self.login_url = response["login_url"]
    self.email = response["email"]
    self.password = response["password"]
  end

end