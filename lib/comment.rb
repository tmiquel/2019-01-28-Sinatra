# frozen_string_literal: true

require_relative 'gossip'

class Comment
  attr_reader :author, :content, :id, :gossip_id

  def initialize(gossip_id, author, content)
    @content = content
    @author = author
    @gossip_id = gossip_id
    save
    @id = all.length
  end

  def get_per_id(id)
    all[id.to_i - 1]
    end

  def self.update_per_id(id, new_author, new_content)
    array_of_comments_arrays =
      CSV.read(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")

    array_of_comments_arrays[id.to_i - 1] = [new_author, new_content]

    f = File.open(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv", 'w+')
    f.write(array_of_comments_arrays
      .map { |comment_array| comment_array.join(',') }
       .join("\n"))
    f.close
    end

  def count
    all.length
    end

  def all
    all_comments_array = []
    CSV.foreach(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv") do |comment_array|
      all_comments_array << comment_array
    end
    all_comments_array
    end

  def self.destroy_comment(index_integer)
    array_of_comments_arrays =
      CSV.read(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")

    array_of_comments_arrays.delete_at(index_integer)

    f = File.open(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv", 'w+')
    f.write(array_of_comments_arrays
      .map { |comment_array| comment_array.join(',') }
       .join("\n"))
    f.close
    end

  def save
    # CSV.open('./db/gossip.csv', 'ab') do |csv|
    #   csv << [@author, @content]
    # end
    # end

    CSV.open(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")
  rescue StandardError
    system('touch ' + Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")
    array_of_comments_arrays =
      CSV.read(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")

    array_of_comments_arrays.push([@author.to_s, @content.to_s])

    f = File.open(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv", 'w+')
    f.write(array_of_comments_arrays
       .map { |comment_array| comment_array.join(',') }
        .join("\n"))
    f.close
  end
end
