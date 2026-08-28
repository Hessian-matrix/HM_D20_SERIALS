# 固件与输出协议选择

:::{admonition} 选择原则
:class: page-summary

**4G / LoRa 表示差分数据来源，NMEA / UBX 表示对外输出协议。** D20 地面版默认 10 Hz NMEA，无人机版默认 10 Hz UBX；D13 默认输出 10 Hz NMEA，可按需求配置为 UBX。
:::

## 出厂固件选择

| 产品 | 目标设备 | 固件 | 默认输出 |
| --- | --- | --- | --- |
| HM-D20 | ArduPilot、PX4 等飞控 | 无人机版 | 10 Hz UBX |
| HM-D20 | Viobot2、机器人主控、PC | 地面版 | 10 Hz NMEA |
| HM-D13 | 地面设备、机器人主控、PC | 地面版 | 10 Hz NMEA；可按需求配置 UBX |

RTK 最高更新率为 10 Hz，默认 10 Hz 是当前标准交付配置。修改输出前，需要确认串口带宽、消息数量和下游设备兼容性；PVT 与 RAW 原始数据的频率边界见[产品对比与资料](../../products/comparison.md)。

:::{tip}  **下单时直接说明目标平台：**
说明计划接入的飞控、机器人主控或 PC，以及所需 NMEA / UBX 输出，可按用途完成出厂配置。
:::


## 输出检查

- NMEA 输出：按{ref}`连接 NavStarTool <connect-navstartool>`或在串口控制台中确认 NMEA 语句持续刷新。
- UBX 输出：通过目标飞控、地面站或其他兼容设备确认定位数据和状态持续更新。
- 默认串口波特率：115200 bps。

需要修改输出频率或消息项时，使用[常用参数配置](../maintenance/parameters.md)。需要更换固件时，先确认目标平台，再按[固件升级](../maintenance/firmware-update.md)操作。
