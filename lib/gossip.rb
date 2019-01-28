# frozen_string_literal: true

class Gossip
  attr_reader :author, :content, :id

  def initialize(author, content)
    @content = content
    @author = author
    save
    @id = Gossip.all.length
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

  def self.destroy_gossip(index_integer)
    array_of_gossips_arrays =
      CSV.read(Dir.getwd + '/db/gossip.csv')

    array_of_gossips_arrays.delete_at(index_integer)

    f = File.open(Dir.getwd + '/db/gossip.csv', 'w+')
    f.write(array_of_gossips_arrays
      .map { |gossip_array| gossip_array.join(',') }
       .join("\n"))
    f.close
    end

  def save
    CSV.open('./db/gossip.csv', 'ab') do |csv|
      csv << [@author, @content]
    end
    end
end
