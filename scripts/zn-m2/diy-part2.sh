#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
#优先安装 passwall 源
#./scripts/feeds install -a -f -p passwall_packages
#./scripts/feeds install -a -f -p passwall_luci

# 更新cmake
git clone -b main-nss --depth 1 https://github.com/LiBwrt/openwrt-6.x/ /tmp/repo
rm -rf ./tools/cmake/*
cp -r /tmp/repo/tools/cmake/* ./tools/cmake/
rm -rf /tmp/repo
