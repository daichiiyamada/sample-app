class Micropost < ApplicationRecord
# attribute :in_reply_to, :integer, default: 0
belongs_to :user
has_many :mention, dependent: :destroy
default_scope -> { order(created_at: :desc) }
mount_uploader :picture, PictureUploader
validates :user_id, presence: true
validates :content, presence: true, length: { maximum: 140 }
validate  :picture_size

# 投稿内容から返信先ユーザー文字列を取得する
# def Micropost.get_user_name(content)
#   content.split("@")[1].split(" ")[0]
# end

private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
    
    # def reply_to_user
    #   if !content.index("@").nil?
    #     user_name = Micropost.get_user_name(content)
    #     reply_to_user = User.find_by(user_name: user_name)

    #     # 返信先ユーザーが存在していなかった場合
    #     if reply_to_user.nil?
    #       errors.add(:in_reply_to, "User ID doesn't match its name.")
    #     # 返信先ユーザーが自分だった場合
    #     elsif self.user_id == reply_to_user.id
    #       errors.add(:in_reply_to, "You can't reply to yourself.")
    #     # 返信先ユーザーが自分以外のユーザーだった場合
    #     else
    #       self.in_reply_to = reply_to_user.id
    #     end
    #   end
    # end
end