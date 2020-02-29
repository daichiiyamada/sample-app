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
        if !@micropost.content.index("@").nil?
          # 投稿内容からuser_nameを取得
          user_names = Micropost.get_user_name(@micropost.content)
          # ユーザーを検索
          users = User.where(user_name: user_names)
          users.each do |user|
            Mention.create(user_id: user.id, micropost_id: @micropost.id)
          end
        end
    end
end
