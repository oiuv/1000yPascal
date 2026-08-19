# OnDropItem

## 声明

```pascal
procedure OnDropItem (aStr : String);
```

## 参数

| 参数 | 类型 | 说明 |
|------|------|------|
| aStr | String | 对象自身的名称 |

## 触发条件

动态对象收到 `FM_ADDITEM` 消息时触发，即玩家向该对象投放物品时激活。对象需要具有 `DYNOBJ_EVENT_ADDITEM` 事件标记。

源码位置：`BasicObj.pas` 第 6547-6550 行

## 适用对象

- DynamicObject（动态对象）— 需设置 `DYNOBJ_EVENT_ADDITEM` 标记

## 示例

### 示例 1：任务物品交换（东海沼泽抽屉.txt）

玩家投入指定物品后，检查背包空间、扣除物品、发放任务奖励：

```pascal
procedure OnDropItem (aStr : String);
var
   Str : String;
   Name : String;
begin
   Str := callfunc ('checkenoughspace');
   if Str = 'false' then begin
      print ('say 物品栏已满');
      exit;
   end;

   print ('getsenderitem 书函:1');
   Str := callfunc ('getsenderitemexistence 侠客指环:1');
   if Str = 'false' then begin
      print ('putsendermagicitem 侠客指环:1 @东海沼泽抽屉 5');
   end;

   print ('changesendercurrentquest 1250');
   print ('changesendercompletequest 1200');

   Str := callfunc ('getsenderqueststr');
   if Str = '1' then begin
      Name := callfunc ('getsendername');
      Str := 'questcomplete ' + Name;
      Str := Str + ' 西域魔人阴谋';
      print (Str);
      print ('changesenderqueststr 2');
      exit;
   end;

   print ('sendsenderchatmessage 完成了西域魔人任务 2');
   exit;
end;
```

### 示例 2：简单状态切换（雪上天蚕.txt）

玩家投放物品后，直接切换动态对象状态：

```pascal
procedure OnDropItem (aStr : String);
var
   Str : String;
begin
   Str := 'selfchangedynobjstate TRUE';
   print (Str);
   exit;
end;
```

## 相关事件

- [OnHear](OnHear.md) — 语音触发事件
- [OnTurnOn](OnTurnOn.md) / [OnTurnOff](OnTurnOff.md) — 开关状态事件
- [OnDie](OnDie.md) — 对象销毁事件
