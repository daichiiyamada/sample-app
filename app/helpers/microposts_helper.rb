module MicropostsHelper
    # 投稿内容のuser_nameにリンクを追加する
    # def add_link_reply_user_name(micropost)
    #     content = Rinku.auto_link(h(micropost.content))
    #     if !content.index("@").nil?
    #         user_name = Micropost.get_user_name(content)
    #         micropost.content.split("@").join.to_s.split(" ").each do |w|
    #             user = User.find_by(user_name: w)
    #             # link_html = link_to "@#{w}", user_path(user.id) unless user.nil?
    #             content.sub!(/@#{w}/, (link_to "@#{w}", user_path(user.id))) unless user.nil?
    #         end
    #     end
    #     content.gsub!(/\r\n/, "<br>")
    #     content
    # end

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
