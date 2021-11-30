# VerIDSampleApp
## 事前準備
### CocoaPodsのインストール
```
$ sudo gem install cocoapods
```
参考:https://qiita.com/ShinokiRyosei/items/3090290cb72434852460
## 構築手順
### podライブラリインストール
```
$ pod install
```
### Bundle Identifierを書き換える
```
TARGETS -> General からBundle Identifierを書き換える
```
### 証明書とパスワード取得
* 先程入力したBundle Identifierを下記のサイトに入力する
https://dev.ver-id.com/licensing/
* 証明書とパスワードを取得する
```
証明書 Ver-ID identity.p12
パスワード **********
```
### xcodeでVerIDSampleApp.xcworkspaceを開く
```
$ open VerIDSampleApp.xcworkspace
```
### 証明書をプロジェクトに追加する
* VerIDSampleAppフォルダを右クリックし、Add File to "VerIDSampleApp"を選択する
* Destinationの項目で、Copy items if needにチェエックをつける
* 先程ダウンロードした`Ver-Id identity.p12`を選択する 
### パスワードを設定する
* VerIDSampleAppフォルダの`Info`を選択する
* `com.appliedrec.verid.password`というKeyのValueを先程取得したパスワードに書き換える
```
key
com.appliedrec.verid.password 

value
**********
```
### Signingを行う
* 実機にアプリをビルドする必要がある
* TARGETS -> Signing & Capabilitiesを開く
* AppleIDでログインしてない場合はログインを行う Add an Account...から
* Teamのところで自分のアカウントを選択する
* Signing Certificateが発行されることを確認する
### 実機をMacに接続
* USBケーブルなどで実機をMacに接続する
* xcodeの上部のメニューからアプリのビルド対象を自身のiPhoneに変更する
### アプリをビルドする
* ビルドボタンからアプリのビルドを行う
* iPhoneのロックを解除しておく必要がある
* 注意：VerIDのライブラリはシミュレータに対応してないため、実機でないと本アプリはビルドができません
