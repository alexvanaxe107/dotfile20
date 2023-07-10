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
mkdir $out/home-manager/
mkdir $out/bin
cp -rf $src/share/avatemplates/home-manager/fun.nix $out/home-manager/ava.nix
cp -rf $src/share/configs/.config/home-manager/* $out/home-manager
cp -rf $src/bin/install_fun.sh $out/bin
cp -rf $src/bin/start.sh $out/bin/start_fun.sh

echo "Please run install_fun.sh to complete the installation. Enjoy."
