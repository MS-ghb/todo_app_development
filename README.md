#READ.ME  
##SinatraフレームワークとMySQLを使った、タスクの追加・編集・削除・完了管理ができるTodoアプリケーションです。　

##１．必要なGemのインストール方法　


1-1. todo_appファイル内に移動し、コマンドプロンプトを開きます。(右クリック→ターミナルで開く)

1-2. コマンド　bundle install　を実行します。　


##２．データベースの作成方法


2-1. MySQLにログインするため、コマンドプロンプトを開きます。

2-2. コマンドmysql -u root -pを実行します。　

2-3. MySQLのログインパスワードを入力します。

2-4. アプリケーション用のデータベースを作成します。　
コマンドプロンプトにmysql>が表示されたら、下記のクエリを入力して実行します。　

CREATE DATABASE todo_app_development;　

2-5. データベースが正常に作成されたかどうか、下記のクエリで確認します。　

SHOW DATABASES;　


##３．database.ymlの設定方法　


本アプリケーションのデータベース接続設定は `config/database.yml` に記述されています。　
アプリを起動する前に、お使いのローカル環境（MySQL）のユーザー名およびパスワードに合わせて、以下の項目を書き換えてください。　

default: &default　
  adapter: mysql2　
  encoding: utf8mb4　
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>　
  username: root　
  password: password　→お使いのローカル環境に合わせて書き換えてください。　
  host: localhost　→お使いのローカル環境に合わせて書き換えてください。　

development:　
  <<: *default　
  database: todo_app_development　

##４．マイグレーションの実行方法　


4-1. データベースのテーブルを作成します。(todosテーブル)　
   
CREATE TABLE todos (　
  id INT AUTO_INCREMENT,　
  title VARCHAR(255) NOT NULL,　
  description text NOT NULL,　
  completed TINYINT(1) NOT NULL DEFAULT 0,　
  completed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,　 
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,PRIMARY KEY (id)　
) DEFAULT CHARSET=utf8mb4;　

4-2.テーブルが正常に作成されたかどうか、下記のクエリで確認します。　
show tables;　


##５．アプリの起動方法とアクセスURL

   
5-1.todo_appファイル内に移動し、コマンドプロンプトを開きます。(右クリック→ターミナルで開く)

5-2.コマンドプロンプトにて、コマンドruby app.rbを実行します。

5-3.URL(http://localhost:4567/todos)  
にアクセスし、正常にtodoアプリが表示されているかを確認します。　


 
  
 

  
 
