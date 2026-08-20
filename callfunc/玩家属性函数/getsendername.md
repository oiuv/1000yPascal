# getsendername

## 功能

返回当前事件发送者 `FSender` 的对象名称。

## 语法

```pascal
Name := callfunc('getsendername');
```

无参数。`uScriptManager.pas` 调用：

```pascal
Result := TBasicObject(FSender).SGetName;
```

`TBasicObject.SGetName` 直接读取 `BasicData.Name` 并转换为 Pascal 字符串。当前 `TUser` 没有覆盖这个方法；正常玩家事件中，结果就是该玩家对象的角色名。

## 真实脚本用法

`bin/Script/婚礼司仪.txt` 先取得发送者名称，再拼接 `movespace` 命令：

```pascal
Name := callfunc('getsendername');
Str := 'movespace ' + Name;
```

函数入口没有额外的空值、权限、编码或空格处理逻辑；文档不对这些行为作源码之外的保证。
