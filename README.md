# メモアプリ

「Sinatra を使ってWebアプリケーションの基本を理解する」「WebアプリからのDB利用」の課題提出用のリポジトリです。

# 使い方

1. プロジェクト取得

```
git clone https://github.com/shin-fkmt/sinatra-practices.git
```

2. プロジェクトへ移動

```
cd sinatra-practices
```

3. 必要なライブラリの取得

```
bundle install
```

4. データベースの準備

本アプリではPostgreSQLを利用しています。  
PostgreSQLがインストールされていない場合、動作環境にPostgreSQLをインストールしてください。  
https://www.postgresql.org/

5. 接続情報の準備

`.env.example`に接続情報の雛型を準備しています。  
雛型から`.env`ファイルを作成します。
```
cp .env.example .env
```
`.env`を動作環境に合わせて修正してください。
``` .env
DB_HOST=your_db_host
DB_PORT=your_db_port
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_NAME=memo # データベースの初期化処理で指定しているデータベース名になります。特に理由が無い場合そのままご利用ください。[db/ddl/create_database_memo.sql]
```
**DB_USERにはデータベース作成権限のあるユーザーを指定してください。**  

DB_USERがデータベースの作成権限を保持していない場合、適宜権限を設定してください。
```
ALTER USER {your_db_user} CREATEDB;
```

6. データベースの初期処理

```
bundle exec ruby db/init_db.rb
```

7. メモアプリの起動

```
bundle exec ruby app.rb
```

8. メモアプリの利用

```
http://localhost:4567/memos
```

---

以上です。
