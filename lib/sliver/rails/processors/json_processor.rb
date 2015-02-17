class Sliver::Rails::Processors::JSONProcessor < Sliver::Hook
  def call
    response.status                ||= 200
    response.body                    = [body]
    response.headers['Content-Type'] = 'application/json'
  end

  private

  def body
    return response.body         if response.body.is_a?(String)
    return response.body.to_json if response.body.present?
    return ''                    if template.nil?

    Sliver::Rails::JBuilderRenderer.call template, action.locals
  end

  def template
    action.class.template
  end
end
