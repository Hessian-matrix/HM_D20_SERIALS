# 接入 Viobot2

:::{admonition} 本页目标
:class: page-summary

将 **D20** 作为外部 RTK 定位终端接入 Viobot2，完成硬件连接、驱动启动、RTK 模式配置和数据验证。常规使用地面版固件，默认输出 **10 Hz NMEA**。
:::

开始集成前，先按[固件与输出协议选择](../operation/firmware-output.md)确认输出，并按[D20 接口与接线](../operation/d20-wiring.md)完成硬件连接。根据现场条件选择 4G 或 LoRa 差分链路。

## 使用要求

Viobot2 通过 NMEA 接入外部 RTK 定位结果，至少需要以下语句：

- GGA：提供定位质量、经纬度、高程和卫星数。
- RMC：提供 UTC 时间、日期、速度和航向信息。

Viobot2 使用外部 RTK 时，需要在上位机设置中启用 RTK 模式。启用后，外部 RTK 数据会通过 `/rtk_nmea` 话题发布给 Viobot2 使用。

## 硬件连接

### USB 转串口接入

如果 D20 通过产品标配的 3.3 V USB 转 UART 转接器接入 Viobot2，需要先确认设备节点：

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

## 启动 RTK 驱动

先按[接入 Jetson / 树莓派](jetson-raspberry-pi.md)完成 `D20_ros_driver` 的 ROS1 安装和串口配置，再启动驱动：

```bash
roslaunch d20_ros_driver d20_ros_driver.launch
```

定制版 Viobot2 若已预装驱动，只需确认配置文件中的串口号后启动。

## 启用 Viobot2 RTK 模式

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

:::{admonition} 接入完成判据
:class: success-check

`/rtk_nmea` 持续输出，Viobot2 能在 `/baton/rtk` 中解析到定位数据；设备固定时 `status = 2`。
:::

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

若 D20 自身未进入固定解，先按[RTK 状态与固定解验证](../operation/rtk-fixed-validation.md)检查定位输出、差分配置和现场条件，再检查 Viobot2 驱动和话题。
