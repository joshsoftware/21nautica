# frozen_string_literal: true

module Remarkable
  extend ActiveSupport::Concern

  included do
    has_many :remarks, as: :remarkable, :dependent => :destroy
  end
end
