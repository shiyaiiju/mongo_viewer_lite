mongo_viewer_lite
=================
FluentdでMongoDBに各種ログを入れたものの、良いビューアが見つからなかったのでRubyの練習を兼ねて作成。あとgit/githubどちらも初挑戦。


## セットアップ

    bundle install --path vendor/bundler


## 起動

  	bundle exec shotgun

実際の環境ではApache+Passengerで動かしています。


## 課題
1. Rubyの勉強前に書いてしまったのでらしくないコードが幾つかあるのを修正したい
2. アプリの設定を登録出来るようにしたい
3. ページングをまともにしたい
4. MongoDBに接続出来ない時くらいエラーページ用意しよ


## 設定について
せっかくのMongoDBのアプリケーションなので、MongoDB内部に登録できるようにしたいかとも思ったけど、
DBへの接続情報を一緒に持たせるかを決めてないので保留。

1. 簡易の認証アカウント情報
2. 検索条件
