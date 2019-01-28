# frozen_string_literal: true

require_relative 'gossip'

class Comment
  attr_reader :author, :content, :id, :gossip_id

  def initialize(gossip_id, author, content)
    @content = content
    @author = author
    @gossip_id = gossip_id
    save
    @id = Comment.count(gossip_id)
  end

  def get_comment_per_id(id)
    Comment.all_for_id(gossip_id)[id.to_i - 1]
  end

  def save
    csv_file = Comment.create_CSV(@gossip_id)

    array_of_comments_arrays =
      CSV.read(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv")

    array_of_comments_arrays.push([@author.to_s, @content.to_s])

    f = File.open(Dir.getwd + "/db/comments-for-gossip-#{@gossip_id}.csv", 'w+')
    f.write(array_of_comments_arrays
       .map { |comment_array| comment_array.join(',') }
        .join("\n"))
    f.close
  end

  def self.create_CSV(id)
    c = CSV.open(Dir.getwd + "/db/comments-for-gossip-#{id}.csv", 'a')
    c.close
    c
  end

  def self.update_per_id(id, new_author, new_content)
    array_of_comments_arrays =
      CSV.read(Dir.getwd + "/db/comments-for-gossip-#{id}.csv")

    array_of_comments_arrays[id.to_i - 1] = [new_author, new_content]

    f = File.open(Dir.getwd + "/db/comments-for-gossip-#{id}.csv", 'w+')
    f.write(array_of_comments_arrays
      .map { |comment_array| comment_array.join(',') }
       .join("\n"))
    f.close
  end

  def self.count(gossip_id)
    Comment.all_for_id(gossip_id).length
  end

  def self.all_for_id(gossip_id)
    Comment.create_CSV(gossip_id)
    all_comments_array = []
    CSV.foreach(Dir.getwd + "/db/comments-for-gossip-#{gossip_id}.csv") do |comment_array|
      all_comments_array << comment_array
    end
    all_comments_array
  end
end
