echo "Making desktop"

unset PATH

for p in $baseInputs $buildInputs; do
  if [ -d $p/bin ]; then
    export PATH="$p/bin${PATH:+:}$PATH"
  fi
  if [ -d $p/lib/pkgconfig ]; then
    export PKG_CONFIG_PATH="$p/lib/pkgconfig${PKG_CONFIG_PATH:+:}$PKG_CONFIG_PATH"
  fi
done

echo "Creating output"
mkdir $out
mkdir -p $TMPDIR/share/configs/.config/wm
mkdir -p $TMPDIR/share/configs/.config/home-manager
mkdir -p $TMPDIR/bin

echo "Copying files."
cp -rf $src/machines/$machine_name/.config $TMPDIR/share/configs/
cp -rf $src/machines/$machine_name/bin $TMPDIR
cp -rf $src/bin/manage_configs.sh $TMPDIR/bin
cp -rf $src/bin/gen_monitor_options.sh $TMPDIR/bin

cp -rf $TMPDIR/* $out



#mkdir $out/home-manager/
#mkdir $out/temp/
#mkdir $out/bin
#cp -rf $src/share/avatemplates/home-manager/fun.nix $out/home-manager/ava.nix
#cp -rf $src/share/configs/.config/home-manager/* $out/home-manager
#cp -rf $src/bin/install_fun.sh $out/bin
#cp -rf $src/bin/start.sh $out/bin/start_fun.sh
#cp -rf $src/bin/start_tmp.sh $out/temp/start_tmp.sh

echo "Please run install_fun.sh to complete the installation. Enjoy."
