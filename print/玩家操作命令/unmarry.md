# unmarry

## 功能与语法

为当前事件发送者启动离婚处理。

```pascal
print('unmarry 提示文本');
```

参数只在配偶在线时传给对方的确认窗口。分派器直接把 `aSender` 转为 `TUser`，因此只能在存在玩家发送者的事件中调用。

## 当前分支

- 玩家 `Lover` 为空：不执行任何操作，也不会弹窗或收费。
- 配偶在线：向申请者发送“正在转达”提示，再对配偶调用 `ShowUnMarry(提示文本)`。
- 配偶离线：先尝试扣除 200,000 个 `钱币`；不足时退出，成功后调用 `MarryList.UnMarry(玩家名)` 提交离婚状态。

源码没有“无配偶时缴费”的路径，也没有这里曾写过的“20 天”常量。当前 `TMarryClass` 的日期算法按代码会把完成时间拖到约 14 天，且正常退出保存时还会错误写回日期；运维风险见 [Event 运行数据](../../help/Event.md)。

炎黄 `婚礼司仪.txt` 的入口为：

```pascal
if aStr = 'unmarry' then begin
   print('unmarry 您的配偶希望跟您解除婚约');
   exit;
end;
```

源码依据：`uScriptManager.pas` 的 `unmarry` 分派、`UUser.pas` 的 `UnMarryWindow` 和 `svClass.pas` 的 `TMarryClass`。
