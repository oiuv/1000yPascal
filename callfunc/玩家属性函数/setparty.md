# setparty

## 功能

把当前事件发送者 `FSender` 对应婚姻记录的 `Party` 标志设为 `True`。

## 语法

```pascal
Str := callfunc('setparty');
```

无参数。`CallFunction` 调用 `TBasicObject(FSender).SSetParty`；实际玩家实现 `TUser.SSetParty` 先固定返回字符串 `true`，再调用 `MarryList.SetParty(Name)`。

`TMarryClass.SetParty` 遍历婚姻记录，玩家名等于记录中的 `Girl` 或 `Boy` 时设置标志并停止。没有匹配记录时不会修改任何数据，但返回值仍是 `true`，因此不能用返回值判断是否找到婚姻记录。

## 真实脚本用法

`bin/Script/婚礼司仪.txt` 在婚礼流程中直接调用：

```pascal
Name := callfunc('setparty');
```

变量会得到 `true`；脚本随后重新调用 `getsendername` 覆盖该变量。

## 相关函数

- `getparty`：返回当前玩家婚姻记录的 `Party` 标志。
