# SMP 与 SMA 地图文件

炎黄服务端从 `Init/Map.SDB` 读取 `SmpName`，再以 `./Smp/<SmpName>` 创建地图。当前随包 `Smp/` 有 61 个 `.smp` 和 1 个 `.sma` 文件；只加载 `Map.SDB` 实际引用的名称。

## 二进制布局

`.SMP` 使用 16 字节头部：

| 偏移 | 长度 | 内容 |
|---|---:|---|
| 0 | 8 | `Ident` 字符数组 |
| 8 | 4 | `Width`，32 位整数 |
| 12 | 4 | `Height`，32 位整数 |
| 16 | `Width × Height` | 每格 1 字节的地图单元数据 |

源码常量为 `ATZMAP2`，但当前校验只比较 `Ident` 的前 4 个字符。通过后，服务器按宽高分配地图单元和用户占位数组。

同名 `.SMA` 是可选区域索引文件，头部同样为 8 字节标识加宽高，随后是 `Width × Height` 个区域字节。加载器只校验 SMA 的宽高，不校验其标识。缺少 SMA 或尺寸不符时，区域数组保持为空，`GetAreaIndex` 返回 0。

两个数组都按 `y × Width + x` 定位。

## 运维注意

- `.SMP` 是服务器碰撞/可行走判断的基础文件；缺失或损坏不能用客户端图片替代。
- 宽高直接参与内存分配，错误头部可能造成异常分配或越界风险。
- 不要用文本编辑器修改。替换前停服并备份 `Map.SDB`、对应 SMP/SMA 和 Setting 场景表。
- SMA 区域值会参与建门派等区域规则；“文件可缺省”不等于所有地图都应省略。

源码依据：`MapUnit.pas` 的 `TMaper.LoadMapFromFile`、`LoadSMAFromFile`、`GetAreaIndex`，以及 `uManager.pas` 的地图创建逻辑。
