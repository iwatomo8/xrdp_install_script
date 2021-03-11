# Ubuntu 18.04からUbuntu 20.04へのアップグレード
1. `sudo apt update`，`sudo apt upgrade`
2. 保留のパッケージがあれば，`sudo apt dist-update`
3. `autoremove`対象のパッケージがあれば`sudo apt autoremove`
4. まだ保留のパッケージがあれば，パッケージ名を指定してインストール  
   `sudo apt install [パッケージ名]`
5. エラーが出て`sudo dpkg --configure -a`や`sudo apt --fix-broken install`を実行するように表示された場合はその通り実行し，最新になるまで`update, upgrade`などを繰り返す
5. `sudo apt update`で最新であることを確認
6. sudo reboot
7. sudo do-release-upgrade
8. 適宜Enterで進める
   * `openssh-server`については`パッケージメンテナのバージョンをインストール`とした
   * `xrdp.ini`については`n`とした
9. アップグレード完了後には，`apt`のサードパーティ製リポジトリが無効化されているので，有効化する必要がある
   * 通常，ソフトウェアとアップデートというGUIアプリケーションの，他のソフトウェアという所からチェックボックスで選択できる
   * ただ，チェックボックスを押しても反応しない問題があった
     * Ubuntu 18.04では，チェックボックスを選択した際にパスワード入力画面が表示されるため，権限の問題と思われる
   * `xrdp`を使わず，直接ディスプレイにつないでいる場合は，`sudo software-properties-gtk`で実行可能だが，リモートではエラーとなるため，直接ファイルを編集する必要がある
10. `/etc/apt/sources.list`および`/etc/apt/sources.list.d`ディレクトリ内のファイルを直接編集する必要がある(root権限が必要)
   * 無効化されたものは`# focalへのアップグレード時に無効化されました`と書いてあるため，問題なければコメントアウトを解除する
     * nvidia-dockerに関しては，インストール時に実行する`curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list |  sudo tee /etc/apt/sources.list.d/nvidia-docker.list`でも良い
   * ex. `sudo nano sources.list`，無効化されたリポジトリの`#`を消してコメントアウトを解除
   * ソフトウェアとアップデートから，チェックが入ったことを確認できる

# 備考
* `sudo apt update`時に，nvidia-dockerの公開鍵のエラーが出た場合は`curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -`
* nvidia-dockerのリポジトリとして`18.04`と入っているリンクが設定されているが，`20.04`でも`18.04`が設定されるようなので問題ないと思われる