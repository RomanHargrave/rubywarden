ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

# clear out test db
if File.exist?(f = File.dirname(__FILE__) + "/../db/test.sqlite3")
  File.unlink(f)
end

# most tests require this to be on
ALLOW_SIGNUPS = true

require File.realpath(File.dirname(__FILE__) + "/../lib/rubywarden.rb")
require "#{APP_ROOT}/lib/app.rb"

#load 'db/schema.rb'
ActiveRecord::Migrator.up "db/migrate"

include Rack::Test::Methods

#ActiveRecord::Migration.maintain_test_schema!

def last_json_response
  JSON.parse(last_response.body)
end

def get_json(path, params = {}, headers = {})
  json_request :get, path, params, headers
end

def post_json(path, params = {}, headers = {})
  json_request :post, path, params, headers
end

def put_json(path, params = {}, headers = {})
  json_request :put, path, params, headers
end

def delete_json(path, params = {}, headers = {})
  json_request :delete, path, params, headers
end

def json_request(verb, path, params = {}, headers = {})
  send verb, path, params.to_json,
    headers.merge({ "CONTENT_TYPE" => "application/json" })
end

def app
  Rubywarden::App
end
