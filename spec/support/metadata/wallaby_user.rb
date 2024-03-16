# frozen_string_literal: true

RSpec.configure do |config|
  config.before type: :helper do |example|
    next unless example.metadata.key? :wallaby_user

    allow(controller).to receive(:current_user) { example.metadata[:wallaby_user] }
    allow(controller).to receive(:wallaby_user) { example.metadata[:wallaby_user] }
  end
end
