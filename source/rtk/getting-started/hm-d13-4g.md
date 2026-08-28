# HM-D13-4G 首次使用

:::{admonition} 本页目标
:class: page-summary

将 **HM-D13-4G** 从开箱状态运行到首次获得 **RTK 固定解**。开始前准备蜂窝网络、Nano-SIM 卡和 CORS/NTRIP 账号。
:::

## 1. 核对设备与配件
产品标配：
- HM-D13-4G 移动站。
- 5-pin GH1.25 mm 接口线缆。
- USB-C 配置线。
- 兼容 3.3 V UART I/O 的 USB 转 UART 转接器。

用户自备：
- 5 V ±0.5 V 电源。
- 有流量的 Nano-SIM 卡。
- CORS/NTRIP 账号和[对应配置工具](https://github.com/myrobotproject/RTK_Interface-Description/blob/main/JR_NTRIP_Config_Tool_V1.2_EN.rar)。

```{figure} ../../products/images/photos/d13-4g-package.jpg
:alt: HM-D13-4G 主要组件与包装
:width: 82%
:align: center

HM-D13-4G 主要组件
```

:::{note}
图片用于辅助识别产品和主要组件；实际交付内容以本页文字清单和随货装箱清单为准。
:::

## 2. 确认输出协议

D13 默认输出 10 Hz NMEA，可按需求配置为 UBX。接入前按目标设备确认交付输出协议。

## 3. 安装 SIM 卡并写入账号

HM-D13-4G 的 Nano-SIM 卡槽和 USB-C 配置口位于顶壳内部。断电后打开顶壳，安装 Nano-SIM 卡，再按[4G/CORS 配置](../differential-links/4g-ntrip.md)写入账号并确认工具返回成功。

完成配置后断开 USB-C 线，恢复顶壳并确认装配可靠。

## 4. 安装移动站

将 D13 设备安装在天空视野开阔的位置，尽量避开金属遮挡、高楼、树木和强电磁干扰源。

## 5. 连接供电与 UART

保持设备断电并按[D13 接口与接线](../operation/d13-wiring.md)核对 Pin 1–5。设备供电为 5 V ±0.5 V，UART/PPS I/O 为 3.3 V；TX/RX 交叉连接并共地，确认信号和极性后上电。

## 6. 查看定位输出

串口默认 115200 bps。按{ref}`连接 NavStarTool <connect-navstartool>`或使用目标设备确认当前配置的协议持续输出，常规地面版为 10 Hz NMEA。

## 7. 验证 RTK 固定解

按[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)，通过与当前输出协议兼容的工具或目标设备检查定位输出和解状态。

:::{admonition} 首次使用完成判据
:class: success-check

**定位数据持续输出，并进入 RTK 固定解。**
:::

若无法进入固定解，检查 Nano-SIM 卡、网络覆盖、CORS 账号、设备视野和供电，再进入[故障排查](../troubleshooting/troubleshooting.md)。

## 下一步

- [上位机连接与串口调试](../operation/host-tool.md)
- [平台接入](../integrations/index.rst)
- [常用参数配置](../maintenance/parameters.md)
