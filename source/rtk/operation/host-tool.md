# 上位机连接与串口调试

:::{admonition} 本页目标
:class: page-summary

完成 D20、D13 的通用 UART 连接，并使用 **NavStarTool、串口控制台或 Linux 命令**确认定位数据持续输出。接线前先确认[D20 接口](d20-wiring.md)或[D13 接口](d13-wiring.md)。
:::

## 串口参数

| 项目 | 默认值 |
| --- | --- |
| 波特率 | 115200 bps |
| 数据位 | 8 |
| 停止位 | 1 |
| 校验 | None |
| 流控 | None |

D20、D13 均标配 USB 转 UART 转接器，转接器与设备外部 UART 均使用 3.3 V I/O 电平。若改用目标设备串口，也必须兼容 3.3 V UART I/O，且不能使用 RS232 电气接口。

(connect-navstartool)=
## 连接 NavStarTool

:::{tip} 获取 NavStarTool
尚未安装时，前往{ref}`软件工具下载 <software-tools>`获取 NavStarTool，再返回本节完成连接。
:::

1. 完成供电、TX/RX 交叉连接和共地。
2. 打开 NavStarTool，选择设备对应串口。
3. 波特率选择`115200`，点击连接。
4. 确认卫星数、经纬高、轨迹和原始数据持续刷新。

![NavStarTool主界面](../images/navstar-main.png)

使用星空图查看卫星分布、CN0 窗口查看信号强度、轨迹图查看定位变化、NMEA 信息窗口检查输出。UBX 输出使用目标飞控、地面站或其他兼容工具验证。

## 串口控制台

可通过`Receiver -> Console`打开控制台。没有持续数据时，依次检查：

1. 串口号和波特率。
2. TX/RX 是否交叉连接。
3. 设备和调试器是否共地。
4. 供电电压和极性。
5. 当前固件是否输出预期协议。

## Linux 下确认串口

连接产品标配的 USB 转 UART 转接器后，可使用以下命令确认设备节点：

```bash
dmesg --follow
ls -l /dev/ttyUSB*
```

例如设备节点为`/dev/ttyUSB0`时：

```bash
picocom -b 115200 /dev/ttyUSB0
```

出现持续数据表示串口链路已建立；协议含义和刷新率由出厂固件决定。

:::{admonition} 串口连接完成判据
:class: success-check

目标工具中持续出现定位数据，串口号、`115200` 波特率和输出协议均与当前交付配置一致。
:::

## 下一步

- 输出协议不符合目标设备要求：查看[固件与输出协议选择](firmware-output.md)。
- 已有数据但未进入固定解：查看[RTK状态与固定解验证](rtk-fixed-validation.md)。
- 串口仍无法连接：进入[故障排查](../troubleshooting/troubleshooting.md)。
