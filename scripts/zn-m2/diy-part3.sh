#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 3 (After Install feeds)
#

# Modify default IP
# sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

#修改版本信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt IPQ6000 ZN-M2 (build time: $(date +%Y%m%d))'/g"  package/base-files/files/etc/openwrt_release

# ttyd免登陆
sed -i -r 's#/bin/login#/bin/login -f root#g' feeds/packages/utils/ttyd/files/ttyd.config

# 新版的 OpenWrt/ImmortalWrt 中，libcrypt 已經被 libxcrypt 取代。
sed -i 's/libcrypt-compat/libxcrypt-compat/g' package/feeds/packages/*/Makefile
sed -i 's/libcrypt/libxcrypt/g' package/feeds/packages/*/Makefile

#解決 APK 模式下的 conffiles 錯誤
# 如果你的 .config 是舊的，強制改回 OPKG 模式（最穩定的做法）
# sed -i 's/CONFIG_USE_APK=y/# CONFIG_USE_APK is not set/' .config

# 变更kernel版本
#cat <<EOF > package/feeds/include/kernel-6.6
#LINUX_VERSION-6.6 = .93
#LINUX_KERNEL_HASH-6.6.93 = 0d79ff359635e9f009f1e330deed5f3aefd8c452b80660bffdc504b877797719
#EOF

#配置文件修改
echo "CONFIG_PACKAGE_luci=y" >> ./.config
echo "CONFIG_LUCI_LANG_zh_Hans=y" >> ./.config
echo "CONFIG_PACKAGE_luci-theme-$WRT_THEME=y" >> ./.config
echo "CONFIG_PACKAGE_luci-app-$WRT_THEME-config=y" >> ./.config

# 6.12内核
# 修改补丁文件：将 q6 预留从 64MB (0x4000000) 改为 16MB (0x1000000)
#sed -i 's/0x4ab00000 0x0 0x4000000/0x4ab00000 0x0 0x1000000/g' target/linux/qualcommax/patches-6.12/0135-arm64-dts-ipq6018-add-reserved-memory-nodes.patch

# libwrt修改地址
DTS_PATH="./target/linux/qualcommax/dts"
#find $DTS_PATH -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +

# 6.6内核
# 修改补丁文件：将 q6 预留从 95MB (0x05f00000) 改为 16MB (0x1000000)
sed -i 's/0x4b000000 0x0 0x05f00000/0x4b000000 0x0 0x01000000/g' target/linux/qualcommax/patches-6.6/0102-arm64-dts-ipq8074-add-reserved-memory-nodes.patch
cat target/linux/qualcommax/patches-6.6/0102-arm64-dts-ipq8074-add-reserved-memory-nodes.patch

# openwrtfork/libwrt修改地址
DTS_PATH2="./target/linux/qualcommax/files/arch/arm64/boot/dts/qcom"
find $DTS_PATH2 -type f ! -iname '*nowifi*' -exec sed -i 's/ipq\(6018\|8074\).dtsi/ipq\1-nowifi.dtsi/g' {} +

cat << EOF > $DTS_PATH2/ipq6018-nowifi.dtsi
// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#include "ipq6018.dtsi"

&q6_region {
	reg = <0x0 0x4ab00000 0x0 0x1000000>;
};

&q6_etr_region {
	reg = <0x0 0x4bb00000 0x0 0x100000>;
};

&m3_dump_region {
	reg = <0x0 0x4bc00000 0x0 0x100000>;
};

&ramoops_region {
	reg = <0x0 0x4bd00000 0x0 0x100000>;
};
EOF
