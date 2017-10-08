# frozen_string_literal: true

class Sliver::Rails::Processors::JSONProcessor < Sliver::Hook
  def call
    response.status                ||= 200
    response.body                    = [body]
    response.headers["Content-Type"] = "application/json"
  end

  private

  def body
    return templated_body unless skip_template?
    return ""             unless response.body.present?

    response.body.is_a?(String) ? response.body : response.body.to_json
  end

  def skip_template?
    response.body.present? || template.nil?
  end

  def template
    action.class.template
  end

  def templated_body
    Sliver::Rails::JBuilderRenderer.call template, action.locals
  end
end
