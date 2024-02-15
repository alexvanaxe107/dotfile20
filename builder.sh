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

echo "Overriding the specific machine files"
mkdir -p $TMPDIR/share/configs/.config/hypr
mkdir -p $TMPDIR/share/configs/.config/wm

echo "Copying files."
cp -rf $src/bin $TMPDIR
cp -rf $src/share $TMPDIR

cp -rf $src/machines/$machine_name/* $TMPDIR/share/configs
cp -rf $src/machines/$machine_name/.* $TMPDIR/share/configs


cp -rf $TMPDIR/* $out




echo "Please run install_chm.sh to complete the installation. Enjoy."
