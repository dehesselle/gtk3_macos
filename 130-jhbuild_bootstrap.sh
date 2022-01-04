#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# The first step to perform with JHBuild is to run its bootstrap command.
# After that it can be freely used to build whatever the moduleset provides.

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

# make necessary adjustments
patch -p1 < "$SELF_DIR"/modulesets-stable.patch

jhbuild bootstrap-gtk-osx

# Set PYTHON so libxml2 and pygments pick it up to build the bindings for the
# desired Python version.
PYTHON=$BIN_DIR/python3 jhbuild build \
  python3 \
  libxml2 \
  pygments

jhbuild build \
  meta-gtk-osx-bootstrap \
  meta-gtk3-dependencies