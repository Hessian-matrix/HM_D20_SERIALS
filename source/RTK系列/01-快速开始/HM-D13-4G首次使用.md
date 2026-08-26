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

用户自备：
- 5 V ±0.5 V 电源。
- 有流量的 Nano-SIM 卡。
- CORS/NTRIP 账号和[对应配置工具](https://github.com/myrobotproject/RTK_Interface-Description/blob/main/JR_NTRIP_Config_Tool_V1.2_EN.rar)。
- 兼容 3.3 V UART IO 的 USB 转 UART 模块，或目标设备串口。

## 2. 确认输出协议

D13 仅提供地面版，默认输出 10 Hz NMEA，可按需求配置为 UBX。接入前按目标设备确认交付输出协议。

## 3. 安装 SIM 卡并写入账号

HM-D13-4G 的 Nano-SIM 卡槽和 USB-C 配置口位于顶壳内部。断电后打开顶壳，安装 Nano-SIM 卡，再按[4G/CORS 配置](../06-差分链路配置/02-4G差分链路配置.md)写入账号并确认工具返回成功。

完成配置后断开 USB-C 线，恢复顶壳并确认装配可靠。

## 4. 安装移动站

将蘑菇头设备安装在天空视野开阔的位置，尽量避开金属遮挡、高楼、树木和强电磁干扰源。

## 5. 连接供电与 UART

按[D13 接口与接线](../05-基本使用/D13接口与接线.md)连接 5-pin GH1.25 mm 线缆：5 V 和 GND 供电，TX/RX 交叉连接，并与外部设备共地。按 Pin 1–5 顺序确认信号和极性后上电。

## 6. 查看定位输出

串口默认 115200 bps。按{ref}`连接 NavStarTool <connect-navstartool>`或使用目标设备确认当前配置的协议持续输出，常规地面版为 10 Hz NMEA。

## 7. 验证 RTK 固定解

按[RTK 状态与固定解验证](../05-基本使用/RTK状态与Fixed验证.md)，通过与当前输出协议兼容的工具或目标设备检查定位输出和解状态。

:::{admonition} 首次使用完成判据
:class: success-check

**定位数据持续输出，设备显示 RTK 固定解。** 进入固定解即可判断 CORS 差分通信链路正常。
:::

若无法进入固定解，检查 Nano-SIM 卡、网络覆盖、CORS 账号、设备视野和供电，再进入[故障排查](../09-常见问题/01-故障排查.md)。

## 下一步

- [上位机连接与串口调试](../05-基本使用/上位机连接与串口调试.md)
- [平台接入](../07-行业应用/index.rst)
- [常用参数配置](../08-参数配置和维护/01-常用参数配置.md)
