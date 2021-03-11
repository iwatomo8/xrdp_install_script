sudo apt update -y
sudo apt upgrade -y
sudo apt install xrdp -y

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