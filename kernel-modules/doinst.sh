config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
config etc/rc.d/rc.modules-3.10.14.new

# If rc.modules is a real file, back it up:
if [ -r etc/rc.d/rc.modules -a ! -L etc/rc.d/rc.modules ]; then
  cp -a etc/rc.d/rc.modules etc/rc.d/rc.modules.bak 
fi
# Make rc.modules a symlink if it's not already, but do not replace
# an existing symlink.  You'll have to decide to point at a new version
# of this script on your own...
if [ ! -L etc/rc.d/rc.modules ]; then
  ( cd etc/rc.d ; rm -rf rc.modules )
  ( cd etc/rc.d ; ln -sf rc.modules-3.10.14 rc.modules )
fi

# A good idea whenever kernel modules are added or changed:
if [ -x sbin/depmod ]; then
  chroot . /sbin/depmod -a 3.10.14 1> /dev/null 2> /dev/null
fi

( cd lib/modules/3.10.14 ; rm -rf source )
( cd lib/modules/3.10.14 ; ln -sf /usr/src/linux-3.10.14 source )
( cd lib/modules/3.10.14 ; rm -rf build )
( cd lib/modules/3.10.14 ; ln -sf /usr/src/linux-3.10.14 build )
