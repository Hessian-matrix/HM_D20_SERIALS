# HM-D13-4G

:::{admonition} 产品定位
:class: page-summary

**面向地面移动作业的紧凑型双频一体化 RTK 接收机。** 集成 GNSS 天线、定位计算单元与 4G 通信链路，通过蜂窝网络接入 CORS/NTRIP。
:::

```{image} ../images/photos/d13-4g-product.jpg
:alt: HM-D13-4G 一体化 RTK 接收机
:class: sku-product-image
```

## 核心价值

- **紧凑型一体化设计**：GNSS 天线、定位计算单元与 4G 通信链路集成在设备内部，外部安装简洁。
- **无需本地基站**：通过 4G 接入 CORS/NTRIP，适合跨区域和分散作业。
- **单接口接入主机**：外部 5-pin GH1.25 mm 接口完成供电、UART 和 PPS 连接。
- **输出灵活**：可按交付用途配置 NMEA 或 UBX；默认 10 Hz NMEA，便于接入机器人主控、PC 和通用串口设备。

## 工作方式

![HM-D13-4G通过4G接入CORS](../images/scenarios/d13-4g-ref-v2.png)

设备接收 GNSS 卫星信号，并通过 4G 网络获取 CORS/NTRIP 差分数据；完成 RTK 解算后，通过 5-pin GH1.25 mm 接口向外部设备输出定位结果。

## 交付组成

- HM-D13-4G 移动站。
- 供电与串口线缆、USB-C 配置线和兼容 3.3 V UART I/O 的 USB 转 UART 转接器。

:::{important} 使用前提
用户需要自行准备**有流量的 Nano-SIM 卡、可用的 CORS/NTRIP 账号和蜂窝网络覆盖**。
:::

## 关键参数

| 项目 | 参数 |
| --- | --- |
| 定位类型 | L1/L5 双频 RTK |
| RTK 精度 | 水平 1.0 cm + 1 ppm；垂直 1.5 cm + 1 ppm |
| 启动 / RTK 首次固定 | 冷启动 28 s；热启动 1 s；RTK 首次固定 45 s |
| 输出协议 | NMEA 或 UBX；默认 10 Hz NMEA |
| RTK 最高更新率 | 10 Hz |
| 天线系统增益 | 40 dB |
| 主接口 | 5-pin GH1.25 mm；UART/PPS I/O 3.3 V；默认 115200 bps |
| 供电 | 5 V ±0.5 V（4.5–5.5 V） |
| 工作电流 | 典型 120 mA |
| 尺寸 / 重量 | Φ152 × 67.9 mm / 255 g |
| 工作 / 存储温度 | -40–85 °C / -50–105 °C |

完整 GNSS 频点、灵敏度、动态条件和 LTE 频段请查看[产品对比与资料](../comparison.md)。

## 外部接口

- **5-pin GH1.25 mm**：供电、3.3 V UART 和 3.3 V PPS 信号，按固定 Pin 顺序连接。
- **Nano-SIM 卡槽**：位于顶壳内部。
- **USB-C 配置口**：位于顶壳内部，使用标配配置线写入 CORS/NTRIP 账号。

安装或更换 SIM 卡、连接配置口时需要打开顶壳；完成操作后应恢复设备结构并确认装配可靠。

## 适用场景与前提

适合测绘、精准农业、智能驾驶测试、地面机器人和其他稳定安装的移动作业。现场需要蜂窝网络覆盖；SIM 卡流量和 CORS/NTRIP 服务由用户管理。

## 下一步

- [HM-D13-4G 首次使用](../../rtk/getting-started/hm-d13-4g.md)
- [4G / CORS 配置](../../rtk/differential-links/4g-ntrip.md)
- [D13 接口与接线](../../rtk/operation/d13-wiring.md)
- [产品对比与资料](../comparison.md)
