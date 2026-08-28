产品选型
======================================

.. admonition:: 本页用途
   :class: page-summary

   快速确定 **定位能力、产品形态和差分链路**。需要核对完整规格时进入“产品对比与资料”；已经收到设备时，可直接进入相应用户手册。

产品矩阵概览
----------------

定位产品分为 RTK 和 GNSS 两个系列。RTK 是当前主系列，包括轻量化四臂螺旋一体化 D20 和紧凑型一体化 D13；
两个系列均提供 4G 和 LoRa 差分链路。GNSS 系列当前提供 HM-G51B。

RTK 系列
~~~~~~~~~~~~~~~~

RTK 产品将 GNSS 天线、定位计算单元和通信链路集成在完整设备中，通过标准接口直接输出定位结果。
**D20** 适合对重量和空间敏感的无人机及移动平台；**D13** 适合地面移动站和固定区域作业。
下表用于选择产品形态和差分链路。

.. list-table:: RTK / GNSS 产品矩阵
   :class: product-matrix-overview
   :header-rows: 1
   :widths: 20 40 40

   * - 产品系列
     - **4G 通信链路**
     - **LoRa 通信链路**
   * - **D20 系列**
     - .. image:: images/scenarios/d20-4g-ref.png
          :alt: D20 通过 4G 接入 CORS 的高精度定位示意图

       * D20 移动站
       * 4G 接入 CORS/NTRIP
       * 适合跨区域移动作业
       * :doc:`查看 HM-D20-4G <models/hm-d20-4g>`
     - .. image:: images/scenarios/d20-lora-ref-v2.png
          :alt: D20 移动站通过 LoRa 连接 D13 基站的示意图

       * D20 移动站
       * 套件含 D13 LoRa 基站及配件
       * 本地自建差分链路
       * :doc:`查看 HM-D20-LoRa <models/hm-d20-lora>`
   * - **D13 系列**
     - .. image:: images/scenarios/d13-4g-ref-v2.png
          :alt: D13 通过 4G 接入 CORS 的高精度定位示意图

       * D13 移动站
       * 4G 接入 CORS/NTRIP
       * 适合稳定安装的移动作业
       * :doc:`查看 HM-D13-4G <models/hm-d13-4g>`
     - .. image:: images/scenarios/d13-lora-ref.png
          :alt: D13 移动站通过 LoRa 连接 D13 基站的示意图

       * D13 移动站
       * 套件含 D13 LoRa 基站及配件
       * 单基站一对一或一对多
       * :doc:`查看 HM-D13-LoRa <models/hm-d13-lora>`

GNSS 系列
~~~~~~~~~~~~~~~~

GNSS 系列目前以 HM-G51B 为代表，面向不需要 RTK 差分链路的独立 GNSS 定位和紧凑型终端集成场景，
适用于资产追踪、车载导航、紧凑型终端和对成本、尺寸、集成复杂度更敏感的应用。

* :doc:`查看 HM-G51B <models/hm-g51b>`

怎么选择
----------------

.. admonition:: 三步完成选择
   :class: key-facts

   **先看定位能力，再看安装形态，最后选择差分链路。**

1. **先看定位能力**：需要厘米级定位时选择 RTK 系列；只需要独立单频 GNSS 定位时选择 HM-G51B。
2. **再看安装形态**：对重量、空间和无人机集成更敏感时优先选择 D20；需要紧凑型封装或稳定地面安装时选择 D13。
3. **最后选差分链路**：有稳定蜂窝网络和 CORS/NTRIP 服务时选择 4G；希望本地自建、不依赖公网时选择 LoRa 套件。



快速入口
----------------

完成选型后，可核对完整参数，或按已购买产品进入对应手册：

* :doc:`产品对比与资料 <comparison>`：查看详细参数、软件工具和资料链接。
* :doc:`产品中心 <models/index>`：按产品型号查看产品介绍。
* :doc:`../rtk/getting-started/index`：开始使用 HM-D20 或 HM-D13。
* :doc:`../gnss/g51b/getting-started`：开始使用 HM-G51B。
* :doc:`../rtk/index`：查看完整 RTK 用户手册。

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: 选型与资料:

   产品中心 <models/index>
   产品对比与资料 <comparison>
