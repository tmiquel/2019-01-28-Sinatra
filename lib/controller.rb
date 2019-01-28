#! usr/bin/env ruby
# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index
  end
end
