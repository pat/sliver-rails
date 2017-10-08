# frozen_string_literal: true

require "sliver"
require "rails"

module Sliver::Rails
  module Processors; end

  def self.template_class
    @template_class || Sliver::Rails::JBuilderTemplate
  end

  def self.template_class=(klass)
    @template_class = klass
  end

  def self.view_paths
    @view_paths || Rails.root.join("app/views").to_s
  end

  def self.view_paths=(paths)
    @view_paths = paths
  end
end

require "sliver/rails/action"
require "sliver/rails/jbuilder_renderer"
require "sliver/rails/jbuilder_template"
require "sliver/rails/pagination"
require "sliver/rails/processors/json_processor"
