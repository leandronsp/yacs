#!/usr/bin/env ruby

require 'adelnor'
require 'chespirito'

require './app/controllers/geonames_controller'
require './app/controllers/search_controller'
require './app/controllers/not_found_controller'

app =
  Chespirito::App.configure do |app|
    app.register_route('GET', '/',        [GeonamesController, :index])
    app.register_route('POST', '/search', [SearchController, :create])
    app.register_system_route(:not_found, [NotFoundController, :show])
  end

Adelnor::Server.run app, 4000
