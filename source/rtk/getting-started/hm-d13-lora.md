# HM-D13-LoRa 首次使用

:::{admonition} 本页目标
:class: page-summary

将 **HM-D13-LoRa 套件**从开箱状态运行到移动站首次获得 **RTK 固定解**。套件使用本地 LoRa 差分链路，不需要 SIM 卡或 CORS 账号。
:::

## 1. 核对套件

产品配备：
- HM-D13-LoRa 移动站和 5-pin GH1.25 mm 接口线缆。
- 兼容 3.3 V UART I/O 的 USB 转 UART 转接器。
- 配套专用 D13 LoRa 基站硬件、基站外置 LoRa 天线和封装好的 4-pin USB 线缆。
- 基站安装支架及随套件提供的附件。

用户自备：
- 移动站和基站所需的 5 V ±0.5 V 电源。

基站和移动站出厂默认配对；专用 D13 LoRa 基站硬件不单独销售，也不作为移动站使用。

```{figure} ../../products/images/photos/d13-lora-package.jpg
:alt: HM-D13-LoRa 移动站主要组件与包装
:width: 82%
:align: center

HM-D13-LoRa 移动站主要组件
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

## 2. 确认输出协议

D13 默认输出 10 Hz NMEA，可按需求配置为 UBX。接入前按目标设备确认交付输出协议。

## 3. 架设 D13 基站

按[LoRa 基站架设](../differential-links/d13-base-station.md)完成安装和供电。基站上电后保持静止；移动后需要重新上电。

## 4. 安装并连接移动站

D13 移动站使用内置 LoRa 天线。将设备安装在天空视野开阔的位置，并按[D13 接口与接线](../operation/d13-wiring.md)连接：5 V ±0.5 V 供电，3.3 V UART/PPS I/O，TX/RX 交叉连接并共地。

## 5. 查看定位输出

串口默认 115200 bps。按{ref}`连接 NavStarTool <connect-navstartool>`或使用目标设备确认当前配置的协议持续输出，常规地面版为 10 Hz NMEA。

## 6. 验证 RTK 固定解

按[LoRa 移动站连接](../differential-links/lora.md)和[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)，使用与当前输出协议兼容的工具检查定位输出和解状态。

:::{admonition} 首次使用完成判据
:class: success-check

**基站稳定工作，移动站持续输出定位数据并进入 RTK 固定解。**
:::

若无法进入固定解，检查基站是否被移动、基站天线和供电、链路遮挡、移动站位置和天空视野，再进入[故障排查](../troubleshooting/troubleshooting.md)。

## 下一步

- [上位机连接与串口调试](../operation/host-tool.md)
- [平台接入](../integrations/index.rst)
- [常用参数配置](../maintenance/parameters.md)
