export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/qt512/lib/
ldd ./bin/chatterino
make INSTALL_ROOT=appdir -j$(nproc) install ; find appdir/
cp ./resources/icon.png ./appdir/chatterino.png

wget -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage
wget -nv "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod a+x appimagetool-x86_64.AppImage
./linuxdeployqt-continuous-x86_64.AppImage \
    appdir/usr/share/applications/*.desktop \
    -no-translations \
    -bundle-non-qt-libs \
    -unsupported-allow-new-glibc \
    -qmake=/opt/qt512/bin/qmake

rm -rf appdir/home
rm appdir/AppRun

# shellcheck disable=SC2016
echo '#!/bin/sh
here="$(dirname "$(readlink -f "${0}")")"
export QT_QPA_PLATFORM_PLUGIN_PATH="$here/usr/plugins"
cd "$here/usr"
exec "$here/usr/bin/chatterino" "$@"' > appdir/AppRun
chmod a+x appdir/AppRun

./appimagetool-x86_64.AppImage appdir
