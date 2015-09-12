# Sliver-Rails

Rails-focused extensions to the [Sliver](https://github.com/pat/sliver) API libary.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'sliver-rails', '0.1.1'
```

## Usage

Slightly different to the pure Sliver approach, instead of including the `Sliver::Action` module, you should instead inherit from `Sliver::Rails::Action`.

```ruby
app = Sliver::API.new do |api|
  api.connect :get, '/changes/:id', ChangeAction
end

class ChangeAction < Sliver::Rails::Action
  def call
    change = Change.find path_params['id']

    response.status = 200
    response.body   = ["Change: #{change.name}"]
  end
end
```

### Parameters

Just like in Rails controllers, all incoming request parameters are treated as strong parameters, so you can be explicit about what you're expecting to receive.

```ruby
class V1::Changes::Create < Sliver::Rails::Action
  def call
    change = Change.create change_params

    response.status = 200
    response.body   = ["Success"]
  end

  private

  def change_params
    params.fetch(:change, {}).permit(:name, :description)
  end
end
```

### JSON Requests

If the content-type of the request has been set to `application/json`, then the request body data sent through in POST and PUT requests is parsed and available via the `params` method.

### Inbuilt JSON Processor

Most modern APIs will return JSON-formatted data - and so a Sliver Processor is provided to automatically translate response bodies into JSON. So, in the example below, the response body will be transformed to `"{\"status\":\"OK\"}"`, and the Content-Type header will be set to `application/json`.

```ruby
class V1::Changes::Create < Sliver::Rails::Action
  def self.processors
    [Sliver::Rails::Processors::JSONProcessor]
  end

  def call
    change = Change.create change_params

    response.status = 200
    response.body   = {:status => "OK"}
  end

  private

  def change_params
    params.fetch(:change, {}).permit(:name, :description)
  end
end
```

### JSON templates and exposed variables

The JSON Processor can also use a Jbuilder template (provided you've got the `jbuilder` gem in your Gemfile) via the `use_template` method. Similarly to [decent_exposure](https://github.com/voxdolo/decent_exposure) (although without most of the features), anything specified with a `expose` call is available in the template view.

```ruby
class V1::Changes::Create < Sliver::Rails::Action
  # This will use app/views/api/changes/show.jbuilder
  use_template 'api/changes/show'

  expose(:change) { Change.new change_params }

  def self.processors
    [Sliver::Rails::Processors::JSONProcessor]
  end

  def call
    response.status = 200 if change.save

    # If you use response.body, the template will not be used.
    # response.body = {:status => 'OK'}
  end

  private

  def change_params
    params.fetch(:change, {}).permit(:name, :description)
  end
end

# app/views/api/changes/show.jbuilder
json.(change, :name, :description)
```

This is a very simple example, but your Jbuilder templates can be as complex as you like. Blocks provided for `expose` will only be evaluated once and remembered - and if no block is provided, it looks for a private method of the same name (which is also only evaluated once when referenced from the template).

The default template is an instance of `Sliver::Rails::JBuilderTemplate`, which has one method available beyond what you've exposed: `routes`, which provides access to your Rails route helper methods. No other Rails helper methods are provided by default, but you can use your own template if you'd like:

```ruby
# config/initializers/sliver.rb
class ApiTemplate
  include ActionView::Helpers::NumberHelper

  def routes
    Rails.application.routes
  end
end

Rails.application.config.after_initialize do
  Sliver::Rails.template_class = ApiTemplate
end
```

### Common directory and file structures

This is not enforced by this gem, but it's a habit we at [Inspire9](http://inspire9dev.com) have fallen into:

* Separate APIs for separate versions.
* `app/apis/v1.rb` contains the API definition
* `app/apis/v1/posts/create.rb`, `app/apis/v1/posts/show.rb`, `app/apis/v1/posts/index.rb` and so forth covering CRUD behaviour for resources.
* All endpoint classes inherit from an app-specific base class (covering things like `current_user`, setting guards and processors), and that base class inherits from `Sliver::Rails::Action`.

## Contributing

Please note that this project now has a [Contributor Code of Conduct](http://contributor-covenant.org/version/1/0/0/). By participating in this project you agree to abide by its terms.

1. Fork it ( https://github.com/pat/sliver-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
