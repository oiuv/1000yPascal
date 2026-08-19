# sendzoneeffectmsg

## 功能描述
触发指定名称的地区效果（ZoneEffect）对象执行动作。该命令仅对 DynamicObject（动态对象）有效，用于激活地图上预定义的地区效果。

## 语法格式
```pascal
print('sendzoneeffectmsg 地区效果名');
```

## 参数说明
| 参数 | 说明 |
|------|------|
| 地区效果名 | String - 地图上已配置的地区效果对象名称 |

## 说明
该命令在地区效果列表中按名称查找匹配的 ZoneEffect 对象，找到后调用其 `SendFMMessage` 方法触发效果。

**重要限制**：该命令仅对 DynamicObject（动态对象）类型的脚本有效。基类 `TBasicObject` 中的实现为空操作，只有 `TDynamicObject` 重写了此方法。

**源码实现（uScriptManager.pas）：**
```pascal
end else if cmd = 'sendzoneeffectmsg' then begin
   TBasicObject (aSelf).SSendZoneEffectMessage (Params [0]);
end;
```

**基类实现（BasicObj.pas — 空操作）：**
```pascal
procedure TBasicObject.SSendZoneEffectMessage(aName: string);
begin
end;
```

**DynamicObject 重写（BasicObj.pas）：**
```pascal
procedure TDynamicObject.SSendZoneEffectMessage(aName: string);
begin
   ZoneEffectList.SendMsgZoneEffectObject(aName);
end;
```

**效果查找与触发（BasicObj.pas）：**
```pascal
function TZoneEffectList.SendMsgZoneEffectObject(aName: string): Boolean;
var
   i: integer;
   ZEObject: TZoneEffectObject;
begin
   Result := false;
   for i := 0 to DataList.Count - 1 do begin
      ZEObject := DataList.Items[i];
      if ZEObject.SelfData.Name = aName then begin
         ZEObject.SendFMMessage;
         Result := true;
      end;
   end;
end;
```

## 示例

### 电酒坛陷阱触发（电酒坛.txt）
```pascal
procedure OnHit (aStr : String);
begin
   print ('sendzoneeffectmsg 陷阱区1');
   print ('sendzoneeffectmsg 陷阱区2');
   print ('sendzoneeffectmsg 陷阱区3');
   print ('sendzoneeffectmsg 陷阱区4');
   print ('showeffect 22 1');
   exit;
end;
```

## 注意事项

1. **仅限 DynamicObject**：该命令只在动态对象（DynamicObject）的脚本中有效，在 NPC 或 Monster 脚本中调用不会产生任何效果
2. **名称必须匹配**：地区效果名必须与地图上预配置的 ZoneEffect 对象名称完全一致
3. **可触发多个效果**：可以连续调用多次来同时触发多个不同的地区效果
4. **地区效果对象**：地区效果是地图上预定义的特殊区域，通常用于陷阱、机关等场景交互
5. **与 showeffect 配合**：通常与 `showeffect` 命令配合使用，先触发地区效果再显示视觉特效

## 相关命令
- `showeffect` — 显示特效
- `sendsound` — 播放音效
- `changestate` — 改变对象状态
- `changedynobjstate` — 改变动态对象状态
