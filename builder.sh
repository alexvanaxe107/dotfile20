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

echo "Copying files."
cp -rf $src/bin $out
cp -rf $src/share $out

echo "Overriding the specific machine files"
cp -rf $src/machines/$machine_name/.* $out/share/configs
cp -rf $src/machines/$machine_name/* $out/share/configs

echo "Please run install_chm.sh to complete the installation. Enjoy."
