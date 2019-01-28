#! usr/bin/env ruby
# frozen_string_literal: true

require_relative 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: { gossips: Gossip.all }
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    Gossip.new(params['gossip_author'], params['gossip_content'])
    redirect '/'
  end

  get '/gossips/get_gossip_id/' do
    erb :get_gossip_id, locals: { gossips_count: Gossip.count }
  end

  post '/gossips/get_gossip_id/' do
    erb :get_gossip_id, locals: { gossips_count: Gossip.count }
    redirect to('gossips/' + params['gossip_id'].to_s + '/')
  end

  get %r{/gossips/([\d]+)/} do |id|
    erb :show_gossip, locals: { gossip: Gossip.get_per_id(id), id: id }
  end

  get %r{/gossips/([\d]+)/edit/} do |id|
    erb :edit_gossip, locals: { gossip: Gossip.get_per_id(id), id: id }
  end

  post %r{/gossips/([\d]+)/edit/} do |id|
    Gossip.update_per_id(id, params['new_author'], params['new_content'])
    redirect to('gossips/' + id.to_s + '/edited/')
  end

  get %r{/gossips/([\d]+)/edited/} do |id|
    erb :edited_gossip, locals: { gossip: Gossip.get_per_id(id), id: id }
  end
end
