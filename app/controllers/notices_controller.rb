class NoticesController < ApplicationController
  # お知らせ一覧（検索・フィルター機能付き）
  def index
    @notices = Notice.published.order(published_at: :desc)

    # キーワード検索
    if params[:keyword].present?
      keyword = "%#{params[:keyword]}%"
      @notices = @notices.where(
        "title LIKE ? OR content LIKE ?",
        keyword,
        keyword
      )
    end

    # データベースの種類に応じてクエリを変更
    # PostgreSQLの場合はEXTRACT、SQLiteの場合はstrftimeを使用
    use_postgres = ActiveRecord::Base.connection.adapter_name.downcase.include?("postgres")

    # 年フィルター
    if params[:year].present?
      year = params[:year].to_i
      if use_postgres
        @notices = @notices.where(
          "EXTRACT(YEAR FROM published_at) = ?",
          year
        )
      else
        @notices = @notices.where(
          "strftime('%Y', published_at) = ?",
          year.to_s
        )
      end
    end

    # 月フィルター
    if params[:month].present?
      month = params[:month].to_i
      if use_postgres
        @notices = @notices.where(
          "EXTRACT(MONTH FROM published_at) = ?",
          month
        )
      else
        @notices = @notices.where(
          "strftime('%m', published_at) = ?",
          sprintf("%02d", month)
        )
      end
    end
  end

  # お知らせ詳細（使用しない）
  def show
    redirect_to notices_path
  end
end
