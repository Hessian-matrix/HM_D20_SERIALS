# HM-D20-4G 首次使用

:::{admonition} 本页目标
:class: page-summary

将 **HM-D20-4G** 从开箱状态运行到首次获得 **RTK 固定解**。开始前需准备可用的 Nano-SIM 卡和 CORS/NTRIP 账号，并确认现场有蜂窝网络覆盖。
:::

## 1. 核对设备与配件

产品标配：
- HM-D20-4G 移动站。
- 8-pin GH1.25 mm 连接线。
- 外置 4G 天线。
- USB-C 配置线。
- 兼容 3.3 V UART I/O 的 USB 转 UART 转接器。

用户自备：
- 5 V ±0.5 V 电源。
- 有流量的 Nano-SIM 卡。
- CORS/NTRIP 账号。

```{figure} ../../products/images/photos/d20-4g-package.jpg
:alt: HM-D20-4G 主要组件与包装
:width: 82%
:align: center

HM-D20-4G 主要组件
```

:::{note}
图片用于辅助识别产品和主要组件；实际交付内容以本页文字清单和随货装箱清单为准。
:::

## 2. 确认输出固件

- 接入 ArduPilot、PX4 等飞控：使用无人机版固件，默认输出 10 Hz UBX。
- 接入机器人、Viobot2 或 PC：使用地面版固件，默认输出 10 Hz NMEA。

固件由订单用途确定。需要调整时，先阅读[固件与输出协议选择](../operation/firmware-output.md)。

## 3. 安装 4G 天线

断电状态下，将外置 4G 天线连接到 SMA 接口并拧紧。天线可以布置到机臂或其他合适位置，避免紧贴大功率设备、金属遮挡或平台内部强干扰源。

## 4. 写入 CORS 账号

使用标配 USB-C 配置线连接设备配置口和 PC，按[4G / CORS 配置](../differential-links/4g-ntrip.md)写入服务器、端口、挂载点、账号和密码，并确认工具返回成功。

## 5. 连接供电与 UART

:::{danger} 接线错误会损坏设备
保持设备断电并按[完整 8-pin 定义](../operation/d20-wiring.md)逐线核对。设备供电为 5 V ±0.5 V，UART/PPS I/O 为 3.3 V；禁止按导线颜色判断、反接电源或把 5 V 接入信号线。
:::

按[D20 接口与接线](../operation/d20-wiring.md)完成连接：

1. Pin 6（5 V）接 5 V ±0.5 V 电源正极，Pin 1（GND）接电源负极并共地。
2. 设备 TX 接外部 RX，设备 RX 接外部 TX。
3. 仅使用定位时，SCL/SDA 可不连接。
4. 再次核对 Pin 顺序、信号、电压和极性后上电。

## 6. 查看定位输出

串口默认 115200 bps。使用地面版固件时，按{ref}`连接 NavStarTool <connect-navstartool>`或使用串口终端确认 10 Hz NMEA 持续输出；使用无人机版固件时，通过目标飞控及其地面站确认 UBX 定位数据和 GPS 状态持续更新。

## 7. 验证 RTK 固定解

将设备放置在天空视野开阔的位置，然后按[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)检查定位输出和解状态。

:::{admonition} 首次使用完成判据
:class: success-check

**定位数据持续输出，并进入 RTK 固定解。**
:::

若无法进入固定解，检查 4G 天线、Nano-SIM 卡流量、网络覆盖、CORS 账号、天线视野和供电，再进入[故障排查](../troubleshooting/troubleshooting.md)。

## 下一步

- [无人机应用 - ArduPilot](../integrations/ardupilot.md)
- [接入 PX4](../integrations/px4.md)
- [接入 Viobot2](../integrations/viobot2.md)
- [常用参数配置](../maintenance/parameters.md)
