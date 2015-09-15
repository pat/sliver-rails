class Sliver::Rails::JBuilderTemplate
  def routes
    Rails.application.routes.url_helpers
  end
end
