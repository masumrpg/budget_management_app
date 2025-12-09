#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter command not found. Please ensure Flutter is installed and in PATH." >&2
  exit 1
fi

# Ensure release build exists (CI handles this, but for local testing)
# flutter build linux --release

VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/+.*//')
PKG_NAME="budget-management-app"
APP_ID="com.masum.budget_management_app"
APP_DISPLAY_NAME="Budget Management App"
APP_SUPPORT_DIR="budget_management_app"
HIVE_SUBDIR="hive"
ARCH="amd64"
DIST_DIR="$ROOT_DIR/dist/linux"
PKG_DIR="$DIST_DIR/${PKG_NAME}_${VERSION}_${ARCH}"
BUNDLE_DIR="$ROOT_DIR/build/linux/x64/release/bundle"

rm -rf "$PKG_DIR" "$DIST_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb"

mkdir -p \
  "$PKG_DIR/DEBIAN" \
  "$PKG_DIR/usr/bin" \
  "$PKG_DIR/usr/lib/$PKG_NAME" \
  "$PKG_DIR/usr/share/applications" \
  "$PKG_DIR/usr/share/icons/hicolor"

cp -r "$BUNDLE_DIR"/. "$PKG_DIR/usr/lib/$PKG_NAME/"

cat <<DESKTOP > "$PKG_DIR/usr/share/applications/${APP_ID}.desktop"
[Desktop Entry]
Name=$APP_DISPLAY_NAME
Comment=Manage your budget effectively
Exec=$PKG_NAME
Icon=budget_management_app
Terminal=false
Type=Application
Categories=Utility;Finance;
StartupWMClass=$APP_ID
DESKTOP

cat <<'LAUNCHER' > "$PKG_DIR/usr/bin/$PKG_NAME"
#!/bin/sh
exec /usr/lib/budget-management-app/budget_management_app "$@"
LAUNCHER
chmod 755 "$PKG_DIR/usr/bin/$PKG_NAME"

# Copy logo from assets/image/logo.png
ICON_DEST_DIR="$PKG_DIR/usr/share/icons/hicolor/512x512/apps"
mkdir -p "$ICON_DEST_DIR"
if [ -f "$ROOT_DIR/assets/image/logo.png" ]; then
  cp "$ROOT_DIR/assets/image/logo.png" "$ICON_DEST_DIR/budget_management_app.png"
else
    echo "Warning: Custom logo not found at assets/image/logo.png"
fi

cat <<CONTROL > "$PKG_DIR/DEBIAN/control"
Package: $PKG_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: Masum <masum@example.com>
Depends: libgtk-3-0 (>= 3.22), libstdc++6 (>= 9)
Description: $APP_DISPLAY_NAME
 A comprehensive budget management application built with Flutter.
CONTROL

cat <<POSTINST > "$PKG_DIR/DEBIAN/postinst"
#!/bin/sh
set -e
# Update icon and desktop database caches
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t /usr/share/icons/hicolor || true
fi
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
exit 0
POSTINST
chmod 755 "$PKG_DIR/DEBIAN/postinst"

cat <<POSTRM > "$PKG_DIR/DEBIAN/postrm"
#!/bin/sh
set -e

cleanup_user_state() {
  USER_TO_CLEAN="\$1"
  if [ -z "\$USER_TO_CLEAN" ] || [ "\$USER_TO_CLEAN" = "root" ]; then
    return
  fi
  HOME_DIR=\$(getent passwd "\$USER_TO_CLEAN" | cut -d: -f6)
  if [ -z "\$HOME_DIR" ] || [ ! -d "\$HOME_DIR" ]; then
    return
  fi

  # Clean up application data
  rm -rf "\$HOME_DIR/.local/share/$APP_SUPPORT_DIR"
  rm -rf "\$HOME_DIR/Documents/$APP_SUPPORT_DIR"
}

if [ "\$1" = "purge" ]; then
  # Attempt to clean up for the user who is running sudo
  if [ -n "\$SUDO_USER" ]; then
    cleanup_user_state "\$SUDO_USER"
  fi
  # Attempt to clean up for the logged-in user
  INSTALLER_USER=\$(logname 2>/dev/null || true)
  if [ -n "\$INSTALLER_USER" ]; then
    cleanup_user_state "\$INSTALLER_USER"
  fi
fi

# Update icon and desktop database caches
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t /usr/share/icons/hicolor || true
fi
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
exit 0
POSTRM
chmod 755 "$PKG_DIR/DEBIAN/postrm"

dpkg-deb --build "$PKG_DIR"
mv "$DIST_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb" "$DIST_DIR/${PKG_NAME}.deb" # Simple name for easier zipping? workflow expects *.deb
echo "Created Debian package at $DIST_DIR/${PKG_NAME}.deb"
