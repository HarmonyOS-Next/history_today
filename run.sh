#!/bin/bash

# 运行鸿蒙一键构建部署脚本
# 使用前请确保 hdc 已连接设备，DevEco Studio 工具链已安装

set -e

# ================== 可配置变量 ==================
# DevEco Studio 安装路径(根据实际安装路径修改!!!!)
DEVECO_PATH="/Applications/DevEco-Studio.app/Contents/tools"
# 项目包名(根据实际项目包名修改!!!!!)
BUNDLE_NAME="com.uinav.family_tree"
# ================== 可配置变量 ==================

# ================== 固定的变量 ==================
# ohpm 路径
OHPM_BIN="$DEVECO_PATH/ohpm/bin/ohpm"
# node 路径
NODE_BIN="$DEVECO_PATH/node/bin/node"
# hvigor 路径
HVIGOR_BIN="$DEVECO_PATH/hvigor/bin/hvigorw.js"
# HAP 输出路径（请根据实际输出路径调整）
HAP_PATH="entry/build/default/outputs/default/entry-default-unsigned.hap"
# 临时目录名（可随机生成避免冲突）
TMP_DIR="hm_deploy_tmp_$$"
# ================== 固定的变量 ==================

echo "1. 安装依赖..."
$OHPM_BIN install --all --registry https://ohpm.openharmony.cn/ohpm/ --strict_ssl true

echo "2. 构建项目..."
$NODE_BIN $HVIGOR_BIN --sync -p product=default --analyze=normal --parallel --incremental --no-daemon

echo "3. 组装 HAP 包..."
$NODE_BIN $HVIGOR_BIN --mode module -p module=entry@default -p product=default -p requiredDeviceType=phone assembleHap --analyze=normal --parallel --incremental --daemon

echo "4. 停止正在运行的应用..."
hdc shell aa force-stop $BUNDLE_NAME || true

echo "5. 卸载旧应用..."
hdc uninstall $BUNDLE_NAME || true

echo "6. 创建临时目录..."
hdc shell mkdir -p data/local/tmp/$TMP_DIR

echo "7. 推送 HAP 包到设备..."
hdc file send $HAP_PATH data/local/tmp/$TMP_DIR/

echo "8. 安装 HAP 包..."
hdc shell bm install -p data/local/tmp/$TMP_DIR

echo "9. 删除临时文件..."
hdc shell rm -rf data/local/tmp/$TMP_DIR

echo "10. 启动应用..."
hdc shell aa start -a EntryAbility -b $BUNDLE_NAME

echo "✅ 构建部署完成！"