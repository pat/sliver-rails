module Sliver::Rails::Pagination
  def self.included(base)
    base.expose(:page)     { params['page'].try(:to_i) || 1 }
    base.expose(:per_page) { [(params['per_page'].try(:to_i) || 20), 100].min }
  end
end
