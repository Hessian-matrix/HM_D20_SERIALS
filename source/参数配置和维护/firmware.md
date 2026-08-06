# 固件升级

D20 可通过 NavStarTool 进行固件升级。升级前请确认设备供电稳定，升级过程中不要断电或拔出串口。

## 升级步骤

点击菜单栏：

```text
Receiver -> Firmware Upgrade
```

在弹出的窗口中选择 `Cus Network Files`，填写升级渠道信息，并设置 key：

```text
user11-HS
```

选择正确固件后，点击 `Send` 开始写入固件。

![Firmware Upgrade](image/firmware_upgrade.png)

![Firmware Channel](image/firmware_channel.png)

## 注意事项

- 升级前确认固件版本适用于当前 D20 硬件版本。
- 升级过程中保持 5V 供电稳定。
- 不要在升级过程中移动线缆、断开串口或关闭上位机。
- 升级完成后重新连接设备，确认卫星信息、协议输出和差分链路均正常。
