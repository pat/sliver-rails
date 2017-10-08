# frozen_string_literal: true

class Sliver::Rails::JBuilderRenderer
  def self.call(template, locals = {})
    new(template, locals).call
  end

  def initialize(template, locals = {})
    @template = template
    @locals   = locals
  end

  def call
    engine.render Sliver::Rails.template_class.new, locals
  end

  private

  attr_reader :template, :locals

  def engine
    Tilt.new template_path, nil, :view_path => views_path
  end

  def template_path
    template_with_ext = template
    template_with_ext = "#{template}.jbuilder" unless template[/\.jbuilder$/]

    File.join views_path, template_with_ext
  end

  def views_path
    Sliver::Rails.view_paths
  end
end
