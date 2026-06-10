require 'sinatra'
require 'active_record'

use Rack::MethodOverride

ActiveRecord::Base.establish_connection(
    adapter:  "mysql2",
    host:     "localhost",
    username: "root",          # Windowsの標準ユーザー名
    password: "mysql2023", # 【重要】MySQLインストール時に決めたパスワードを入力
    database: "todo_app_development"
)
#AcriveRecord タイムゾーン指定
ActiveRecord.default_timezone = :local  

class Todo < ActiveRecord::Base; end

#テーブル全体を表示（フィルタ設定をしたため、現在コメントアウト）
# get '/' do
#   @todos = Todo.all
#   erb :index
# end

# フィルター　?filter=all/ ?filter=active/ ?filter=completed
# ==は等しい、=はこの値にする
get '/' do
  @filter = params[:filter]
  if @filter == 'active'
    @todos = Todo.where(completed: 0)
  elsif @filter == 'completed'
    @todos = Todo.where(completed: 1)
  else 
    @todos = Todo.all
  end
  erb :index
end

post '/' do
  @newrecord = Todo.new
  @newrecord.title = params[:title]
  @newrecord.description = params[:description]
  # completedの初期値は0(未完了)
  @newrecord.completed = 0
  # saveでtodosテーブルに保存
  @newrecord.save   
  # index画面（トップページ）へURLごと移動
  redirect '/' 
end

get '/:id/edit' do
  @record = Todo.find_by_id(params[:id]) #該当IDのデータ取得
  erb :edit # views/edit.erb を表示
end

# 編集画面での更新処理を反映
patch '/:id' do
	@record = Todo.find_by_id(params[:id]) #該当IDのデータ情報取得
  #更新データの代入
	@record.title = params[:title] 
  @record.description = params[:description]
	@record.save #データ更新の反映
	redirect to "/" #一覧画面へ
end
# 完了・未完了切り替え（トグルボタン）
patch '/:id/toggle' do
	@record = Todo.find_by_id(params[:id]) #該当IDのデータ情報取得
  # 現在の値が 1 または true なら 0 に更新、それ以外は 1 に更新
  if @record.completed == 1 || @record.completed == true
    @record.completed = 0
  else
    @record.completed = 1
  end
	@record.save #データ更新の反映
	redirect to "/" #一覧画面へ
end

delete '/:id' do
  id = params[:id]
    Todo.destroy(id)
    redirect '/'
end





