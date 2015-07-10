class Sliver::Rails::Action
  include Sliver::Action

  BODIED_METHODS = %w( post put patch )

  def self.call(environment)
    request = ::Rack::Request.new environment
    Rails.logger.info "Processing by #{name}"
    if request.params.any?
      Rails.logger.info "  Parameters: #{request.params.inspect}"
    end

    super
  end

  def self.expose(name, options = {}, &block)
    add_exposed_methods name, options, &block if block_given?

    locals << name
  end

  def self.add_exposed_methods(name, options = {}, &block)
    uncached_name = "#{name}_without_caching"

    define_method uncached_name, &block
    define_method(name) do
      @exposed_methods ||= {}
      @exposed_methods[name] ||= send uncached_name
    end

    return if options[:public]

    private uncached_name
    private name
  end

  def self.locals
    @locals ||= []
  end

  def self.template
    @template
  end

  def self.use_template(template)
    @template = template
  end

  def call
    #
  end

  def locals
    self.class.locals.inject({}) do |hash, name|
      hash[name] = send name
      hash
    end
  end

  private

  def bodied_request?
    BODIED_METHODS.include? environment['REQUEST_METHOD'].downcase
  end

  def content_type_header
    environment['Content-Type']      ||
    environment['HTTP_CONTENT_TYPE'] ||
    environment['CONTENT_TYPE']
  end

  def content_types
    content_type_header.split(/;\s?/)
  end

  def json_request?
    content_types.include? 'application/json'
  end

  def params
    ActionController::Parameters.new request_params
  end

  def request_params
    @request_params ||= if bodied_request? && json_request?
      JSON.parse(request.body.read)
    else
      request.params
    end
  end

  def set_response(status, body = nil)
    response.status = status
    response.body   = body unless body.nil?
  end
end
