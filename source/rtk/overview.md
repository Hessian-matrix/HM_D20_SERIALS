# RTK 工作方式与手册结构

:::{admonition} 先理解两个选择维度
:class: page-summary

**产品形态**选择 D20 轻量化四臂螺旋一体化接收机或 D13 紧凑型一体化接收机；**差分链路**选择 4G 或 LoRa。4G 版本为移动站，LoRa 版本按移动站套件交付，并包含配套 D13 LoRa 基站及附件。
:::

## 共同工作方式

1. 设备接收 GPS、北斗、Galileo、QZSS、GLONASS 和 IRNSS 卫星信号。
2. 设备通过 4G/CORS 或本地 LoRa 链路获得差分数据。
3. 设备内部完成 RTK 解算。
4. 设备通过 UART 向飞控、机器人主控、Viobot2 或 PC 输出定位结果。

LoRa 差分数据在基站和移动站内部链路中传输，不作为外部用户接口。

## 4G 与 LoRa

| 选择 | 4G 版本 | LoRa 版本 |
| --- | --- | --- |
| 差分来源 | CORS/NTRIP 服务 | 套件内 D13 LoRa 基站 |
| 网络要求 | 需要蜂窝网络、SIM 卡和 CORS 账号 | 不依赖公网 |
| 现场设备 | 单个移动站 | 移动站 + 配套基站 |
| 适合场景 | 跨区域、分散作业 | 固定区域、自建链路 |

## 输出固件

通信版本决定差分数据从哪里来，固件版本决定定位结果如何向下游输出：

- D20 地面版默认 10 Hz NMEA，面向 Viobot2、机器人主控和 PC。
- D20 无人机版默认 10 Hz UBX，面向 ArduPilot、PX4 等飞控。
- D13 默认输出 10 Hz NMEA，可按需求配置为 UBX。

:::{important} 不要混淆通信版本与输出协议
**4G / LoRa** 决定差分数据来源，**NMEA / UBX** 决定定位结果的对外输出格式，两者可以独立选择。
:::

详细选择和修改边界见[固件与输出协议选择](operation/firmware-output.md)。

## 手册结构

| 用户任务 | 入口 |
| --- | --- |
| 第一次使用设备 | [按产品型号选择快速开始](getting-started/index.rst) |
| 查看接口、接线和输出状态 | [设备连接与状态验证](operation/index.rst) |
| 配置 CORS 或搭建 LoRa 链路 | [差分链路配置](differential-links/index.rst) |
| 接入 ArduPilot、PX4 或 Viobot2 | [平台接入](integrations/index.rst) |
| 修改参数或升级固件 | [参数配置和维护](maintenance/index.rst) |
| 定位或链路异常 | [常见问题](troubleshooting/index.rst) |

产品定位、交付组成和关键规格请查看[产品中心](../products/models/index.rst)；完整横向参数请查看[产品对比与资料](../products/comparison.md)。
