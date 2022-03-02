当游戏单元被攻击时激活，返回值为攻击者。

```pascal
function OnDanger (aStr : String) : String;
var
   Str, Name : String;
begin
   

end;

```

## 示例

```pascal
function OnDanger (aStr : String) : String;
begin
   if aStr = '火箭' then begin
      Result := 'true';
      exit;
   end;

   Result := 'false';
end;
```