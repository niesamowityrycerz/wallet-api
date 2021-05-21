app_url = Rails.env.prodcution? ? ENV['PRODUCTION_URL'] : 'http://localhost:3000'

GrapeSwaggerRails.options.url      = '/swagger_doc.json'
GrapeSwaggerRails.options.app_url  = app_url + '/api/v1/'
