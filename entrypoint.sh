#!/bin/bash
set -euo pipefail

FILE="$(basename "$0")"

pacman -Syu --noconfirm base-devel
echo
echo "*** INITIAL INSTALLED PACKAGES ***"
pacman -Q

# Makepkg does not allow running as root
# Run as `nobody` and give full access to these files
chmod -R a+rw .

# When installing dependencies, makepkg will use sudo
# Give user `nobody` passwordless sudo access
echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Get array of packages to be built
mapfile -t PKGFILES < <( sudo -u nobody makepkg --packagelist )
echo "Package(s): ${PKGFILES[*]}"

# Build packages
sudo -u nobody makepkg --syncdeps --noconfirm "$@"

echo
echo "*** POST-MAKEPKG INSTALLED PACKAGES ***"
pacman -Q

# Report built package archives
i=0
for PKGFILE in "${PKGFILES[@]}"; do
	# makepkg reports absolute paths, must be relative for use by other actions
	RELPKGFILE="$(realpath --relative-base="$PWD" "$PKGFILE")"
	# Caller arguments to makepkg may mean the pacakge is not built
	if [ -f "$PKGFILE" ]; then
		echo "::set-output name=pkgfile$i::$RELPKGFILE"
	else
		echo "Archive $RELPKGFILE not built"
	fi
	(( ++i ))
done

function prepend () {
	# Prepend the argument to each input line
	while read -r line; do
		echo "$1$line"
	done
}

# Run namcap checks
# Installing namcap after building so that makepkg happens on a minimal
# install where any missing dependencies can be caught.
pacman -S --noconfirm namcap

echo
echo "*** FINAL INSTALLED PACKAGES ***"
pacman -Q

echo
echo "*** PYTHON LIBRARIES ***"
find /usr/lib -name '*python.so*'

echo
echo "*** NAMCAP ON PKGBUILD ***"
namcap -i PKGBUILD \
	| prepend "::warning file=$FILE,line=$LINENO::"

for PKGFILE in "${PKGFILES[@]}"; do
	echo
	echo "*** NAMCAP ON $PKGFILE ***"
	namcap -i "$PKGFILE" \
		| prepend "::warning file=$FILE,line=$LINENO::$PKGFILE:"
done
