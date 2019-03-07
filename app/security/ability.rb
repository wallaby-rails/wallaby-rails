# @!visibility private
# Defualt ability for wallaby
# If main app has defined `ability.rb`, this file will not be loaded/used.
class Ability
  include ::CanCan::Ability

  # @param _user [Object]
  def initialize(_user)
    can :manage, :all
  end
end
