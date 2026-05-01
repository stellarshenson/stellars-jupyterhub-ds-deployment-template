#!/bin/bash
# Operator-replacement branding test.
#
# Usage: tests/test_operator_branding.sh <template_src_dir> <render_dir>
#
# Validates the cleanup task in copier.yml that removes a template's
# default branding asset when the operator drops a non-prefix file of
# the same extension into branding/. After this rename:
#   *.png operator file  ->  removes <prefix>_jh_logo.png   (JupyterHub logo)
#   *.svg operator file  ->  removes <prefix>_jl_logo.svg   (JupyterLab logo)
#   *.ico operator file  ->  removes <prefix>_favicon.ico   (browser favicon)
# Operator files themselves are preserved across re-renders.

set -e

SRC="${1:?usage: $0 <template_src_dir> <render_dir>}"
RENDER="${2:?usage: $0 <template_src_dir> <render_dir>}"

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0m'

fail() { echo "${RED}FAIL${NC}: $*" >&2; exit 1; }
ok()   { echo "${GREEN}OK${NC}: $*"; }

# 1. Fresh render with defaults -> all three template assets present.
rm -rf "$RENDER"
copier copy --trust --defaults "$SRC" "$RENDER" >/dev/null

PREFIX=my_jupyterhub  # default branding_prefix when project_name="My JupyterHub"

test -f "$RENDER/branding/${PREFIX}_jh_logo.png"  || fail "fresh render missing default ${PREFIX}_jh_logo.png"
test -f "$RENDER/branding/${PREFIX}_jl_logo.svg"  || fail "fresh render missing default ${PREFIX}_jl_logo.svg"
test -f "$RENDER/branding/${PREFIX}_favicon.ico"  || fail "fresh render missing default ${PREFIX}_favicon.ico"
ok "fresh render has all three template defaults"

# 2. Drop non-prefix operator files of every type.
echo "operator-png" > "$RENDER/branding/operator_brand.png"
printf '<svg xmlns="http://www.w3.org/2000/svg"/>' > "$RENDER/branding/operator_brand.svg"
printf '\x00\x00\x01\x00' > "$RENDER/branding/operator_brand.ico"

# 3. Re-render with --overwrite so the cleanup task in _tasks runs again.
copier copy --trust --defaults --overwrite "$SRC" "$RENDER" >/dev/null

# 4. Defaults of the matching extension are gone.
test ! -f "$RENDER/branding/${PREFIX}_jh_logo.png" \
    || fail "default ${PREFIX}_jh_logo.png NOT removed despite operator PNG present"
test ! -f "$RENDER/branding/${PREFIX}_jl_logo.svg" \
    || fail "default ${PREFIX}_jl_logo.svg NOT removed despite operator SVG present"
test ! -f "$RENDER/branding/${PREFIX}_favicon.ico" \
    || fail "default ${PREFIX}_favicon.ico NOT removed despite operator ICO present"
ok "non-prefix operator files trigger removal of matching template defaults"

# 5. Operator files survive the re-render untouched.
test -f "$RENDER/branding/operator_brand.png" || fail "operator_brand.png was wrongly removed"
test -f "$RENDER/branding/operator_brand.svg" || fail "operator_brand.svg was wrongly removed"
test -f "$RENDER/branding/operator_brand.ico" || fail "operator_brand.ico was wrongly removed"
ok "operator-provided files preserved across re-render"

# 6. Single-extension scenario: only one operator file, only one default removed.
rm -rf "$RENDER"
copier copy --trust --defaults "$SRC" "$RENDER" >/dev/null
echo "operator-png-only" > "$RENDER/branding/single.png"
copier copy --trust --defaults --overwrite "$SRC" "$RENDER" >/dev/null

test ! -f "$RENDER/branding/${PREFIX}_jh_logo.png" \
    || fail "single-ext: default ${PREFIX}_jh_logo.png NOT removed"
test -f "$RENDER/branding/${PREFIX}_jl_logo.svg" \
    || fail "single-ext: default ${PREFIX}_jl_logo.svg was wrongly removed (no operator SVG)"
test -f "$RENDER/branding/${PREFIX}_favicon.ico" \
    || fail "single-ext: default ${PREFIX}_favicon.ico was wrongly removed (no operator ICO)"
ok "cleanup is per-extension, not blanket"
