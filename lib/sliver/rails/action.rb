class Sliver::Rails::Action
  include Sliver::Action

  def self.expose(name, options = {}, &block)
    define_method "#{name}_without_caching", &block
    define_method(name) do
      @exposed_methods ||= {}
      @exposed_methods[name] ||= send "#{name}_without_caching"
    end

    private "#{name}_without_caching" unless options[:public]
    private name                      unless options[:public]

    locals << name
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
    @request_params ||= json_request? ? JSON.parse(request.body.read) :
      request.params
  end

  def set_response(status, body = nil)
    response.status = status
    response.body   = body unless body.nil?
  end
end
