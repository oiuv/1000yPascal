# 千年 (1000y) 系统架构文档

> 基于 Delphi 7 源码分析，所有端口、状态转换、消息类型均来自实际代码。

---

## 1. 系统架构总览

### 1.1 架构图

```
                          ┌──────────────────────────────────────────────────────────────┐
                          │                     内网 (Internal)                           │
                          │                                                              │
                          │   ┌──────────┐    ┌──────────┐    ┌──────────┐              │
  ┌──────────┐  TCP 3053  │   │  Login   │    │    DB    │    │   Paid   │              │
  │  Client  │◄───────────┤   │  :3050   │    │  :3051   │    │ :5999    │              │
  │          │            │   └────▲─────┘    └────▲─────┘    └────▲─────┘              │
  │  (外部)  │            │        │               │               │                     │
  └────┬─────┘            │        │               │               │                     │
       │                  │   ┌────┴───────────────┴───────────────┴─────┐              │
       │ SM_CONNECTTHRU   │    │              Gate (网关)                 │              │
       ├─────────────────►│    │              TCP 3054                   │              │
       │                  │    │  ┌──────────────────────────────────┐   │              │
  ┌────▼─────┐  TCP 3054  │    │  │ 状态机: gs_none→gs_login→      │   │              │
  │ Balance  │◄──────────►│    │  │  gs_agree→gs_selectchar→       │   │              │
  │ (负载均衡)│            │    │  │  gs_gotogame→gs_playing        │   │              │
  └────▲─────┘            │    │  └──────────────────────────────────┘   │              │
       │                  │    └───────▲───────────────▲─────────────────┘              │
       │ UDP 3030         │            │               │                                 │
       │ (BM_GATEINFO)    │            │               │                                 │
       │                  │    ┌───────┴───────────────┴─────────────────┐              │
  ┌────┴─────┐            │    │              Game Server                 │              │
  │  Gate 1~10│───────────┤    │         (游戏服务器)                     │              │
  │ (TCP 3000│            │    │                                        │              │
  │  管理连接)│            │    │  ┌──────────┐  ┌──────────┐           │              │
  └──────────┘            │    │  │ 地图/怪物 │  │ 用户管理  │           │              │
                          │    │  │ NPC/物品  │  │ 行会/任务 │           │              │
                          │    │  └──────────┘  └──────────┘           │              │
                          │    └────────────────────────────────────────┘              │
                          │                                                              │
                          │   UDP 日志推送:                                              │
                          │   ITEM:6001  MOUSEEVENT:6010  MONITER:6011                 │
                          │   CONNECT:6022  PAY:6000  OBJECT:3003                      │
                          └──────────────────────────────────────────────────────────────┘
```

### 1.2 各服务职责

| 服务 | 源码目录 | 职责 |
|------|----------|------|
| **Balance** | `balance/` | 负载均衡器。接收客户端连接，根据最少连接数算法分配至可用 Gate，通过 UDP 接收 Gate 心跳 |
| **Gate** | `gate_biscuit/` | 网关服务器。维护客户端连接和完整登录状态机，路由消息到 Game/DB/Login/Paid |
| **Login** | `loginsql/` | 登录服务器。管理账号数据（注册/验证/密码），通过 ODBC 连接 SQL Server |
| **DB** | `db/` | 数据库服务器。管理角色数据持久化，使用自定义 FDB 文件格式存储 |
| **Game** | `gameserver-tgs1000/` | 游戏服务器。处理游戏逻辑、地图管理、怪物/NPC 更新、用户交互 |
| **Paid** | （外部服务） | 计费服务器。验证用户付费状态和到期时间 |

### 1.3 建议的部署边界

按协议拓扑，客户端只需要访问以下端口：

- `Balance TCP 3053` — 客户端初始连接入口（短连接）
- `Gate TCP 3054` — 客户端游戏连接入口（长连接）

因此生产部署通常只对外开放 Balance 和 Gate，其余服务应由防火墙限制在内网。源码中的 `RemoteIP.txt` 白名单提供额外限制，但源码本身不能证明服务器当前的公网暴露状态：

- Login (`sckAccept`) — 仅接受白名单 IP（`IPChecker.IsThereAtList`）
- DB (`sckAccept`) — 仅接受白名单 IP
- Game — 通过 Gate 间接访问，不直接对外

---

## 2. 服务端口表

### 2.1 TCP 端口

| 端口 | 服务 | 方向 | 用途 | 内/外网 |
|------|------|------|------|---------|
| **3053** | Balance | 监听 | 客户端连接入口 | **外网** |
| **3054** | Gate | 监听 | 客户端游戏连接入口 | **外网** |
| **3050** | Login | 监听 | Gate → Login 连接 | 内网 |
| **3051** | DB | 监听 | Gate → DB 连接 | 内网 |
| **3052** | Game | 监听 | Gate → Game 连接 | 内网 |
| **5999** | Paid | 监听 | Gate → Paid 连接 | 内网 |
| **3000** | Balance | 监听 | Gate 管理连接（TCP 通道） | 内网 |
| **1021** | Login | 远程管理 | Login 远程管理端口 | 内网 |
| **1024** | DB | 远程管理 | DB 远程同步端口 | 内网 |
| **1020** | DB | 远程管理 | DB 物品远程同步端口 | 内网 |
| **3040** | Battle | 监听 | 战斗服务器 | 内网 |
| **3020** | Notice | 监听 | 公告服务器 | 内网 |

### 2.2 UDP 端口

| 端口 | 方向 | 用途 |
|------|------|------|
| **3030** | Gate → Balance | Gate 心跳注册（`BM_GATEINFO`），每 3 秒发送 |
| **6001** | Game → Logger | ITEM 物品日志 |
| **6010** | Game → Logger | MOUSEEVENT 鼠标事件日志 |
| **6011** | Game → Logger | MONITER 监控日志 |
| **6022** | Game → Logger | CONNECT 连接日志 |
| **6000** | Game → Logger | PAY 计费日志 |
| **3003** | Game → Logger | OBJECT 对象日志 |
| **3005** | Game → Logger | RELATION 关系日志 |

> 所有 UDP 日志端口的目标 IP 和端口均可在 `sv1000.Ini` 中配置。

---

## 3. 负载均衡（Balance）

### 3.1 核心数据结构

```delphi
// balance/FMain.pas
TGateInfo = record
  boAvail     : Boolean;     // 是否可用
  boChecked   : Boolean;     // 管理员是否勾选启用
  RemoteIP    : String;      // Gate 的外网 IP
  RemotePort  : Integer;     // Gate 的客户端端口
  UserCount   : Integer;     // 当前连接数
  ReceiveTick : LongWord;    // 最后收到心跳的时间
end;

MAX_AVAILABLE_GATE = 10;    // 最多支持 10 个 Gate
```

### 3.2 最少连接数算法

当客户端连接到 Balance 时（`sckUserClientWrite`），遍历所有 Gate 寻找连接数最少的可用节点：

```delphi
// balance/FMain.pas — sckUserClientWrite
nIndex := -1;
MinCount := 0;
for i := 0 to MAX_AVAILABLE_GATE - 1 do begin
  if (GateInfo[i].boAvail = true) and (isGateChecked(i) = true) then begin
    if nIndex = -1 then begin
      MinCount := GateInfo[i].UserCount + 1;
    end;
    if GateInfo[i].UserCount < MinCount then begin
      nIndex := i;
      MinCount := GateInfo[i].UserCount;
    end;
  end;
end;
```

选中后向客户端发送 `SM_CONNECTTHRU` 消息，包含目标 Gate 的 IP 和端口：

```delphi
sConnectThru.rMsg := SM_CONNECTTHRU;
StrPCopy(@sConnectThru.rIpAddr, GateInfo[nIndex].RemoteIP);
sConnectThru.rPort := GateInfo[nIndex].RemotePort;
```

### 3.3 网关注册和心跳机制

当前 `gate_biscuit` 通过 UDP 向 Balance 注册：

**UDP 心跳**（主要方式）：Gate 每 3 秒通过 UDP 发送 `BM_GATEINFO`：

```delphi
// gate_biscuit/FMain.pas — timerDisplayTimer
if CurTick >= BalanceSendTick + 3000 then begin
  udpBalance.RemoteHost := BalanceConnectInfo.RemoteIP;
  udpBalance.RemotePort := BalanceConnectInfo.RemotePort;
  pBalanceData^.rMsg := BM_GATEINFO;
  StrPCopy(@pBalanceData^.rIpAddr, UserAcceptInfo.RemoteIP);
  pBalanceData^.rPort := UserAcceptInfo.LocalPort;
  pBalanceData^.rUserCount := ConnectorList.Count;
  udpBalance.SendBuffer(buffer, sizeof(TBalanceData));
end;
```

Balance 源码还监听 TCP 3000，并包含处理 `BM_GATEINFO` 的 `TGateConnector`；但当前仓库的 `gate_biscuit` 没有对应 TCP 客户端连接代码，因此不能把它描述为本版本 Gate 的有效注册通道。

**超时判定**：Balance 每秒检查，如果 5 秒未收到某 Gate 的心跳，标记为不可用：

```delphi
// balance/FMain.pas — timerDisplayTimer
if CurTick >= GateInfo[i].ReceiveTick + 5000 then begin
  GateInfo[i].boAvail := false;
  DrawStatus(i);
end;
```

### 3.4 短连接设计（10 秒超时）

Balance 与客户端的连接是**短连接**。客户端连接后，Balance 在 `OnWrite` 事件中立即发送 `SM_CONNECTTHRU` 重定向消息。连接创建后记录 `CreateTime`，10 秒后如果连接仍未关闭则强制断开：

```delphi
// balance/uConnect.pas — TConnectorList.Update
if CurTick >= Connector.CreateTime + 10000 then begin
  Connector.Socket.Close;
end;
```

客户端收到 `SM_CONNECTTHRU` 后应主动断开并连接到指定 Gate。

---

## 4. 网关（Gate）状态机

### 4.1 TGameStatus 状态转换

```delphi
// gate_biscuit/uConnector.pas
TGameStatus = (
  gs_none,         // 空闲/未登录
  gs_login,        // 等待登录验证
  gs_agree,        // 仅声明；当前 Gate 流程未使用
  gs_selectchar,   // 角色选择界面
  gs_gotogame,     // 正在进入游戏（等待 Game 确认）
  gs_playing,      // 游戏中
  gs_createchar,   // 创建角色中
  gs_deletechar,   // 删除角色中
  gs_createlogin,  // 创建账号中
  gs_changepass    // 修改密码中
);
```

源码中的实际登录/选角状态转换如下。`LG_SELECT` 成功后 Gate 会把状态恢复为 `gs_none`；只有收到角色选择请求后才进入 `gs_selectchar`：

```
gs_none ──(客户端发送登录)──► gs_login
gs_login ──(LG_SELECT 成功，显示角色列表并发起 Paid 校验)──► gs_none
gs_none ──(计费状态有效且客户端选择角色)──► gs_selectchar
gs_selectchar ──(选择角色 + DB_SELECT 成功)──► gs_gotogame
gs_gotogame ──(Game 回复 GM_CONNECT)──► gs_playing
gs_playing ──(断开/顶号)──► gs_none
```

### 4.2 TClientWindow 窗口状态

```delphi
// gate_biscuit/uConnector.pas
TClientWindow = (
  cw_none,         // 无窗口
  cw_login,        // 登录窗口
  cw_createlogin,  // 创建账号窗口
  cw_selectchar,   // 角色选择窗口
  cw_main,         // 游戏主窗口
  cw_agree         // 仅声明；当前 Gate 流程未使用
);
```

Gate 通过 `SM_WINDOW` 消息控制客户端显示/隐藏窗口：

登录成功时 Gate 直接隐藏 `cw_login` 并显示 `cw_selectchar`。服务端根目录的 `GameAgree.TXT` 由 Game Server 的 `TSystemAlert` 加载，在进入游戏后的系统窗口中处理，不属于 Gate 登录状态机。

```delphi
procedure TConnector.ShowWindow(aKey: TClientWindow; boShow: Boolean);
begin
  if boShow then FClientWindow := aKey;
  sWindow.rmsg := SM_WINDOW;
  sWindow.rwindow := Byte(aKey);
  sWindow.rboShow := boShow;
  AddSendData(@sWindow, sizeof(sWindow));
end;
```

### 4.3 消息路由机制

Gate 是所有客户端消息的枢纽，根据当前状态路由到不同后端服务：

**客户端 → Gate 的消息处理**（`uConnector.pas — Update`）：

```
if FGameStatus = gs_playing then
  → 转发到 Game（GM_SENDGAMEDATA）
else
  → 本地 MessageProcess 处理登录/选角等流程
```

**各后端 → Gate → 客户端的消息处理**：

| 来源 | 处理函数 | 关键消息 |
|------|----------|----------|
| Game | `GameMessageProcess` | `GM_CONNECT`（进入游戏）、`GM_DISCONNECT`（断开）、`GM_SENDGAMEDATA`（游戏数据转发）、`GM_DUPLICATE`（顶号）、`GM_SENDALL`（全服广播）、`GM_SENDUSERDATA`（角色数据写入 DB） |
| DB | `DBMessageProcess` | `DB_INSERT`（创建角色结果）、`DB_SELECT`（角色数据查询结果） |
| Login | `LoginMessageProcess` | `LG_INSERT`（注册结果）、`LG_SELECT`（登录验证结果）、`LG_UPDATE`（账号信息更新） |
| Paid | `PaidMessageProcess` | `PM_CHECKPAID`（计费验证结果） |

### 4.4 超时和断开机制

**请求超时（60 秒）**：非游戏状态下，如果 60 秒内未完成操作，重置状态并提示超时：

```delphi
// gate_biscuit/uConnector.pas — Update
if (FGameStatus <> gs_none) and (FGameStatus <> gs_playing) then begin
  if RequestTime + 60000 <= CurTick then begin
    RequestTime := 0;
    FGameStatus := gs_none;
    // 根据当前窗口发送超时提示
    SendStatusMessage(MESSAGE_LOGIN, '[TIMEOUT] 다시 시도해 주세요');
  end;
end;
```

**总连接超时（5 分钟）**：非游戏状态下，连接建立后 5 分钟内未完成登录则强制断开：

```delphi
if FGameStatus <> gs_playing then begin
  if (CreateTime > 0) and (CurTick >= CreateTime + 1000 * 60 * 5) then begin
    CreateTime := 0;
    Socket.Close;
  end;
end;
```

### 4.5 包频率限制

Gate 使用环形缓冲区记录每个连接的包频率（`PacketCountBufferSize = 8` 个采样点）：

```delphi
// gate_biscuit/uConnector.pas
CheckTime := CurTick - PacketCount[PCIndex].Tick;
PacketCount[PCIndex].Count := PacketReceiver.Count;
PacketCount[PCIndex].Tick := CurTick;
PCIndex := (PCIndex + 1) mod PacketCountBufferSize;

if CheckTime >= 1000 then begin
  nPacketCount := (GetPacketCountOnCycle * 1000) div CheckTime;
  if nPacketCount > LimitPacketCount then begin  // 默认 10 包/秒
    Socket.Close;  // 超限直接断开
  end;
end;
```

`LimitPacketCount` 在 `GATE.INI` 中配置，默认值为 10。

---

## 5. 完整登录流程

### 5.1 流程步骤

```
步骤  方向                     消息/动作                              状态变化
────────────────────────────────────────────────────────────────────────────────
 1   Client → Balance         TCP 连接 (3053)                       —
 2   Balance → Client         SM_CONNECTTHRU (最少连接 Gate 的 IP:Port)  —
 3   Client → Gate            TCP 连接 (3054)                       gs_none
 4   Gate → Client            SM_WINDOW(cw_login, true)             cw_login
 5   Client → Gate            发送 LoginID + LoginPW                gs_login
 6   Gate → Login             LG_SELECT (ConnectID, LoginID)        —
 7   Login → Gate             LG_SELECT 结果 (TLGRecord 含角色列表)  —
 8   Gate                     比对 PrimaryKey 和 PassWord           —
 9   Gate → Login             LG_UPDATE (IP、LastDate 等账号信息)    —
10   Gate → Client            隐藏 cw_login，显示 cw_selectchar      gs_none
11   Gate → Client            SM_CHARINFO (角色列表)                 —
12   Gate → Paid              PM_CHECKPAID（启用计费校验时）          —
13   Paid → Gate              返回付费类型和有效期                   gs_none
14   Client → Gate            选择角色名 + 服务器                    gs_selectchar
15   Gate → DB                DB_SELECT (角色名)                    —
16   DB → Gate                DB_SELECT 结果 (TDBRecord)            —
17   Gate → Game              GM_CONNECT (ConnectID, TDBRecord)     gs_gotogame
18   Game → Gate              GM_CONNECT (确认)                     gs_playing
19   Gate → Client            隐藏 cw_selectchar，显示 cw_main       cw_main
20   Gate → DB                DB_LOCK (角色名)                      —
21   Game → Gate              游戏数据流                            GM_SENDGAMEDATA 转发
```

### 5.2 涉及的服务和消息类型

| 阶段 | 参与服务 | 消息 |
|------|----------|------|
| 负载均衡 | Balance ↔ Client | `SM_CONNECTTHRU` |
| 账号验证 | Gate ↔ Login | `LG_SELECT` |
| 角色列表 | Gate ↔ DB | `DB_SELECT` |
| 计费验证 | Gate ↔ Paid | `PM_CHECKPAID` / `PM_CHECKPAID2` |
| 进入游戏 | Gate ↔ Game | `GM_CONNECT` |
| 角色锁定 | Gate → DB | `DB_LOCK` |

### 5.3 角色锁定机制（DB_LOCK）

当角色成功进入游戏后（步骤 22），Gate 向 DB 发送 `DB_LOCK`：

```delphi
// gate_biscuit/uConnector.pas — GameMessageProcess
GM_CONNECT:
begin
  FGameStatus := gs_playing;
  ShowWindow(cw_selectchar, FALSE);
  ShowWindow(cw_main, TRUE);
  StrPCopy(@buffer, PlayChar);
  DBSender.PutPacket(ConnectID, DB_LOCK, 0, @buffer, SizeOf(buffer));
end;
```

`DB_LOCK` 在 DB 服务器中标记角色为已锁定状态，防止同一角色被多次登录。角色下线时通过 `DB_UNLOCK` 释放锁。

### 5.4 顶号机制（GM_DUPLICATE）

当同一角色重复登录时，Game 服务器执行顶号逻辑：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList.CreateConnect
Connector := NameKey.Select(StrPas(@pcd^.PrimaryKey));
if Connector <> nil then begin
  // 断开旧连接
  GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID,
    GM_DISCONNECT, nil, 0);
  // 通知新连接顶号
  GateConnectorList.AddSendServerData(GateNo, ConnectID,
    GM_DUPLICATE, nil, 0);
  // 清理旧连接数据
  UniqueKey.Delete(Connector.ConnectID);
  NameKey.Delete(Connector.CharName);
  DataList.Remove(Connector);
  Connector.Free;
  exit;
end;
```

Gate 收到 `GM_DUPLICATE` 后的处理：

```delphi
// gate_biscuit/uConnector.pas — GameMessageProcess
GM_DUPLICATE:
begin
  SendStatusMessage(MESSAGE_SELCHAR, '접속해제 되었습니다');
  PlayChar := ''; UseChar := ''; UseLand := '';
  FGameStatus := gs_none;
  CreateTime := timeGetTime - (1000 * 60 * 5);  // 立即触发超时断开
end;
```

另外，Game 还维护一个 `WaitPlayerList`（等待列表），角色断开后在 `WAITPLAYERTICK`（默认 100 秒，可在 `sv1000.Ini` 配置）内不允许同一角色重新登录，防止数据冲突。

---

## 6. 数据持久化流程

### 6.1 数据传递路径

角色数据从 Game 到 DB 的保存路径：

```
Game (TConnector)
  │  AddSaveData() → SaveBuffer (环形缓冲区, 4MB)
  │
  ▼  ConnectorList.Update() 每 10ms 处理
  │
Gate (TfrmGate)
  │  AddSendDBServerData(DB_UPDATE / DB_UPDATE_END)
  │
  ▼  通过 Gate ↔ DB 的 TCP 连接
  │
DB (TDBProvider)
  │  写入 FDB 文件
  ▼
```

### 6.2 环形缓冲区批量写入

Game 服务器使用 `TPacketBuffer` 作为保存队列（4MB 容量）：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList
SaveBuffer := TPacketBuffer.Create(1024 * 1024 * 4);  // 4MB 缓冲区
```

保存数据封装为 `TCheckCharData`（包含 `TDBRecord` + `rEnd` 标志位）：

- `rEnd = 0`：定期保存，发送 `DB_UPDATE`
- `rEnd = 1`：结束保存（下线），发送 `DB_UPDATE_END`

### 6.3 定期保存

每个在线角色每 10 分钟触发一次保存（`60 * 10 * 100` 个 10ms tick）：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnector.Update
if SaveTick + 60 * 10 * 100 < CurTick then begin
  Move(CharData, rCharData, SizeOf(TDBRecord));
  rCharData.rEnd := 1;
  ConnectorList.AddSaveData(@rCharData, SizeOf(TCheckCharData));
  SaveTick := CurTick;
end;
```

> 注意：源码中定期保存使用的 `rEnd := 1`（即 `DB_UPDATE_END`），这意味着每次定期保存都会触发 `WaitPlayerList.Release`。保存功能可通过 Gate 界面 `chkSaveUserData` 复选框开关。

### 6.4 下线保存

角色断开连接时（`TConnector.Destroy`），执行最终保存：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnector.Destroy
if CharName <> '' then begin
  if BattleConnectState = bcs_none then EndLayer;
  Move(CharData, rCharData, SizeOf(TDBRecord));
  rCharData.rEnd := 1;
  ConnectorList.AddSaveData(@rCharData, SizeOf(TCheckCharData));
  frmGate.AddSendDBServerData(DB_UNLOCK, @CharData, SizeOf(CharData.PrimaryKey));
end;
```

下线时同时发送 `DB_UNLOCK` 释放角色锁。

### 6.5 保存队列处理

`TConnectorList.Update()` 每 10ms 检查保存队列，逐条发送到 DB：

```delphi
// gameserver-tgs1000/uConnect.pas — TConnectorList.Update
if SaveBuffer.Count > 0 then begin
  if CurTick >= SaveTick + 10 then begin
    if SaveBuffer.View(@CharData) = true then begin
      case CharData.rEnd of
        0: frmGate.AddSendDBServerData(DB_UPDATE, @CharData.rCharData, SizeOf(TDBRecord));
        1: frmGate.AddSendDBServerData(DB_UPDATE_END, @CharData.rCharData, SizeOf(TDBRecord));
      end;
    end;
    SaveTick := CurTick;
  end;
end;
```

---

## 7. 服务间通信拓扑

### 7.1 TCP 连接关系图

```
┌─────────┐     TCP 3000      ┌─────────┐
│ Balance │◄──────────────────│  Gate   │  (Gate 管理连接)
└─────────┘                   └────┬────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
              TCP 3052       TCP 3050       TCP 3051
                    │              │              │
              ┌─────▼─────┐ ┌─────▼─────┐ ┌─────▼─────┐
              │   Game    │ │   Login   │ │    DB     │
              └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
                    │              │              │
              TCP 3040       TCP 1021       TCP 1024/1020
              (Battle)     (远程管理)     (远程同步)
                                   │
              TCP 5999             │
                    │              │
              ┌─────▼─────┐ ┌─────▼─────┐
              │   Paid    │ │  Notice   │
              └───────────┘ │  (3020)   │
                            └───────────┘
```

**连接方向说明**：

- Gate 作为**客户端**主动连接到 Game/Login/DB/Paid
- Balance 的 `sckGate`（TCP 3000）作为**服务端**接受 Gate 的管理连接
- Game 的 `GateConnectorList` 作为**服务端**接受 Gate 的连接
- DB 的 `sckAccept` 作为**服务端**接受 Gate 的连接

### 7.2 UDP 日志推送

Game 服务器通过 UDP 向外部日志服务推送数据，共 7 个日志通道：

| 日志类型 | 配置节 | 服务器配置端口 | 源码缺省端口 | 说明 |
|----------|--------|----------------|--------------|------|
| ITEM | `[UDP_ITEM]` | 6001 | 6001 | 物品变动日志 |
| MOUSEEVENT | `[UDP_MOUSEEVENT]` | 6010 | 6001 | 鼠标事件日志 |
| MONITER | `[UDP_MONITER]` | 6011 | 6000 | 系统监控 |
| CONNECT | `[UDP_CONNECT]` | 6022 | 6022 | 连接/断开日志 |
| PAY | `[UDP_PAY]` | 6000 | 6000 | 计费日志 |
| OBJECT | `[UDP_OBJECT]` | 3003 | 3003 | 对象操作日志 |
| RELATION | `[UDP_RELATION]` | 3005 | 3005 | 关系日志 |

“服务器配置端口”对应当前提供的 `sv1000.ini`；只有相应配置项缺失时，程序才使用 `SVMain.pas` 中的源码缺省值。各通道缺省 IP 均为 `127.0.0.1`。

### 7.3 自动重连机制

**Gate 的自动重连**：Gate 的 `timerDisplayTimer`（每秒执行）检查所有后端连接状态，断线后自动重连：

```delphi
// gate_biscuit/FMain.pas — timerDisplayTimer
if sckGameConnect.Active = false then begin
  shpGameConnected.Brush.Color := clRed;
  sckGameConnect.Socket.Close;
  sckGameConnect.Active := true;    // 自动重连
end;
// 对 DB、Login、Paid 连接同样处理
```

**DB 的远程连接重连**：DB 服务器的定时器周期性检查远程管理连接，断开后自动重连：

```delphi
// db/FMain.pas — Timer1Timer
if not RemoteConnector.Connected then begin
  RemoteConnector.Connect;
end;
if not ItemRemoteConnector.Connected then begin
  ItemRemoteConnector.Connect;
end;
```

**Login 的远程连接重连**：Login 同样在 `timerDisplayTimer` 中检查并自动重连远程管理连接。

---

## 附录：关键消息常量汇总

### 客户端 ↔ Gate 消息

| 常量 | 值 | 方向 | 说明 |
|------|-----|------|------|
| `SM_WINDOW` | 1 | S→C | 窗口显示/隐藏控制 |
| `SM_MESSAGE` | 2 | S→C | 状态消息提示 |
| `SM_CONNECTTHRU` | 253 | S→C | Balance 重定向到 Gate |
| `SM_CHARINFO` | 3 | S→C | 角色列表信息 |
| `SM_CLOSE` | 255 | S→C | 关闭连接（版本不匹配等） |

### Gate ↔ Game 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `GM_CONNECT` | 0 | 角色进入游戏 / 确认进入 |
| `GM_DISCONNECT` | 1 | 断开连接 |
| `GM_SENDUSERDATA` | 2 | 角色数据写入请求 |
| `GM_SENDGAMEDATA` | 3 | 游戏数据转发 |
| `GM_DUPLICATE` | 4 | 顶号通知 |
| `GM_SENDALL` | 5 | 全服广播 |
| `GM_UNIQUEVALUE` | 6 | 网关唯一标识请求 |

### Gate ↔ DB 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_INSERT` | 0 | 创建角色 |
| `DB_SELECT` | 1 | 查询角色数据 |
| `DB_UPDATE` | 3 | 更新角色数据 |
| `DB_LOCK` | 4 | 锁定角色 |
| `DB_UNLOCK` | 5 | 解锁角色 |
| `DB_UPDATE_END` | 9 | 更新角色数据（结束标记，释放 WaitPlayer） |

### Gate ↔ Login 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `LG_INSERT` | 0 | 创建账号 |
| `LG_SELECT` | 1 | 登录验证 |
| `LG_DELETE` | 2 | 删除账号 |
| `LG_UPDATE` | 3 | 更新账号信息 |

### Balance 消息

| 常量 | 值 | 说明 |
|------|-----|------|
| `BM_GATEINFO` | 0 | Gate 心跳/注册信息 |

### DB 返回码

| 常量 | 值 | 说明 |
|------|-----|------|
| `DB_OK` | 0 | 操作成功 |
| `DB_ERR` | 1 | 通用错误 |
| `DB_ERR_NOTFOUND` | 2 | 未找到记录 |
| `DB_ERR_DUPLICATE` | 3 | 重复记录 |
| `DB_ERR_IO` | 4 | I/O 错误 |
| `DB_ERR_INVALIDDATA` | 5 | 无效数据 |
| `DB_ERR_NOTENOUGHSPACE` | 6 | 空间不足 |

### 客户端版本

```delphi
PROGRAM_VERSION = 40;  // 当前客户端版本（Legacy 版本 39 被拒绝）
```
