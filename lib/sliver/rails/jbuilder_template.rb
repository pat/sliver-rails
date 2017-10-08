# frozen_string_literal: true

class Sliver::Rails::JBuilderTemplate
  def routes
    Rails.application.routes.url_helpers
  end
end
