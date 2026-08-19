# 接入 ROS1 / ROS2

`D20_ros_driver` 是面向 HM-D20、HM-D13 RTK 接收机的 ROS 驱动，负责从 Linux 串口读取设备输出，解析 NMEA GGA 或 UBX NAV-PVT，并发布 ROS 定位话题。

本驱动不替代设备内部的差分链路。4G 版本仍需先通过 [4G/CORS 配置](../06-差分链路配置/02-4G差分链路配置.md) 完成设备配置；LoRa 版本仍需先完成 [基站与移动站连接](../06-差分链路配置/03-LoRa差分链路配置.md)。D20/D13 的 RTCM 不作为外部串口接口，驱动不会向这两类设备回写 RTCM。

## 输出协议选择

| 产品固件 | 设备输出 | 驱动解析与发布 |
| --- | --- | --- |
| D20 地面版 | 10 Hz NMEA | 解析 GGA 并发布 `NavSatFix`，同时可转发原始 NMEA |
| D20 无人机版 | 10 Hz UBX | 解析 UBX NAV-PVT 并发布 `NavSatFix` |
| D13 地面版 | 10 Hz NMEA | 解析 GGA 并发布 `NavSatFix`，同时可转发原始 NMEA |

D20 接入无人机飞控时使用无人机版 UBX 固件；D13 只有地面版输出。固件和输出协议应在接线前按[固件与输出协议选择](../05-基本使用/固件与输出协议选择.md)确认。

## 硬件与环境

1. 按 [D20 接口与接线](../05-基本使用/D20接口与接线.md) 或 [D13 接口与接线](../05-基本使用/D13接口与接线.md) 完成接线。
2. 确认设备使用 5 V ±0.5 V 供电，UART IO 电平为 3.3 V；TX/RX 交叉连接并与主机共地。
3. Linux 主机应能看到串口设备，例如 `/dev/ttyUSB0` 或 `/dev/ttyS0`。没有访问权限时，将当前用户加入 `dialout` 用户组后重新登录。
4. 驱动默认使用 115200 bps；如果交付版本不同，应以设备资料为准修改配置。

## 获取驱动

驱动源码和最新说明位于：

<https://github.com/Hessian-matrix/D20_ros_driver>

仓库同时提供 ROS1 `catkin_make` 和 ROS2 `colcon` 构建入口，包名和可执行文件名均为 `d20_ros_driver`。

## ROS1

创建工作空间并编译：

```bash
source /opt/ros/noetic/setup.bash
mkdir -p ~/d20_ros_ws/src
cd ~/d20_ros_ws/src
git clone https://github.com/Hessian-matrix/D20_ros_driver.git
cd ..
catkin_make
source devel/setup.bash
```

启动默认配置：

```bash
roslaunch d20_ros_driver d20_ros_driver.launch
```

指定配置文件：

```bash
roslaunch d20_ros_driver d20_ros_driver.launch \
  config:=/path/to/config.yaml
```

如果系统提示缺少 `empy`，先安装 ROS Noetic 的 Python 模板依赖，再重新编译：

```bash
sudo apt install python3-empy
```

## ROS2

创建工作空间并编译：

```bash
source /opt/ros/<ros2-distro>/setup.bash
mkdir -p ~/d20_ros_ws/src
cd ~/d20_ros_ws/src
git clone https://github.com/Hessian-matrix/D20_ros_driver.git
cd ..
colcon build --packages-select d20_ros_driver
source install/setup.bash
```

启动默认配置：

```bash
ros2 launch d20_ros_driver d20_ros_driver.launch.py
```

指定配置文件：

```bash
ros2 launch d20_ros_driver d20_ros_driver.launch.py \
  config:=/path/to/config.yaml
```

## 配置串口与话题

复制仓库中的 `config/config.yaml`，至少确认以下字段：

```yaml
sku: D20
serial_port: /dev/ttyUSB0
baudrate: 115200
frame_id: gps
navsatfix_topic: /d20_rtk/navsatfix
nmea_topic: /rtk_nmea
publish_nmea: true

cors:
  enable: false
  writeback_enable: false
```

`sku` 按实际设备填写 `D20` 或 `D13`。对于 D20/D13，保持 `cors.writeback_enable: false`；4G/LoRa 差分数据由设备内部链路处理，驱动只读取设备已经输出的定位结果。

## 话题与状态

默认话题如下：

| 话题 | 消息类型 | 内容 |
| --- | --- | --- |
| `/d20_rtk/navsatfix` | `sensor_msgs/NavSatFix` | 经纬度、椭球高、时间戳、定位状态和协方差 |
| `/rtk_nmea` | `std_msgs/String` | 接收机输出的原始 NMEA 句子；仅在 `publish_nmea: true` 时发布 |

`NavSatFix.status.status` 的驱动约定为：

```text
-1 = 无定位
 0 = 普通定位
 1 = RTK 浮点解
 2 = RTK 固定解
```

NMEA 时间戳由 RMC/ZDA 的 UTC 日期和 GGA 的日内时间拼接；UBX NAV-PVT 使用帧内完整 UTC 时间。高度使用 WGS84 椭球高。

## 验证

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

在开阔环境确认定位数据持续输出，并进入 RTK 固定解。若设备本身没有固定解，先按[RTK 状态与固定解验证](../05-基本使用/RTK状态与Fixed验证.md)排查差分链路和卫星环境，再检查 ROS 话题。

## Viobot2

Viobot2 的专用连接和上位机配置请查看[接入 Viobot2](03-接入Viobot2.md)。该页面使用本驱动的 `/rtk_nmea` 话题，不需要额外集成一套旧版 RTK 驱动。
