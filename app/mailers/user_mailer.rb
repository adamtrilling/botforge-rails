class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def confirmation(user, token)
    @user = user
    @token = token

    mail(to: user.email)
  end
end
