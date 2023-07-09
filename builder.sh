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
cp -rf $src/* $out

ln -s $out/bin ./bin
