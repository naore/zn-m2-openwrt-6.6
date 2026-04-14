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
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

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
