# xrdp_install_script
* xrdpをUbuntu 20.04にインストールするシェルスクリプト
  * [公式手順](https://github.com/neutrinolabs/xrdp/wiki/Building-on-Debian-8)に基づいて作成  
* AWS EC2のUbuntu Server 20.04および実機で動作確認済み  
* Ubuntu 18.04から20.04へのアップグレードについては[こちら](Ubuntu_UPGRADE.md)
* リモートデスクトップがただ使えれば良い場合は[`apt`を使ったインストール](#aptを使ったインストール)，マウスの戻る・進むボタンを使えるバージョンを使いたい場合は[GitHubのReleasesで公開されているtarファイルからのビルド＆インストール](#GitHubのReleasesで公開されているtarファイルからのビルド＆インストール)  
  * 野良debパッケージからのインストールに抵抗がなければ，[debパッケージからのインストール](#debパッケージからのインストール)がおすすめ
  * 正攻法でインストールしたい場合は，[クリーンインストールした環境へのインストール](#クリーンインストールした環境へのインストール)もしくは[既にaptでxrdpがインストールされている場合](#既にaptでxrdpがインストールされている場合)

## `apt`を使ったインストール
```
sudo bash xrdp_apt.sh
```
## GitHubのReleasesで公開されているtarファイルからのビルド＆インストール
 * xrdp: https://github.com/neutrinolabs/xrdp/releases
 * xorgxrdp: https://github.com/neutrinolabs/xorgxrdp/releases
### クリーンインストールした環境へのインストール
```
sudo bash xrdp_build.sh
```

### 既に`apt`で`xrdp`がインストールされている場合
```
sudo bash uninstall_xrdp.sh
sudo bash xrdp_build.sh
```

### AWS EC2のUbuntu Server 20.04へのインストール
```
sudo bash ubuntu_desktop.sh # デスクトップ環境のインストール
sudo bash xrdp_build.sh
```
`ubuntu_desktop.sh`では一般ユーザを`user`として追加しているため，適宜変更が必要．また，設定するパスワードを聞かれるため入力すること．

### debパッケージからのインストール
`checkinstall`を使って，debパッケージを作成した．  
作成にあたって一部荒業を行っており，詳細は[こちら](create_deb_package.md)．  
このdebパッケージからインストールすることで，`apt`や`dpkg`での管理が可能になる．  
既に`apt`でxrdpがインストールされている場合は`sudo bash uninstall_xrdp.sh`を実行しておくこと．
```
sudo bash xrdp_deb.sh
```

## 注意事項
* **使用は自己責任で**
* Ubuntu 20.04において，`xrdp v0.9.15`および`xrdp v0.9.14`がうまく動作しなかったため，スクリプトでインストールするバージョンは`xrdp v0.9.13.1`としている
* Ubuntu 18.04では`xrdp v0.9.13.1`をビルド＆インストールしても，ログイン後アプリケーションが落ちるため使えない
* アンインストールする際には`xrdp-0.9.13.1`, `xorgxrdp-0.2.13`各ディレクトリで`sudo make uninstall`を実行すればよい

## 備考
* 2021/02/23時点，`apt`からインストール可能なバージョンはUbuntu 18.04では`0.9.5-2`，Ubuntu 20.04では`0.9.12-1`
* `xrdp v0.9.13`でマウスの戻る・進むボタンがサポートされた([support mousex button 8/9 #1478](https://github.com/neutrinolabs/xrdp/pull/1478))ため，それ以降のバージョンを使用したい場合にはビルドからのインストールがおすすめ
* スクリプト内でのsettingsは古い設定が含まれている可能性があり，全て必要であるかは未確認