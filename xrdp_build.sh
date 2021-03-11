# v0.9.14 and v0.9.15 doesn't work (2021/02/19)
XRDP_VERSION=0.9.13.1
XORGXRDP_VERSION=0.2.13

sudo apt update -y
sudo apt upgrade -y

# start xrdp build
sudo apt-get -y install git autoconf libtool pkg-config gcc g++ make  libssl-dev libpam0g-dev libjpeg-dev libx11-dev libxfixes-dev libxrandr-dev  flex bison libxml2-dev intltool xsltproc xutils-dev python-libxml2 g++ xutils libfuse-dev libmp3lame-dev nasm libpixman-1-dev xserver-xorg-dev
mkdir tmp
cd tmp
wget https://github.com/neutrinolabs/xrdp/releases/download/v${XRDP_VERSION}/xrdp-${XRDP_VERSION}.tar.gz
wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v${XORGXRDP_VERSION}/xorgxrdp-${XORGXRDP_VERSION}.tar.gz
tar xvzf xrdp-${XRDP_VERSION}.tar.gz
tar xvzf xorgxrdp-${XORGXRDP_VERSION}.tar.gz
cd xrdp-${XRDP_VERSION}/
./bootstrap
./configure --enable-fuse --enable-mp3lame --enable-pixman
make
sudo make install
sudo ln -s /usr/local/sbin/xrdp{,-sesman} /usr/sbin
cd ../xorgxrdp-${XORGXRDP_VERSION}/
./bootstrap
./configure
make
sudo make install
sudo systemctl enable xrdp
sudo service xrdp start
# end xrdp build

# settings
sudo sed -e 's/^new_cursors=true/new_cursors=false/g'  -i /etc/xrdp/xrdp.ini
sudo systemctl restart xrdp
D=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
cat <<EOF > ~/.xsessionrc
 export GNOME_SHELL_SESSION_MODE=ubuntu
 export XDG_CURRENT_DESKTOP=ubuntu:GNOME
 export XDG_DATA_DIRS=${D}
 export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF
cat <<EOF | \
   sudo tee /etc/polkit-1/localauthority/50-local.d/xrdp-color-manager.pkla
 [Netowrkmanager]
 Identity=unix-user:*
 Action=org.freedesktop.color-manager.create-device
 ResultAny=no
 ResultInactive=no
 ResultActive=yes
EOF
sudo systemctl restart polkit
sudo sed -e 's/^max_bpp=32/max_bpp=24/g'  -i /etc/xrdp/xrdp.ini
sudo sed -e 's/^allowed_users=console/allowed_users=anybody/g'  -i /etc/X11/Xwrapper.config
cat <<EOF | \
   sudo tee /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
polkit.addRule(function(action, subject) {
 if (action.id == "org.freedesktop.color-manager.create-device" ||
      action.id == "org.freedesktop.color-manager.create-profile" ||
      action.id == "org.freedesktop.color-manager.delete-device" ||
      action.id == "org.freedesktop.color-manager.delete-profile" ||
      action.id == "org.freedesktop.color-manager.modify-device" ||
      action.id == "org.freedesktop.color-manager.modify-profile") {
    return polkit.Result.YES;
 }
});
EOF
cd ../../
#rm -rf tmp