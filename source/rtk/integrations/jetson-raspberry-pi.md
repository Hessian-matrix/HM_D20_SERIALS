# 接入 Jetson / 树莓派

:::{admonition} 本页目标
:class: page-summary

将 **HM-D20 或 HM-D13** 通过串口接入 Jetson、树莓派等 Linux 主控，并使用 `D20_ros_driver` 发布 ROS 定位话题。可使用产品标配的 **3.3 V USB 转 UART 转接器**，也可使用主板的 **3.3 V UART GPIO**。
:::

:::{important} 接入前先完成差分链路
**4G 版本**先完成 [4G/CORS 配置](../differential-links/4g-ntrip.md)；**LoRa 版本**先完成 [基站与移动站连接](../differential-links/lora.md)。差分链路由设备内部完成，驱动读取设备已输出的定位结果。
:::

驱动可解析 NMEA 或 UBX；接线前按[固件与输出协议选择](../operation/firmware-output.md)确认当前输出。

## 接线安全边界与接入前检查

请先完成以下检查，再给设备上电：

- **供电：5 V ±0.5 V（4.5–5.5 V）**。主板直连时，使用 Jetson/树莓派 40-pin 的 5 V 电源脚。
- **信号电平：UART 和 PPS 均为 3.3 V**。主控 GPIO UART 也必须是 3.3 V；禁止使用 5 V UART 或 RS232。
- **接线：TX/RX 交叉，GND 共地**。必须按 Pin 顺序核对线束，不能按颜色判断；电源正极接入信号脚可能损坏设备。

设备接口定义：[D20 接口与接线](../operation/d20-wiring.md) · [D13 接口与接线](../operation/d13-wiring.md)。
树莓派 UART 脚位参考 [pinout.xyz UART 定义](https://pinout.xyz/pinout/uart)；Jetson 请查阅与实际型号和载板对应的官方 40-pin 定义。

:::{admonition} 接入前检查清单
:class: check-list

- [ ] 已核对设备型号及对应接口 Pin 定义。
- [ ] 已核对主控型号、载板型号和 UART pinout。
- [ ] 已确认 5 V ±0.5 V 供电、3.3 V UART/PPS 电平。
- [ ] 已确认 TX/RX 交叉、GND 共地，线序而非颜色对应信号。

串口权限、系统占用和 GPIO UART 启用由下方平台脚本检查和处理。
:::

## 硬件接线

### 连接方式 A：主板 UART 直连

5 V 直接接主控 40-pin 的 5 V 脚，UART 按下表交叉连接。D20 的完整 8-pin 定义、D13 的完整 5-pin 定义请分别查看设备接口页；PPS 不是 ROS 接入必需信号。

| 信号 | D20 设备 Pin | D13 移动站 Pin | 树莓派 40-pin（物理脚位） | Jetson 40-pin（示例） |
| --- | ---: | ---: | --- | --- |
| 5 V 供电 | Pin 6 | Pin 2 (VCC) | Pin 2 或 4 | Pin 2 或 4 |
| GND | Pin 1 或 7 | Pin 1 | Pin 6、9、14、20、25、30、34 或 39 | Pin 6、9、14、20、25、30、34 或 39 |
| 设备 RX ← 主控 TX | Pin 5 | Pin 3 (RXD) | Pin 8（GPIO14 / TXD） | Pin 8（UART TX）* |
| 设备 TX → 主控 RX | Pin 4 | Pin 4 (TXD) | Pin 10（GPIO15 / RXD） | Pin 10（UART RX）* |

Jetson Pin 8/10 仅作 **Jetson Nano 2GB Developer Kit（J6）**和 **Jetson Orin Nano Developer Kit（J12）**官方载板的示例。其他型号、载板或第三方底板必须按实际 pinout 核对，不能直接套用。

### 连接方式 B：标配 USB 转 UART 转接器

使用产品随附的 USB 转 UART 转接器，按设备接口页连接 5 V、GND、TX、RX：

1. 转接器 USB 端插入 Jetson 或树莓派。
2. 转接器与设备 UART/PPS 均使用 3.3 V 电平；不要使用 5 V UART 转接器或 RS232。
3. 确认设备供电为 5 V ±0.5 V，TX/RX 交叉且 GND 已连接。

## 串口检测与数据读取

完成接线后，按连接方式选择检测方法：

- **USB 转 UART**：插入前后分别执行 `ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null`，比较列表，新增的设备即为设备串口。
- **主板 GPIO 直连**：下载并运行对应脚本。脚本会配置 GPIO UART、处理权限和系统占用，并提供串口读取检查。

中文页面下载：

- [Jetson GPIO UART 配置脚本（中文）](scripts/jetson_gpio_uart_zh.sh)
- [树莓派 GPIO UART 配置脚本（中文）](scripts/raspberry_pi_gpio_uart_zh.sh)

脚本菜单按 **1 → 2 → 3** 顺序执行：

1. 配置 GPIO 串口（USB 转 UART 已可识别时可跳过）。
2. 选择已确认的串口路径。
3. 读取串口数据，确认输出持续且正常。NMEA 可直接阅读；UBX 为二进制数据，终端中可能显示乱码，但持续读到数据即表示链路正常。

不要让多个程序同时打开同一串口。

## 安装驱动模块

驱动源码：<https://github.com/Hessian-matrix/D20_ros_driver>

包名和可执行文件名均为 `d20_ros_driver`。

### ROS1 Noetic

```bash
source /opt/ros/noetic/setup.bash
mkdir -p ~/d20_ros_ws/src
cd ~/d20_ros_ws/src
git clone https://github.com/Hessian-matrix/D20_ros_driver.git
cd ..
catkin_make
source devel/setup.bash
```

如果缺少 `empy`，安装 `python3-empy` 后重新编译。

### ROS2

```bash
source /opt/ros/<ros2-distro>/setup.bash
mkdir -p ~/d20_ros_ws/src
cd ~/d20_ros_ws/src
git clone https://github.com/Hessian-matrix/D20_ros_driver.git
cd ..
colcon build --packages-select d20_ros_driver
source install/setup.bash
```

## 配置驱动

安装完成后、执行 launch 前，必须编辑驱动仓库中的 `src/d20_ros_driver/config/config.yaml`。ROS1 和 ROS2 使用同一份配置，至少确认产品型号和 `serial_port`：

```yaml
sku: D20
serial_port: /dev/ttyUSB0
baudrate: 115200
frame_id: gps
navsatfix_topic: /d20_rtk/navsatfix
nmea_topic: /rtk_nmea
publish_nmea: true
```

`sku` 填写 `D20` 或 `D13`，`serial_port` 填写 Jetson/树莓派实际识别到的路径。

## 启动与验证

完成配置后再启动节点：

ROS1：

```bash
source /opt/ros/noetic/setup.bash
source ~/d20_ros_ws/devel/setup.bash
roslaunch d20_ros_driver d20_ros_driver.launch
```

ROS2：

```bash
source /opt/ros/<ros2-distro>/setup.bash
source ~/d20_ros_ws/install/setup.bash
ros2 launch d20_ros_driver d20_ros_driver.launch.py
```

## 话题与验证

| 话题 | 消息类型 | 内容 |
| --- | --- | --- |
| `/d20_rtk/navsatfix` | `sensor_msgs/NavSatFix` | 经纬度、椭球高、时间戳、定位状态和协方差 |
| `/rtk_nmea` | `std_msgs/String` | 原始 NMEA；仅在 `publish_nmea: true` 时发布 |

状态约定：`-1` 无定位，`0` 普通定位，`1` RTK 浮点解，`2` RTK 固定解。

ROS1：

```bash
rostopic list | grep -E 'd20_rtk|rtk_nmea'
rostopic echo /d20_rtk/navsatfix
rostopic echo /rtk_nmea
```

ROS2：

```bash
ros2 topic list | grep -E 'd20_rtk|rtk_nmea'
ros2 topic echo /d20_rtk/navsatfix
ros2 topic echo /rtk_nmea
```

:::{admonition} 接入完成判据
:class: success-check

定位话题持续发布，并能被驱动按当前输出协议解析；开阔环境进入固定解时，`NavSatFix.status.status` 为 `2`。
:::

设备在开阔场景，若长时间没有固定解时，先按[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)排查差分链路和卫星环境。

Viobot2 的专用流程请查看[接入 Viobot2](viobot2.md)。
