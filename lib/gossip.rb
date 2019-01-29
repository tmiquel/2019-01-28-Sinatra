# frozen_string_literal: true

require_relative 'comment'

class Gossip
  attr_reader :author, :content, :id, :comments
  @@count = 0

  def initialize(author, content)
    @content = content
    @author = author
    Gossip.create_CSV
    save unless Gossip.all.include?([@author.to_s, @content.to_s])
    @id = Gossip.all.length
    @comments = []
    @@count += 1
  end

  def self.create_CSV
    c = CSV.open(Dir.getwd + '/db/gossip.csv', 'a')
    c.close
    c
  end

  def self.get_per_id(id)
    Gossip.all[id.to_i - 1]
  end

  def self.update_per_id(id, new_author, new_content)
    array_of_gossips_arrays =
      CSV.read(Dir.getwd + '/db/gossip.csv')

    array_of_gossips_arrays[id.to_i - 1] = [new_author, new_content]

    f = File.open(Dir.getwd + '/db/gossip.csv', 'w+')
    f.write(array_of_gossips_arrays
      .map { |gossip_array| gossip_array.join(',') }
       .join("\n"))
    f.close
   end

  def self.count
    Gossip.all.length
    end

  def self.all
    all_gossips_array = []
    CSV.foreach(Dir.getwd + '/db/gossip.csv') do |gossip_array|
      all_gossips_array << gossip_array
    end
    all_gossips_array
  end

  def save
    array_of_gossips_arrays =
      CSV.read(Dir.getwd + '/db/gossip.csv')

    array_of_gossips_arrays.push([@author.to_s, @content.to_s])

    f = File.open(Dir.getwd + '/db/gossip.csv', 'w+')
    f.write(array_of_gossips_arrays
      .map { |gossip_array| gossip_array.join(',') }
       .join("\n"))
    f.close
  end
end
