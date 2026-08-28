# Chinese-English terminology baseline

This table defines preferred public terminology. Chinese remains the factual
source, but English should express the same meaning in natural technical
language rather than reproduce Chinese word order or informal shape labels.

## Product categories

| Chinese source concept | Preferred English | Usage rule |
| --- | --- | --- |
| 一体化 RTK 接收机 | integrated RTK GNSS receiver | Formal category for HM-D20 and HM-D13 complete products. |
| 四臂螺旋天线 | quadrifilar helix antenna (QHA) | Formal term for the D20 antenna architecture. Spell it out on first use; `QHA` is acceptable afterward and in compact tables. |
| 紧凑型一体化设计 | compact all-in-one design | Preferred supporting description for D13; do not force a shape nickname into English. |
| 智能天线 | smart antenna | Accepted secondary industry or search term; not the primary formal category in this documentation. |
| RTK 移动站 | RTK rover | Use for a standalone 4G rover or the rover component of a LoRa kit. |
| RTK 基站 | RTK base station | Use for the dedicated D13 LoRa base station. |
| RTK 定位套件 | RTK GNSS base-and-rover kit | Use when the product includes both a rover and the dedicated D13 LoRa base station. |
| 单频多星座 GNSS 接收机模组 | single-band multi-constellation GNSS receiver module | Formal category for HM-G51B. |
| 定位计算单元 | positioning engine | Customer-facing functional description; avoid literal `positioning computing module`. |

## Positioning and correction links

| Chinese source concept | Preferred English | Usage rule |
| --- | --- | --- |
| 普通 GNSS 定位 | standalone GNSS positioning | Distinguishes G51B from RTK without implying reduced quality. |
| 固定解 | RTK fixed solution | Use `fixed solution` only when RTK context is already explicit. |
| 浮点解 | RTK float solution | Use `float solution` only when RTK context is already explicit. |
| RTK 首次固定 | RTK time to first fix | Do not shorten to generic `first fix` in specification tables. |
| 冷启动时间 | cold-start TTFF | Preserve the approved numeric value and conditions from Chinese. |
| 热启动时间 | hot-start TTFF | Preserve the approved numeric value and conditions from Chinese. |
| 原始观测数据 | raw observations | Use for GNSS RAW measurements; do not call them raw positioning results. |
| 差分链路 | correction link | Do not use the literal `differential link`. |
| 差分数据 | RTK correction data | `Corrections` is acceptable when RTK context is already explicit. |
| CORS/NTRIP 服务 | CORS/NTRIP service | Use `NTRIP correction service` where CORS is not the focus. |
| 本地 LoRa 差分链路 | local LoRa correction link | LoRa transports corrections between the base and rover. |
| 一对一 / 一对多 | one-to-one / one-to-many | Keep the single-base topology explicit where relevant. |

## Interfaces and workflows

| Chinese source concept | Preferred English | Usage rule |
| --- | --- | --- |
| 串口 | serial port | Use `UART` when referring to the electrical interface or protocol specifically. |
| 线序定义 | pinout | Use for connector pin numbers and signal assignments. |
| 串口 I/O 电平 | UART I/O level | Keep separate from the 5 V supply voltage. D20/D13 UART I/O is 3.3 V; 5 V UART logic may damage the device. |
| USB 转 UART 转接器 / USB-TTL 转接器 | USB-to-UART adapter | Preferred formal term. D20 and D13 products include an adapter compatible with 3.3 V UART I/O. |
| 供电电压 | supply voltage | Preserve tolerance and range exactly. |
| 上位机 | host PC | Do not use `upper computer` or `host computer`. |
| 飞控 | flight controller | Use the platform name when referring to ArduPilot or PX4 specifically. |
| 首次使用 | getting started | Use for navigation labels and first-run procedures. |
| 固件升级 | firmware update | Use `firmware version` for version selection. |
| 故障排查 | troubleshooting | Troubleshooting pages retain symptom, checks, and resolution order. |

## Prohibited formal product labels

Do not use `dome-style`, `mushroom-head`, or `puck-style` as English product
categories. Do not describe HM-D20 or HM-D13 as an `RTK antenna` when the
sentence refers to the complete product. These products integrate the GNSS
antenna, positioning engine, communication link, enclosure, and interfaces.

`Smart Antenna` may appear as a secondary market term, but the formal product
category remains `Integrated RTK GNSS Receiver`.
