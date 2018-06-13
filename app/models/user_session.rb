class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  
  self.last_request_at_threshold = 10.minutes
end
