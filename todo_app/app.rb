require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  "mysql2",
  host:     "localhost",
  username: "root",          # Windowsの標準ユーザー名
  password: "mysql2023", # 【重要】MySQLインストール時に決めたパスワードを入力
  database: "todo_app_development"
)
#AcriveRecord タイムゾーン指定
ActiveRecord.default_timezone = :local  

class Todo < ActiveRecord::Base; 
  # タイトルが空の場合にDB保存しないバリデーション  
  validates :title, presence: true
end

# URLに「/todos/:id」が含まれるすべてのアクセスに対して、事前に実行
# ?をつけるとメソッドがtrueかfalseで返るようになる
before '/todos/:id/?*' do
  @record = Todo.find_by(id: params[:id]) 
  if @record.nil?
    halt 404, "TODOリストにレコードがありません。"
  end
end

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

# レコードの新規追加
get '/todos' do
  @todos = Todo.all
  erb :index
end

post '/todos' do
  @newrecord = Todo.new
  @newrecord.title = params[:title]
  @newrecord.description = params[:description]
  # completedの初期値は0(未完了)
  @newrecord.completed = 0

  # saveでtodosテーブルに保存
  if @newrecord.save   
    # index画面（トップページ）へURLごと移動(最初のリクエストがPOSTであっても、リダイレクト先にはGETでリクエスト)
    redirect '/todos'
  else 
    @error = "タイトルを入力してください。"
    @todos = Todo.all
    erb :index
  end
end

get '/todos/:id/edit' do
  @record = Todo.find_by(id: params[:id]) #該当IDのデータ取得
  erb :edit # views/edit.erb を表示
end

get '/todos/:id/update' do
  @record = Todo.find_by(id: params[:id]) #該当IDのデータ取得
  erb :edit # views/edit.erb を表示(リダイレクトせず、そのままの画面を表示)
end

# 編集画面での更新処理を反映
post '/todos/:id/update' do
  @record = Todo.find_by(id: params[:id]) #該当IDのデータ情報取得
  #更新データの代入
  @record.title = params[:title] 
  @record.description = params[:description]
  @record.save #データ更新の反映
  redirect '/' #リダイレクトでトップ画面に戻る
end

# 完了・未完了切り替え（トグルボタン）
post '/todos/:id/toggle' do
  @record = Todo.find_by(id: params[:id]) #該当IDのデータ情報取得
  # 現在の値が 1 または true なら 0 に更新、それ以外は 1 に更新
  if @record.completed
    @record.completed = 0
  else
    @record.completed = 1
  end
  @record.save #データ更新の反映
  @todos = Todo.all #テーブル全体を表示
  redirect '/'#一覧画面へ（リダイレクト）
end

# レコード削除
get '/todos/:id/delete' do
  @todos = Todo.all
  erb :index # views/edit.erb を表示
end

post '/todos/:id/delete' do
  id = params[:id]
  Todo.destroy(id)
  # URLを/:id/deleteのまま、テーブルを全体表示(リダイレクトせず、index画面を表示)
  @todos = Todo.all
  redirect '/'#一覧画面へ（リダイレクト）
end
