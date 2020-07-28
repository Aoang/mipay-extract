#!/bin/bash

declare -a urls=(
'http://bigota.d.miui.com/20.6.18/miui_CMI_20.6.18_77cec102d3_10.0.zip'

)

EU_VER=20.6.18

declare -a eu_urls=(
'https://phoenixnap.dl.sourceforge.net/project/xiaomi-eu-multilang-miui-roms/xiaomi.eu/MIUI-WEEKLY-RELEASES/20.6.18/xiaomi.eu_multi_MI10Pro_20.6.18_v12-10.zip'
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



echo "id=mipay-mi8" > magisk/module.prop
echo "name=MiPay for Mi8" >> magisk/module.prop
echo version=`date +"%Y-%m-%d"` >> magisk/module.prop
echo versionCode=`date +"%Y%m%d"` >> magisk/module.prop
echo "author=Aoang" >> magisk/module.prop
echo "description=MIUI for eu MiPay" >> magisk/module.prop

unzip -n -d magisk mipay-MI8-*.zip
unzip -n -d magisk eufix-appvault-MI8-*.zip
unzip -n -d magisk eufix-MI8-*.zip

cd magisk && zip -q -r ../mipay-magisk.zip *



exit 0
