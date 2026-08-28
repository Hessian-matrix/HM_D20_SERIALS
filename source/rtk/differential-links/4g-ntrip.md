# 4G / CORS 配置

:::{admonition} 本页目标
:class: page-summary

为 **HM-D20-4G 或 HM-D13-4G** 写入 CORS/NTRIP 账号，使设备能够通过蜂窝网络获得差分数据。用户需准备有流量的 SIM 卡、正确账号和蜂窝网络覆盖。
:::

## 准备工作

- HM-D20-4G 或 HM-D13-4G。
- 已开通数据流量的 SIM 卡。
- HM-D20-4G 使用的外置 SMA 4G 天线；HM-D13-4G 的 4G 天线内置。
- 产品标配的 USB-C 配置线。
- HM-D20-4G、HM-D13-4G 共用的 JR_NTRIP_Config_Tool_V1.2。
- CORS/NTRIP 账号信息，包括服务器地址、端口、挂载点、账号和密码。

## 产品差异

| 产品 | 4G 天线 | SIM 卡与配置口 |
| --- | --- | --- |
| HM-D20-4G | 外置 SMA 天线 | 使用 Nano-SIM 卡；USB-C 配置口位于设备外部 |
| HM-D13-4G | 天线内置 | Nano-SIM 卡槽和 USB-C 配置口位于顶壳内部 |

## 配置步骤

1. 安装 Nano-SIM 卡；HM-D13-4G 卡槽位于顶壳内部。
2. 使用 HM-D20-4G 时安装外置 SMA 4G 天线；HM-D13-4G 无需安装外置 4G 天线。
3. 使用标配 USB-C 配置线连接 PC 和设备配置口；HM-D13-4G 的配置口位于顶壳内部。
4. 打开 JR_NTRIP_Config_Tool_V1.2。HM-D20-4G 与 HM-D13-4G 使用相同的配置流程。
5. 点击 `Auto-Select Target Device` 自动选择配置端口。
6. 点击连接，确认底部日志区域显示连接成功。
7. 在 `NTRIP Server Configuration` 区域填写 CORS/NTRIP 账号信息。
8. 点击 `Send Config 1 (Server Settings)` 写入配置。
9. 日志区域返回 `OK` 后，配置完成。

![4G NTRIP 配置](../images/ntrip-config.png)

## 固定解验证

完成配置后，按[D20 接口](../operation/d20-wiring.md)或[D13 接口](../operation/d13-wiring.md)连接移动站并上电。

按[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)检查定位输出和解状态。若无法进入固定解，优先检查 SIM 卡状态、网络覆盖、CORS/NTRIP 账号、4G 天线和天空视野。

:::{admonition} 4G 差分配置完成判据
:class: success-check

配置工具写入返回 `OK`；移动站定位数据持续输出，并在开阔环境进入 **RTK 固定解**。
:::
