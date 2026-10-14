# frozen_string_literal: true

require 'rails_helper'

# Security regression specs: internal error/DB messages must not be reflected to
# the client.
#
# Wallaby maps `ActiveRecord::StatementInvalid` (and
# `ActionController::ParameterMissing`) onto 4xx error pages. Their raw messages
# leak schema/implementation detail, so only Wallaby's own (user-facing) error
# classes may have their message rendered. See the security audit finding L-1.
describe 'error pages', type: :request do
  it 'does not render the ParameterMissing detail' do
    http :post, '/admin/products'
    expect(response.status).to eq 400
    expect(response.body).not_to include 'param is missing'
  end

  it 'still serves a page for user-facing Wallaby errors' do
    http :get, '/admin/all_postgres_types/not-a-real-id'
    expect(response.status).to eq 404
  end
end

describe Wallaby::ApplicationConcern, '#user_facing_message' do
  # `ApplicationConcern`'s `included` hook calls controller DSL methods, so we
  # exercise the method through a real controller instance.
  subject { Wallaby::ResourcesController.new }

  it 'returns the message for Wallaby errors' do
    expect(subject.send(:user_facing_message, Wallaby::NotFound.new('nope'))).to eq 'nope'
  end

  it 'hides messages for non-Wallaby (internal) errors' do
    expect(subject.send(:user_facing_message, ActiveRecord::StatementInvalid.new('SECRET'))).to be_nil
    expect(subject.send(:user_facing_message, ActionController::ParameterMissing.new('product'))).to be_nil
  end

  it 'returns nil when there is no exception' do
    expect(subject.send(:user_facing_message, nil)).to be_nil
  end
end
