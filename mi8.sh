#!/bin/bash

declare -a urls=(
'http://bigota.d.miui.com/20.3.19/miui_MI8_20.3.19_983a830d92_10.0.zip'
)

EU_VER=20.3.19

declare -a eu_urls=(
'https://pilotfiber.dl.sourceforge.net/project/xiaomi-eu-multilang-miui-roms/xiaomi.eu/MIUI-WEEKLY-RELEASES/20.3.19/xiaomi.eu_multi_MI8_20.3.19_v11-10.zip'
)

command -v dirname >/dev/null 2>&1 && cd "$(dirname "$0")"
if [[ "$1" == "rom" ]]; then
    set -e
    base_dir=~
    [ -z "$2" ] && VER="$EU_VER" || VER=$2
    [ -d "$base_dir" ] || base_dir=.
    aria2c_opts="--check-certificate=false --file-allocation=trunc -s10 -x10 -j10 -c"
    aria2c="aria2c $aria2c_opts -d $base_dir/$VER"
    for i in "${eu_urls[@]}"
    do
        $aria2c ${i//$EU_VER/$VER}
    done
    base_url="https://github.com/Aoang/mipay-extract/releases/download/$VER"
    $aria2c $base_url/eufix-MI8-$VER.zip
    $aria2c $base_url/mipay-MI8-$VER.zip
    $aria2c $base_url/eufix-appvault-MI8-$VER.zip
    $aria2c $base_url/eufix-force-fbe-oreo.zip
    exit 0
fi
for i in "${urls[@]}"
do
   bash extract.sh --appvault "$i" || exit 1
done
[[ "$1" == "keep"  ]] || rm -rf miui-*/ miui_*.zip
for i in "${eu_urls[@]}"
do
   bash cleaner-fix.sh "$i" || exit 1
done
exit 0
