class Micropost < ApplicationRecord
attribute :replying, :boolean, default: false
belongs_to :user
has_many :mention, dependent: :destroy
default_scope -> { order(created_at: :desc) }
mount_uploader :picture, PictureUploader
validates :user_id, presence: true
validates :content, presence: true, length: { maximum: 140 }
validate  :picture_size, :replying_validation

# 投稿内容からメンション先ユーザー文字列を取得する
def Micropost.get_user_name(content)
  content.split(" ").find_all{|name| name.delete!("@") if name[0] == "@"}
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