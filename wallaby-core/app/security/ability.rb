# frozen_string_literal: true

# @!visibility private
# Default ability for {Wallaby}
# If main app has defined `ability.rb`, this file will not be loaded/used.
class Ability
  include ::CanCan::Ability if defined?(::CanCan)

  # @param _user [Object]
  def initialize(_user)
    can :manage, :all
  end
end
