# frozen_string_literal: true

class PostcodeDecorator < Wallaby::ResourceDecorator
  def to_label
    "Postcode #{postcode}"
  end
end
