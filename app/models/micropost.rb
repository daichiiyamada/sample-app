class Micropost < ApplicationRecord
# attribute :in_reply_to, :integer, default: 0
belongs_to :user
has_many :mention, dependent: :destroy
default_scope -> { order(created_at: :desc) }
mount_uploader :picture, PictureUploader
validates :user_id, presence: true
validates :content, presence: true, length: { maximum: 140 }
validate  :picture_size

# 投稿内容からメンション先ユーザー文字列を取得する
def Micropost.get_user_name(content)
  content.split(" ").find_all{|name| name.delete!("@") if name[0] == "@"}
end

private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end