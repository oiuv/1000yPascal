# 脚本过程事件索引

本目录收录当前 Pascal 源码注册的 27 个无返回值脚本事件。具体的 `Self`、`Sender`、参数和触发条件以各页面列出的调用点为准。

- 生命周期：[OnCreate](OnCreate.md)、[OnDestroy](OnDestroy.md)、[OnShow](OnShow.md)、[OnHide](OnHide.md)、[OnRegen](OnRegen.md)
- 玩家会话：[OnUserStart](OnUserStart.md)、[OnUserEnd](OnUserEnd.md)
- 定时与状态：[OnTimer](OnTimer.md)、[OnEventTimer](OnEventTimer.md)、[OnChangeState](OnChangeState.md)、[OnGetChangeStep](OnGetChangeStep.md)、[OnGetResult](OnGetResult.md)
- 交互：[OnDblClick](OnDblClick.md)、[OnLeftClick](OnLeftClick.md)、[OnRightClick](OnRightClick.md)、[OnHear](OnHear.md)、[OnApproach](OnApproach.md)、[OnArrival](OnArrival.md)、[OnAway](OnAway.md)
- 战斗：[OnBow](OnBow.md)、[OnHit](OnHit.md)、[OnStructed](OnStructed.md)、[OnDieBefore](OnDieBefore.md)、[OnDie](OnDie.md)、[OnDropItem](OnDropItem.md)
- 开关：[OnTurnOn](OnTurnOn.md)、[OnTurnOff](OnTurnOff.md)

具有返回值的 [OnMove](../function/OnMove.md) 和 [OnDanger](../function/OnDanger.md) 位于 `function/`。
