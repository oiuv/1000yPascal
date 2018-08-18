系统函数，根据指定分割符分割字符串并返回结果。

```pascal
bStr := GetToken(aStr, aToken, aSep);
```

以上示例中变量aStr（参数1）为要分割的字符串;变量aSep(参数3)为分割符，下划线“_”表示根据空格分割;变量aToken（参数2）为字符串aStr中分割符第一次出现位置左边的结果，返回值bStr为aStr分割后剩余部分的结果。
