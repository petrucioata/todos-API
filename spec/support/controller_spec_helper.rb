module ControllerSpecHelper
  def token_generator(user_id, time=24.hours.from_now.to_i)
    JsonWebToken.encode({ user_id: user_id }, time)
  end

  def valid_headers
    {
      "Authorization": token_generator(user.id),
      "Content-Type": "application/json"
    }
  end
end
