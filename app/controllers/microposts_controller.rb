class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            add_mentions
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'static_pages/home'
        end
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
    end

    private

    def micropost_params
        params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end

    def add_mentions
        puts "来たよ"
        if !@micropost.content.index("@").nil?
          # 投稿内容からuser_nameを取得
          user_names = @micropost.content.split(" ").find_all{|name| name.delete!("@") if name[0] == "@"}
          # ユーザーを検索
          users = User.where(user_name: user_names)
          users.each do |user|
            Mention.create(user_id: user.id, micropost_id: @micropost.id)
          end
          # link_html = link_to "@#{w}", user_path(user.id) unless user.nil?
          # content.sub!(/@#{w}/, (link_to "@#{w}", user_path(user.id))) unless user.nil?
  
          # # 返信先ユーザーが存在していなかった場合
          # if reply_to_user.nil?
          #   errors.add(:in_reply_to, "User ID doesn't match its name.")
          # # 返信先ユーザーが自分だった場合
          # elsif self.user_id == reply_to_user.id
          #   errors.add(:in_reply_to, "You can't reply to yourself.")
          # # 返信先ユーザーが自分以外のユーザーだった場合
          # else
          #   self.in_reply_to = reply_to_user.id
          # end
        end
    end
end
