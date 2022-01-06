#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# TODO: TBD

### shellcheck #################################################################

# Nothing here.

### dependencies ###############################################################

# shellcheck disable=SC1090 # can't point to a single source here
for script in "$(dirname "${BASH_SOURCE[0]}")"/0??-*.sh; do
  source "$script";
done

### variables ##################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### main #######################################################################

if $CI; then   # break in CI, otherwise we get interactive prompt by JHBuild
  error_trace_enable
fi

git clone \
  --branch "gtk-3-24" \
  --depth 1 \
  --recurse-submodules \
  --single-branch \
  "https://gitlab.gnome.org/GNOME/gtk" "$VER_DIR"/gtk

cd "$VER_DIR"/gtk || exit 1
meson \
  --prefix="$VER_DIR" \
  "$(xmllint --xpath "string(//moduleset/meson[@id='gtk+-3.0']/@mesonargs)" "$SELF_DIR"/gtk-osx/modulesets-stable/gtk-osx.modules)" \
  "$VER_DIR"/gtk_build

cd "$VER_DIR"/gtk_build || exit 1
meson compile
meson test || true

mv "$VER_DIR"/gtk_build/meson-logs/testlog.txt "$GITHUB_WORKSPACE"
