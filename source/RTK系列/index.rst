RTK系列
======================================

RTK 系列当前包含 D20 移动站和 D13 基站。D20 用于输出高精度定位结果，
D13 用于 LoRa 场景下提供本地差分数据链路。本文档将 D20、D13 的公共
使用说明作为 RTK 系列用户手册组织。

.. image:: image/rtk_series_d20_interface.png
   :alt: RTK系列设备接口示意

资料入口
--------------------------------------

.. list-table:: RTK系列资料
   :header-rows: 1

   * - 类型
     - 内容
     - 链接
   * - 产品选型
     - D20 4G/LoRa、无人机版/地面版固件、D13 基站说明
     - :doc:`D20系列/D20系列介绍`
   * - D13基站
     - D13 系统能力、D13 基站架设和使用说明
     - :doc:`D13系列/D13基站系统介绍`
   * - 快速使用
     - 首次上电、差分链路准备、定位输出验证
     - :doc:`快速开始`
   * - 上位机工具
     - NavStarTool 状态查看和参数配置
     - :doc:`基本使用/上位机连接与状态查看`
   * - 固件升级
     - 固件升级入口和注意事项
     - :doc:`参数配置和维护/固件升级`
   * - 差分链路
     - 4G CORS/NTRIP、LoRa 和 D13 基站
     - :doc:`差分链路配置/index`

软件下载
--------------------------------------

.. list-table:: 软件和外部资料
   :header-rows: 1

   * - 名称
     - 用途
     - 链接
   * - NavStarTool
     - 查看定位状态、配置输出频率和协议输出项
     - `软件下载 <https://github.com/myrobotproject/RTK_Interface-Description/releases/tag/NavStarToolSoftware>`__
   * - RTK Interface Description
     - NavStarTool 配置说明和 RTK 接口资料
     - `配置资料 <https://github.com/myrobotproject/RTK_Interface-Description>`__

.. toctree::
   :maxdepth: 2
   :caption: RTK系列用户手册:

   概述
   快速开始
   D20系列/index
   D13系列/index
   基本使用/index
   差分链路配置/index
   行业应用/index
   参数配置和维护/index
   常见问题/index
