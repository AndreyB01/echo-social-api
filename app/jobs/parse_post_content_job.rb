class ParsePostContentJob < ApplicationJob
  queue_as :default

  HASHTAG_REGEX = /#\w+/i
  MENTION_REGEX = /@\w+/i

  def perform(post_id)
    post = Post.find_by(id: post_id)

    return unless post

    parse_hashtags(post)
    parse_mentions(post)
  end

  private

  def parse_hashtags(post)
    tags = post.body.scan(HASHTAG_REGEX)
                    .map { |tag| tag.delete("#").downcase }
                    .uniq

    post.hashtags.clear

    tags.each do |tag_name|
      hashtag = Hashtag.find_or_create_by!(name: tag_name)

      post.post_hashtags.find_or_create_by!(hashtag: hashtag)
    end
  end

  def parse_mentions(post)
    usernames = post.body.scan(MENTION_REGEX)
                         .map { |mention| mention.delete("@").downcase }
                         .uniq

    post.mentioned_users.clear

    usernames.each do |username|
      user = User.find_by(username: username)

      next unless user

      post.post_mentions.find_or_create_by!(user: user)

      NotifyMentionsJob.perform_later(post.id, user.id)
    end
  end
end