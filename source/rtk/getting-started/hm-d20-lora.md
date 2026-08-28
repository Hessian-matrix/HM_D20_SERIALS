# HM-D20-LoRa 首次使用

:::{admonition} 本页目标
:class: page-summary

将 **HM-D20-LoRa 套件**从开箱状态运行到移动站首次获得 **RTK 固定解**。套件使用本地 LoRa 差分链路，不需要 SIM 卡或 CORS 账号。
:::

## 1. 核对套件

产品配备：
- HM-D20-LoRa 移动站、8-pin 连接线和外置 LoRa 天线。
- 兼容 3.3 V UART I/O 的 USB 转 UART 转接器。
- 配套专用 D13 LoRa 基站硬件、基站外置 LoRa 天线和封装好的 4-pin USB 线缆。
- 基站安装支架及随套件提供的附件。基站和移动站出厂默认配对，上电自动连接。

用户自备：
- 移动站和基站所需的 5 V ±0.5 V 电源。

```{figure} ../../products/images/photos/d20-lora-package.jpg
:alt: HM-D20-LoRa 移动站主要组件与包装
:width: 82%
:align: center

HM-D20-LoRa 移动站主要组件
```

```{figure} ../../products/images/photos/d13-base-package.jpg
:alt: 配套 D13 LoRa 基站主要组件与包装
:width: 82%
:align: center

配套 D13 LoRa 基站主要组件
```

:::{note}
图片用于辅助识别产品和主要组件；实际交付内容以本页文字清单和随货装箱清单为准。
:::

## 2. 确认输出固件

- 接入 ArduPilot、PX4 等飞控：使用无人机版固件，默认输出 10 Hz UBX。
- 接入机器人、Viobot2 或 PC：使用地面版固件，默认输出 10 Hz NMEA。

具体选择请查看[固件与输出协议选择](../operation/firmware-output.md)。

## 3. 架设 D13 基站

按[LoRa 基站架设](../differential-links/d13-base-station.md)完成安装和供电。基站上电后保持静止；移动后需要重新上电。

## 4. 安装移动站天线

断电状态下，将 D20 外置 LoRa 天线连接到 SMA 接口并拧紧。移动站与基站之间尽量保持无遮挡或弱遮挡。

## 5. 连接移动站

:::{danger} 接线错误会损坏设备
保持设备断电并按[完整 8-pin 定义](../operation/d20-wiring.md)逐线核对。设备供电为 5 V ±0.5 V，UART/PPS I/O 为 3.3 V；禁止按导线颜色判断、反接电源或把 5 V 接入信号线。
:::

按[D20 接口与接线](../operation/d20-wiring.md)完成 5 V ±0.5 V 供电、共地和 TX/RX 交叉连接，逐线复核后再上电。

## 6. 查看定位输出

串口默认 115200 bps。使用地面版固件时，按{ref}`连接 NavStarTool <connect-navstartool>`或使用串口终端确认 10 Hz NMEA 持续输出；使用无人机版固件时，通过目标飞控及其地面站确认 UBX 定位数据和 GPS 状态持续更新。

## 7. 验证 RTK 固定解

按[LoRa 移动站连接](../differential-links/lora.md)和[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)检查定位输出和解状态。

:::{admonition} 首次使用完成判据
:class: success-check

**基站稳定工作，移动站持续输出定位数据并进入 RTK 固定解。**
:::

若无法进入固定解，检查基站是否被移动、两端 LoRa 天线、基站供电、链路遮挡和天空视野，再进入[故障排查](../troubleshooting/troubleshooting.md)。

## 下一步

- [无人机应用 - ArduPilot](../integrations/ardupilot.md)
- [接入 PX4](../integrations/px4.md)
- [接入 Viobot2](../integrations/viobot2.md)
- [常用参数配置](../maintenance/parameters.md)
