# 接入 Jetson / 树莓派

:::{admonition} 本页目标
:class: page-summary

将 **HM-D20 或 HM-D13** 通过串口接入 Jetson、树莓派等 Linux 主控，并使用 `D20_ros_driver` 发布 ROS 定位话题。可选择 **3.3 V USB-TTL** 或主板 **3.3 V UART GPIO** 两种连接方式。
:::

:::{important} 接入前先完成差分链路
**4G 版本**先完成 [4G/CORS 配置](../06-差分链路配置/02-4G差分链路配置.md)；**LoRa 版本**先完成 [基站与移动站连接](../06-差分链路配置/03-LoRa差分链路配置.md)。差分链路由设备内部完成，驱动读取设备已输出的定位结果。
:::

## 输出协议

驱动可解析 NMEA 或 UBX，接线前应按[固件与输出协议选择](../05-基本使用/固件与输出协议选择.md)确认设备当前的交付输出。

## 接线安全边界

1. D20/D13 设备供电为 **5 V ±0.5 V**（4.5–5.5 V）。Jetson/树莓派 GPIO 的 3.3 V 只能作为 UART 信号，不能给设备供电。
2. 设备 UART IO 电平为 **3.3 V**，USB-TTL 模块或主板 UART 必须兼容 3.3 V；禁止直接连接 RS232。
3. 设备与主控共地，设备 TX 接主控 RX，设备 RX 接主控 TX。
4. 上电前必须按 Pin 顺序核对线束；不要按颜色、插头外形或其他设备线序接线。电源正极接到 TX/RX 会损坏设备。

完整定义请查看：[D20 接口与接线](../05-基本使用/D20接口与接线.md)、[D13 接口与接线](../05-基本使用/D13接口与接线.md)。

## D20 接 Jetson / 树莓派

D20 使用 8-pin GH1.25 mm 接口，ROS 串口接入至少需要：

| D20 Pin | 信号 | 连接 |
| --- | --- | --- |
| 1 或 7 | GND | 主控 GND；Pin 7 是 PPS 配套地，并与 Pin 1 连通 |
| 4 | TX | 主控 UART RX |
| 5 | RX | 主控 UART TX |
| 6 | 5 V | 独立的 5 V ±0.5 V 电源正极 |

Pin 2/3 为磁力计 SDA/SCL，Pin 8 为 PPS，本页的 ROS 定位接入不使用它们。

## D13 接 Jetson / 树莓派

D13 移动站使用 5-pin GH1.25 mm 接口：

| D13 Pin | 信号 | 连接 |
| --- | --- | --- |
| 1 | GND | 主控 GND / 电源负极 |
| 2 | VCC | 独立的 5 V ±0.5 V 电源正极 |
| 3 | RXD | 主控 UART TX |
| 4 | TXD | 主控 UART RX |
| 5 | PPS | 可选秒脉冲输出 |

D13 移动站按 Pin 1–5 顺序连接，不能通过颜色判断功能。D13 LoRa 基站使用配套的封装 4-pin USB 线缆进行供电或连接电脑查看串口数据；ROS 定位主控应连接 D13 LoRa 移动站。

## 连接方式 A：USB-TTL

1. 选择 3.3 V IO 的 USB-TTL 模块，按上表交叉连接 TX/RX 并连接 GND。
2. 设备 5 V 由 D20 Pin 6 或 D13 Pin 2 单独提供；USB-TTL 的 USB 口只负责串口数据时，不要默认它能提供合规的设备电源。
3. 插入 Jetson/树莓派后查看设备名：

```bash
ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null
```

常见设备名为 `/dev/ttyUSB0` 或 `/dev/ttyACM0`。如设备名变化，优先使用 `/dev/serial/by-id/` 下的稳定路径。

## 连接方式 B：主板 UART 直连

1. 查阅所用 Jetson 载板或树莓派型号资料，确认目标 UART 为 3.3 V 电平。
2. 设备 TX 接主控 RX，设备 RX 接主控 TX，设备 GND 接主控 GND。
3. 设备 5 V 由独立电源输入，不能把 D20 Pin 6 或 D13 Pin 2 接到 3.3 V GPIO。
4. 确认 Linux 已启用 UART，并关闭占用该串口的登录控制台或其他服务。
5. 查看串口设备名：

```bash
ls /dev/ttyTHS* /dev/ttyS* /dev/serial* 2>/dev/null
```

不同 Jetson 载板和树莓派型号的 UART 引脚、设备名和启用方式可能不同，以实际硬件资料为准。

## 安装驱动

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
roslaunch d20_ros_driver d20_ros_driver.launch
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
ros2 launch d20_ros_driver d20_ros_driver.launch.py
```

## 配置串口

复制仓库中的 `config/config.yaml`，按实际产品和串口修改：

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

设备未固定时，先按[RTK 状态与固定解验证](../05-基本使用/RTK状态与Fixed验证.md)排查差分链路和卫星环境。

Viobot2 的专用流程请查看[接入 Viobot2](03-接入Viobot2.md)。
