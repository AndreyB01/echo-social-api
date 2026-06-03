class AddCheckConstraintsToRelationships < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :follows,
                         "follower_id <> followed_id",
                         name: "follows_cannot_follow_self"

    add_check_constraint :blocks,
                         "blocker_id <> blocked_id",
                         name: "blocks_cannot_block_self"

    add_check_constraint :mutes,
                         "muter_id <> muted_id",
                         name: "mutes_cannot_mute_self"
  end
end