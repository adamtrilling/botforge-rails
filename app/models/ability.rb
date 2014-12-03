class Ability
  include CanCan::Ability

  def initialize(user)
    return nil if user.nil?

    can :manage, Bot, user_id: user.id
  end
end
