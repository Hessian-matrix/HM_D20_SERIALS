# 接入Viobot2

D20 可作为外部 RTK 定位终端接入 Viobot2，为 Viobot2 提供高精度 RTK 定位数据。本章节说明 D20 与 Viobot2 的硬件连接、驱动启动、RTK 模式配置和数据验证流程。

开始集成前，先按[固件与输出协议选择](../05-基本使用/固件与输出协议选择.md)确认地面版固件，并按[D20接口与接线](../05-基本使用/D20接口与接线.md)完成硬件连接。

## 固件版本

| 项目 | 要求 |
| --- | --- |
| D20 固件 | 地面版固件 |
| 主要输出协议 | 默认 10 Hz NMEA |
| 差分链路 | 按现场条件选择 4G 版本或 LoRa 版本 |

## 使用要求

Viobot2 通过 RTK NMEA 数据接入外部定位结果。D20 地面版固件默认输出 10 Hz NMEA，产品最高更新率为 20 Hz。接入时应至少开启以下语句：

- GGA：提供定位质量、经纬度、高程和卫星数。
- RMC：提供 UTC 时间、日期、速度和航向信息。

Viobot2 使用外部 RTK 时，需要在上位机设置中启用 RTK 模式。启用后，外部 RTK 数据会通过 `/rtk_nmea` 话题发布给 Viobot2 使用。

## 硬件连接

### USB转串口接入

如果 D20 通过 3.3 V USB 转 UART 模块接入 Viobot2，需要先确认设备节点：

```bash
ls /dev/ttyUSB*
```

将实际串口号写入 RTK 驱动 launch 文件。

### 板载串口接入

如果 D20 接入 Viobot2 后部串口，常用串口号为：

```bash
/dev/ttyS0
```

实际接线时需要确认 TX/RX 交叉连接，并保证 D20 与 Viobot2 共地。

## 安装和启动RTK驱动

黑森提供了 RTK 驱动仓库：

```bash
git clone https://github.com/Hessian-matrix/HM_RTK_driver
```

ROS 1 环境下可按以下方式编译：

```bash
mkdir -p HM_RTK_Driver_ws/src
cd HM_RTK_Driver_ws/src
git clone https://github.com/Hessian-matrix/HM_RTK_driver
cd HM_RTK_driver
git submodule init
git submodule update
cd ../../
catkin_make
```

启动驱动：

```bash
cd HM_RTK_Driver_ws
source ./devel/setup.bash
roslaunch hm_rtk hm_rtk.launch
```

定制版 Viobot2 若已预装 `HM_RTK`，通常只需要修改 launch 中的串口号和账号配置，然后直接启动：

```bash
source ~/HM_RTK/devel/setup.bash
roslaunch hm_rtk hm_rtk.launch
```

## 启用Viobot2 RTK模式

1. 打开 Viobot2 上位机并连接设备。
2. 进入设置页面。
3. 切换到 GNSS 设置页。
4. 勾选 RTK。RTK 和 GNSS 为单选关系，勾选 RTK 后会取消 GNSS。
5. 点击确定并重启 Viobot2。

## 验证数据

启动 D20、RTK 驱动和 Viobot2 算法后，确认 `/rtk_nmea` 有持续输出：

```bash
rostopic echo /rtk_nmea
```

再确认 Viobot2 侧已经解析到 RTK 数据：

```bash
rostopic echo /baton/rtk
```

如果 `/baton/rtk` 中 `status = 2`，表示当前 RTK 为固定解。

## 输出话题

开启 RTK 后，Viobot2 可输出融合后的定位相关话题：

```bash
/baton/stereo3/fusion_odom
/baton/stereo3/fusion_path
/baton/stereo3/rtk_path
/baton/stereo3/lla_odom
```

其中 `/baton/stereo3/fusion_odom` 为融合后的 odometry 输出；`/baton/stereo3/lla_odom` 中的位置为经纬高，单位分别为度、度、米。

## 时间同步

Viobot2 使用 RTK/GNSS 数据时，通常通过以下方式完成时间同步：

1. 板载 GNSS/PPS 同步系统时间。
2. RTK 驱动解析 D20 输出的 NMEA GGA 和 RMC 中的卫星时间。

接入时应确保 D20 输出 RMC，否则系统可能缺少完整 UTC 日期时间信息。

若 D20 自身未进入固定解，先使用[RTK状态与固定解验证](../05-基本使用/RTK状态与Fixed验证.md)排除差分链路问题，再检查 Viobot2 驱动和话题。
