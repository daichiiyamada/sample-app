class Micropost < ApplicationRecord
attribute :replying, :boolean, default: false
belongs_to :user
has_many :mention, dependent: :destroy
has_many :likes, dependent: :destroy
has_many :like_users, through: :likes, source: :user
default_scope -> { order(created_at: :desc) }
mount_uploader :picture, PictureUploader
validates :user_id, presence: true
validates :content, presence: true, length: { maximum: 140 }
validate  :picture_size, :replying_validation

# 投稿内容からメンション先ユーザー文字列を取得する
def Micropost.get_user_name(content)
  content.split(" ").find_all{|name| name.delete!("@") if name[0] == "@"}
end

# マイクロポストをいいねする
def like(user)
  likes.create(user_id: user.id)
end

# マイクロポストのいいねを解除する
def delete_like(user)
  likes.find_by(user_id: user.id).destroy
end

# 現在のユーザーがいいねしてたらtrueを返す
def like?(user)
  like_users.include?(user)
end

private

  def replying_validation
    if !in_reply_to
      return
    end
    micropost = Micropost.find(in_reply_to)
    if micropost.replying
      errors.add(:replying, "You can't reply to a replying micropost")
    end
  end

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end