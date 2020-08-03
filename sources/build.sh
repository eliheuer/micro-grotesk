#!/bin/bash
set -e
# Builds variable and static fonts.
#
# All steps needed to build new fonts are contained within
# this script, so font builds are repeatable and documented.
#
# Requirements: Python3[3] and a Unix-like environment
# (Linux, MacOS, Windows Subsystem for Linux, etc),
# with a Bash-like shell(most Unix terminal applications).
#
# All Python dependencies will be installed in a temporary
# virtual environment by the script. If you want to set up your own
# virtual environment, disable the setting in the Build Settings section
# of this scrpt's header.
#
# To build new fonts, open a terminal in the root directory
# of this project(Git repository) and run the script:
#
# $ sh build.sh
#
# If you are updating the font for Google Fonts, you can
# use the "-gf" flag to run additional pull-request-helper
# commands as well. Just remember to change the "GOOGLE_FONTS_DIR"
# file path constant if you aren't building to ~/Google/fonts/ofl/.../:
#
# $ sh build.sh -gf
#
# The default settings should produce output that will conform
# to the Google Fonts Spec [1] and pass all FontBakery QA Tests [2].
# However, the Build Script Settings below are designed to be easily
# modified for other platforms and use cases.
#
# See the GF Spec [1] and the FontBakery QA Tool [2] for more info.
#
# Script by Eli H. If you have questions, please send an email [4].
#
# [1] https://github.com/googlefonts/gf-docs/tree/master/Spec
# [2] https://pypi.org/project/fontbakery/
# [3] https://www.python.org/
# [4] elih@protonmail.com

##################
# BUILD SETTINGS #
##################
alias ACTIVATE_PY_VENV=". BUILD_VENV/bin/activate"  # Starts a Python 3 virtual environment when invoked
GOOGLE_FONTS_DIR="~/Google/fonts"                   # Where the Google Fonts repo is cloned: https://github.com/google/fonts
MAKE_NEW_VENV=true                                  # Set to `true` if you want to build and activate a python3 virtual environment
BUILD_STATIC_FONTS=true                             # Set to `true` if you want to build static fonts
AUTOHINT=false                                      # Set to `true` if you want to use auto-hinting (ttfautohint)
NOHINTING=true                                      # Set to `true` if you want the fonts unhinted

#################
# BUILD PROCESS #
#################
echo "\n****** ** * STARTING THE GTF MICRO GROTESK BUILD SCRIPT * ** ******"
echo "[INFO] Build start time: \c"
date

if [ "$1" = "-gf" ]; then
    echo "\n[INFO] gf-flag(-gf): Preparing a pull request to Google Fonts at: $GOOGLE_FONTS_DIR";
fi

if [ "$MAKE_NEW_VENV" = true ]; then
  echo "\n[INFO] Building a new Python3 virtual environment"
  python3 -m venv BUILD_VENV > /dev/null
  ACTIVATE_PY_VENV > /dev/null
  echo "[INFO] Python3 setup..."
  pip install --upgrade pip > /dev/null
  pip install --upgrade fontmake > /dev/null
  pip install --upgrade fonttools > /dev/null
  pip install --upgrade git+https://github.com/googlefonts/gftools > /dev/null
  which python  # Test to see if the VENV setup worked
  echo "[INFO] Done with Python3 virtual environment setup"
fi

# BUILD SETUP
echo "\n[INFO] Setting up build output directories: fonts"
mkdir -p fonts

# FONTMAKE (building the variable font)
echo "\n[INFO] Building variable fonts with Fontmake..."
fontmake -m sources/MicroGrotesk.designspace -o variable \
  --output-path fonts/MicroGrotesk[wght].ttf
#  --verbose ERROR

#echo "\n[INFO] Making fixes to the fontmake output"
# FONTTOOLS HOTFIXES
#ttx fonts/CascadiaCode\[wght\].ttf
# CHANGES NAME FROM CASCADIA CODE TO CASKAYDIA COVE 
#sed 's_Cascadia Code _Caskaydia Cove _' fonts/CascadiaCode\[wght].ttx > fonts/temp_a
#sed 's_CascadiaCode_CaskaydiaCove_' fonts/temp_a > fonts/temp_b
#cp fonts/temp_b fonts/foo.ttx

# GFTOOLS HOTFIXES
# FIXES FONTBAKERY CHECK: com.google.fonts/check/dsig
#gftools fix-dsig -f fonts/*.ttf > /dev/null
# FIXES FONTBAKERY CHECK: com.google.fonts/check/smart_dropout
#gftools fix-nonhinting fonts/CaskaydiaCove[wght].ttf fonts/temp.ttf >/dev/null
#mv fonts/temp.ttf fonts/CaskaydiaCove[wght].ttf
#rm -rf fonts/*backup-fonttools-prep-gasp.ttf

# PYTHON SCRIPTS
#python3 sources/google-fonts-scripts/hello.py fonts/CascadiaCode\[wght\].ttf
#python3 sources/google-fonts-scripts/fix_os2_metrics_match_hhea.py fonts/CaskaydiaCove\[wght\].ttf
#python3 sources/google-fonts-scripts/fix_win_ascent_and_descent.py fonts/CaskaydiaCove\[wght\].ttf
#python3 sources/google-fonts-scripts/fix_name_table.py fonts/CaskaydiaCove\[wght\].ttf

# CLEAN UP BUILD FILES
#rm -rf BUILD_VENV

# GOOGLE FONTS FLAG (-gf) SECTION

echo "\n[INFO] Done!😃"

