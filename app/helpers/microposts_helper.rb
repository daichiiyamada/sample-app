module MicropostsHelper
    # 投稿内容のuser_nameにリンクを追加する
    def add_link_reply_user_name(micropost)
        content = Rinku.auto_link(h(micropost.content))
        if !content.index("@").nil?
            user_names = Micropost.get_user_name(content)
            user_array = User.where(user_name: user_names)
            user_array.each do |user|
                # link_html = link_to "@#{w}", user_path(user.id) unless user.nil?
                content.sub!(/@#{user.user_name}/, (link_to "@#{user.user_name}", user_path(user.id)))
            end
        end
        content.gsub!(/\r\n/, "<br>")
        content
    end

    def format_comment(content)
        # 返信用の文字列を定義
        reply = { char: '@', escaped: '@' }
        # コメント本文のHTMLをエスケープ後、返信用の文字列のみをHTMLとして再定義
        content = content.gsub(reply[:escaped], reply[:char])
        # 返信先リンク部の取得
        content_arry = content.split(" ")
        target = content_arry.select{ |c| c.include?(reply[:char]) }
        target.each do |t|
          # 返信先リンクHTMLの生成
          to = t.match(/#{reply[:char]}\d+/).to_s
          link_html = link_to to, "#comment_#{to.gsub(reply[:char], '')}"
          # 本文の返信部を返信先リンクHTMLで置換
          content = content.gsub(to, link_html)
        end
        content
        debugger
      end
end
