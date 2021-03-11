# checkinstallによるdebパッケージ生成のメモ
* debから`sudo apt install`する際には，ファイル名だけではダメで，`./...`と指定しないといけない
* `xrdp_build.sh`の`make install`を，それぞれ`sudo checkinstall --pkgname=xrdp --pkgversion=${XRDP_VERSION} --pkgrelease=1 --default`，`sudo checkinstall --pkgname=xorgxrdp --pkgversion=${XORGXRDP_VERSION} --pkgrelease=1 --default`に変更することで作成した．なお，`--install=no`をつけないと`make install`と同様にインストールされるため，`apt`での管理はできない
* そのままのdebでは`/etc/xrdp/rsakeys.ini`が存在しないためエラーとなった．直接ファイルを作成，コピーすることで動作することを確認したため，debパッケージに直接追加することとした．このコマンドは，既にxrdpがインストールされた環境で行ったものである．
  ```
  mkdir extracted
  dpkg-deb -R xrdp_0.9.13.1-1_amd64.deb extracted/
  sudo cp /etc/xrdp/rsakeys.ini ./extracted/etc/xrdp/
  sudo dpkg-deb -b extracted
  ```
## 参考
こちらのサイトで紹介されているコマンドを用いた．
https://askubuntu.com/questions/825321/adding-a-library-file-to-an-already-existing-debian-package-file-deb