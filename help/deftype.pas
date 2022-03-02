unit deftype;

interface

uses
  Windows, SysUtils, Controls, Classes, AUtil32;

const
  deftype_MAX_PACK_SIZE = 65535; //基本 包 缓冲区 大小
  numsay_GuildHit = 0;
  numsay_NOHIT = 1;
  numsay_ExitGuild = 2;
  numsay_captivity = 3;
  numsay_captivityGET = 4;
  numsay_gameExit = 5;
  numsay_disposalOK = 6;
  numsay_class_recur = 7;
  numsay_examineGM_no = 8;
  numsay_9 = 9;
  numsay_10 = 10;
  numsay_11 = 11;
  numsay_12 = 12;
  numsay_13 = 13;
  numsay_14 = 14;
  numsay_15 = 15;
  numsay_16 = 16;
  numsay_17 = 17;
  numsay_18 = 18;
  numsay_19 = 19;
  numsay_20 = 20;
  numsay_21 = 21;
  numsay_22 = 22;
  numsay_23 = 23;
  numsay_24 = 24;
  numsay_25 = 25;
  //消息 对应 表
  cNumSayArr: array[0..25] of string = (
    '门派石被攻击', //0  numsay_GuildHit
    '没能攻击', //1  numsay_NOHIT
    '你已经脱离门派了。', //2  numsay_ExitGuild
    '被囚禁于流配地。', //3  numsay_captivity
    '可用 @囚禁情报 指令来查询囚禁时间。', //4 numsay_captivityGET
    '解除连线', //5  numsay_gameExit
    '处理完毕', //6  numsay_disposalOK
    '请稍后重来。', //7  numsay_class_recur
    '此人是云端千年GM，无法探查。', //8  numsay_examineGM_no
    '今天已做过删除武功的动作。' //9   numsay_9
    , '一天只可删除一次' //10   numsay_10
    , '失败了。' //11   numsay_11
    , '价格为零物品或您的权限受到限制而无法做出.' //12 numsay_12
    , '在流放地里无法传送信息' //13  numsay_13
    , '年龄在20岁以下的玩家无法传送纸条信息.' //   numsay_14
    , '%s拒绝你的纸条。' //15 numsay_15
    , '%s人以上拒绝你的纸条，所以无法再传纸条' //16   numsay_16
    , '%s目前不在线上。' //17  numsay_17
    , '%s传了一个纸条给你。' //18  numsay_18
    , '%s目前为拒绝纸条状态。' //19  numsay_19
    , '设定接收纸条' //20  numsay_20
    , '你已设定接收%s传来的纸条。' //21  numsay_21
    , '对方不在线上。' //22  numsay_22
    , '设定拒绝纸条。' //23  numsay_23
    , '你已加入 %s,无法成立门派。' //24  numsay_24
    , '成功给%s 发送了一个纸条。' //25 numsay_25
    );

  // Packet Message Define
  PACKET_NONE = 0;
  PACKET_GAME = 1;
  PACKET_CLIENT = 2;
  PACKET_GATE = 3;
  PACKET_DB = 4;
  PACKET_LOGIN = 5;
  PACKET_PAID = 6;
  PACKET_NOTICE = 7;

  GM_SM_NONE = 0;
  GM_SM_ADD = 1; // 荤侩磊 眠啊
  GM_SM_DELETE = 2; // 拌沥 措扁角 磊丰 昏力 倾侩
  GM_SM_REQUESTCLOSE = 3; // 荤侩吝牢巴 秦力
  //   GM_SM_ADDGUILDNAME = 4;
  GM_SM_ALLOWGUILDNAME = 5;

  GM_CHECK = 10;
  GM_CHECK_OK = 11;

  GM_CM_NONE = 0;
  GM_CM_SAVE = 1; // 霸烙惑怕                               :  沥惑
  GM_CM_SAVEANDCLOSE = 2; // 拌沥 措扁角俊辑 霸烙磊丰 历厘苞 秦力   :  沥惑
  GM_CM_CLOSE = 3; // 绝绰 荤侩磊 秦力 夸没矫 秦力倾啊       :  焊肯
  GM_CM_ADDGUILDNAME = 4;
  GM_CM_ALLOWGUILDNAME = 5;

  NATION_KOREA = 1;
  NATION_TAIWAN = 2;
  NATION_CHINA_1 = 3;

  NATION_VERSION = NATION_KOREA;
  PROGRAM_VERSION = 16;

  MONEYMAX = 61000;

  HAVEITEMSIZE = 30;
  HAVEMAGICSIZE = 30;

  VIEWRANGEWIDTH = 13; //10;
  VIEWRANGEHEIGHT = 11; //8;

  DEFAULTEXP = 10000; // 捞亥飘矫 掘绰 扁夯 版摹

  NAME_SIZE = 19; // 茄臂 9 臂磊

  NOTARGETPHONE = 0;
  MANAGERPHONE = 1;

  STARTNEWID = 10000;
  USERMANAGERPOST = 1000;
  FIELDPOST = 100;

  SAVE_USERDATA_DELAY_TIME = 5 * 60 * 100;

  SAY_COLOR_NORMAL = 0;
  SAY_COLOR_SHOUT = 1;
  SAY_COLOR_SYSTEM = 2;
  SAY_COLOR_NOTICE = 3;

  SAY_COLOR_GRADE0 = 10;
  SAY_COLOR_GRADE1 = 11;
  SAY_COLOR_GRADE2 = 12;
  SAY_COLOR_GRADE3 = 13;
  SAY_COLOR_GRADE4 = 14;
  SAY_COLOR_GRADE5 = 15;

  {
  SAY_COLOR_GRADE6     = 16;
  SAY_COLOR_GRADE7     = 17;
  SAY_COLOR_GRADE8     = 18;
  SAY_COLOR_GRADE9     = 19;
  }
  SAY_COLOR_GRADE6lcred = 20;



  WEAR_SPECIAL_KIND_NONE = 0;
  WEAR_SPECIAL_KIND_DROP = 1; //掉
  WEAR_SPECIAL_KIND_JOB = 2; //生产
  WEAR_SPECIAL_KIND_PRESTIGE = 3; //荣誉
  WEAR_SPECIAL_KIND_MIX = 4; //合成
  WEAR_SPECIAL_KIND_MAGIC = 5; //修炼武功
  WEAR_SPECIAL_KIND_QUEST = 6; //任务
  WEAR_SPECIAL_KIND_LEVEL = 7; //等级物品
  WEAR_SPECIAL_KIND_Scripter = 8; //脚本

  HANGON_NONE = 0;

  ITEM_KIND_NONE = 0;
  ITEM_KIND_COLORDRUG = 1;
  ITEM_KIND_BOOK = 2;
  ITEM_KIND_GOLD = 3; //钱币

  ITEM_KIND_WEARITEM = 6; //是常用装备 可以升级的4段装备的
  ITEM_KIND_ARROW = 7; //箭
  ITEM_KIND_FLYSWORD = 8; //飞刀
  ITEM_KIND_GUILDSTONE = 9;
  ITEM_KIND_DUMMY = 10; //门派 FM_ADDITEM 消息 在使用
  ITEM_KIND_STATICITEM = 11; //静态物品
  ITEM_KIND_DRUG = 13;
  ITEM_KIND_TICKET = 18;
  ITEM_KIND_HIDESKILL = 19;
  ITEM_KIND_CANTMOVE = 20;
  ITEM_KIND_ITEMLOG = 21;
  ITEM_KIND_CHANGER = 22;
  ITEM_KIND_SHOWSKILL = 23;
  //    ITEM_KIND_WEARITEM2 = 24;                                                   //是装备    可以升级3段 不能升级4段的
  ITEM_KIND_WEARITEM_27 = 27; //挖矿工具
  //    ITEM_KIND_WEARITEM_29 = 29;                                                 //是装备  我没搞懂为什么用29  因为 6和29没区别
  ITEM_KIND_35 = 35; //水桶
  ITEM_KIND_Scripter = 56; //脚本物品

  ITEM_KIND_36 = 36; //加活力的戒指（提高角色的部分能力值）
  ITEM_KIND_59 = 59; //提高角色的部分能力值

  ITEM_KIND_41 = 41; //定时间 恢复血等属性
  ITEM_KIND_44 = 44; //[任务 物品] 拿20个疾风灵符给雨中客
  ITEM_KIND_45 = 45; //[任务 物品] 拿20个黑马武士给老侠客
  ITEM_KIND_51 = 51; //开宝箱时要用

  ITEM_KIND_WEARITEM_GUILD = 60; //砸门锤 是装备武器  是有持久限制的武器
  ITEM_KIND_ScripterSay = 61; //脚本物品

  ITEM_KIND_WEARITEM_FD = 100; //时装
  ITEM_KIND_GuildAddLife = 120; //门派加血石头
  //ITEM_KIND_121 = 121;//宝石 镶嵌  rSpecialKind 表示等级
  //ITEM_KIND_130 = 130;//精炼 石头
  ITEM_KIND_LifeData_item = 131; //可以吃的附加属性 物品  rSpecialKind 重叠标志
  //ITEM_KIND_132 = 132;//精炼 辅助石 rSpecialKind 类型
  ITEM_KIND_QUEST = 133; //任务 物品20091019
  ITEM_KIND_GOLD_D = 134; //代钱物体

  ITEM_Attribute_1 = 1; //烈火
  ITEM_Attribute_2 = 2;
  ITEM_Attribute_3 = 3;
  ITEM_Attribute_4 = 4;
  ITEM_Attribute_5 = 5;
  ITEM_Attribute_6HaveItem = 6; //直接进背包
  ITEM_Attribute_7 = 7;
  ITEM_Attribute_8 = 8;

  GATE_KIND_NORMAL = 0;
  GATE_KIND_BS = 1;

  DYNOBJ_EVENT_NONE = 0;
  DYNOBJ_EVENT_HIT = 1;
  DYNOBJ_EVENT_ADDITEM = 2;
  DYNOBJ_EVENT_SAY = 4;
  DYNOBJ_EVENT_BOW = 8; //目前 就知道8号 是可以射的

  // 0 酒公 捞亥飘档 惯积窍瘤 臼澜
  // 1 锭府搁 捞亥飘 惯积
  // 2 酒捞袍阑 笼绢持栏搁 捞亥飘 惯积
  // 4 富阑 吧搁 捞亥飘 惯积
  // 3 锭府绊 酒捞袍 笼绢持绊
  // 5 锭府绊 富窍绊
  // 6 酒捞袍 笼绢初绊 富窍绊
  // 7 锭府绊 酒捞袍 笼绢持绊 富窍绊

  DEFAULT_WRESTLING = 0; // 困摹俊 包茄
  DEFAULT_FENCING = 1;
  DEFAULT_SWORDSHIP = 2;
  DEFAULT_HAMMERING = 3;
  DEFAULT_SPEARING = 4;
  DEFAULT_BOWING = 5;
  DEFAULT_THROWING = 6;
  DEFAULT_RUNNING = 7;
  DEFAULT_BREATHNG = 8;
  DEFAULT_PROTECTING = 9;

  DEFAULT2_WRESTLING = 10; // 困摹俊 包茄
  DEFAULT2_FENCING = 11;
  DEFAULT2_SWORDSHIP = 12;
  DEFAULT2_HAMMERING = 13;
  DEFAULT2_SPEARING = 14;
  DEFAULT2_BOWING = 15;
  DEFAULT2_THROWING = 16;
  DEFAULT2_RUNNING = 17;
  DEFAULT2_BREATHNG = 18;
  DEFAULT2_PROTECTING = 19;
  //0=拳 1=剑 2=刀 3=槌 4=枪 5=弓 6=投 7=步法 8=心法 9=护体 10=辅助武功

  MAGICTYPE_WRESTLING = 0; // 拳
  MAGICTYPE_FENCING = 1; //剑
  MAGICTYPE_SWORDSHIP = 2; //刀
  MAGICTYPE_HAMMERING = 3; //槌
  MAGICTYPE_SPEARING = 4; //枪

  MAGICTYPE_BOWING = 5; //弓
  MAGICTYPE_THROWING = 6; //投

  MAGICTYPE_RUNNING = 7; //步法
  MAGICTYPE_BREATHNG = 8; //心法
  MAGICTYPE_PROTECTING = 9; //护体

  MAGICTYPE_ECT = 10; // 辅助武功

  MAGICTYPE_ONLYBOWING = 11;
  MAGICTYPE_SPECIAL = 12;

  MAGICTYPE_2WRESTLING = 100; // 拳
  MAGICTYPE_2FENCING = 101; //剑
  MAGICTYPE_2SWORDSHIP = 102; //刀
  MAGICTYPE_2HAMMERING = 103; //槌
  MAGICTYPE_2SPEARING = 104; //枪
  MAGICTYPE_2BOWING = 105; //弓
  MAGICTYPE_2THROWING = 106; //投
  MAGICTYPE_2RUNNING = 107; //步法
  MAGICTYPE_2BREATHNG = 108; //心法
  MAGICTYPE_2PROTECTING = 109; //护体

  MAGICTYPE_3WRESTLING = 300; // 拳
  MAGICTYPE_3FENCING = 301; //剑
  MAGICTYPE_3SWORDSHIP = 302; //刀
  MAGICTYPE_3HAMMERING = 303; //槌
  MAGICTYPE_3SPEARING = 304; //枪
  MAGICTYPE_3BOWING = 305; //弓
  MAGICTYPE_3THROWING = 306; //投
  MAGICTYPE_3RUNNING = 307; //步法
  MAGICTYPE_3BREATHNG = 308; //心法
  MAGICTYPE_3PROTECTING = 309; //护体

  MAGIC_Mystery_TYPE = 213; //掌法

  MAGICSPECIAL_HIDE = 0;
  MAGICSPECIAL_SAME = 1; //分身术
  MAGICSPECIAL_HEAL = 2; //再生术
  MAGICSPECIAL_SWAP = 3;
  MAGICSPECIAL_EAT = 4;
  MAGICSPECIAL_KILL = 5;
  MAGICSPECIAL_PICK = 6;

  MAGICSPECIAL_7absorb = 7; //吸血
  MAGICSPECIAL_8CALL = 8; //召唤
  MAGICSPECIAL_9MAGICFUNC = 9; //必杀
  MAGICSPECIAL_10SHOWSKILL = 10; //透视

  MAGICSPECIAL_LAST = 11;

  MAGICFUNC_NONE = 0;
  MAGICFUNC_REFILL = 1;
  MAGICFUNC_8HIT = 2;
  MAGICFUNC_5HIT = 3;
  MAGICFUNC_Screen_HIT = 4; //20091020 增加 屏幕 攻击

  SELECTMAGIC_RESULT_FALSE = -1;
  SELECTMAGIC_RESULT_NONE = 0;
  SELECTMAGIC_RESULT_NORMAL = 1;
  SELECTMAGIC_RESULT_SITDOWN = 2;
  SELECTMAGIC_RESULT_RUNNING = 3;

  RACE_NONE = 0;
  RACE_HUMAN = 1; //人(类)
  RACE_ITEM = 2; //物品
  RACE_MONSTER = 3; //怪物
  RACE_NPC = 4; //NPC
  RACE_DYNAMICOBJECT = 5; //动态 对象
  RACE_STATICITEM = 6; //静态 物品
  RACE_VirtualObject = 7;
  RACE_MineObject = 8;
  RACE_GroupMoveObject = 9;

  CLASS_NONE = 0;
  CLASS_HUMAN = 1;
  CLASS_MONSTER = 2;
  CLASS_NPC = 3;
  CLASS_ITEM = 4; //物品 对象
  CLASS_DYNOBJECT = 5;
  CLASS_GUILDSTONE = 6;
  CLASS_GUILDNPC = 7;
  CLASS_GATE = 8;
  CLASS_STATICITEM = 9;
  CLASS_DOOR = 10;
  CLASS_SERVEROBJ = 11;
  CLASS_VirtualObject = 12;
  CLASS_MineObject = 13;
  CLASS_GroupMoveObject = 14;

  CREATE_NONE = 0;
  CREATE_ITEM = 1;
  CREATE_MONSTER = 2;

  INTRESULT_FALSE = -1;
  INTRESULT_ARREADY = -2;

  PROC_TRUE = 0;
  PROC_FALSE = -1;
  PROC_ARREAY = -2;

  UPDATE_TRUE = 0;
  UPDATE_FALSE = -1;

  RET_CLOSE_NONE = 0;
  RET_CLOSE_RUNNING = 1;
  RET_CLOSE_BREATHNG = 2;
  RET_CLOSE_ATTACK = 3;
  RET_CLOSE_PROTECTING = 4;

  DELAYEFFECT_NONE = 0;

  AM_NONE = 0;
  AM_DIE = 1;
  AM_STRUCTED = 2;
  AM_SEATDOWN = 3;
  AM_STANDUP = 4;
  AM_HELLO = 5;
  AM_MOTION = 6;

  AM_TURN = 10;
  AM_TURN1 = 11;
  AM_TURN2 = 12;
  AM_TURN3 = 13;
  AM_TURN4 = 14;
  AM_TURN5 = 15;
  AM_TURN6 = 16;
  AM_TURN7 = 17;
  AM_TURN8 = 18;
  AM_TURN9 = 19;

  AM_MOVE = 20;
  AM_MOVE1 = 21;
  AM_MOVE2 = 22;
  AM_MOVE3 = 23;
  AM_MOVE4 = 24;
  AM_MOVE5 = 25;
  AM_MOVE6 = 26;
  AM_MOVE7 = 27;
  AM_MOVE8 = 28;
  AM_MOVE9 = 29;

  AM_HIT = 30; //拳
  AM_HIT1 = 31; //拳2 提腿
  AM_HIT2 = 32; //刀1 剑1 投1
  AM_HIT3 = 33; //斧1枪1
  AM_HIT4 = 34; //弓箭
  AM_HIT5 = 35;
  AM_HIT6 = 36;
  AM_HIT7 = 37; //刀2
  AM_HIT8 = 38; //剑2
  AM_HIT9 = 39;

  AM_TURNNING = 40;
  AM_TURNNING1 = 41;
  AM_TURNNING2 = 42;
  AM_TURNNING3 = 43;
  AM_TURNNING4 = 44;
  AM_TURNNING5 = 45;
  AM_TURNNING6 = 46;
  AM_TURNNING7 = 47;
  AM_TURNNING8 = 48;
  AM_TURNNING9 = 49;

  {  // 眠啊且巴
     AM_TURN     =  10;
     AM_TURN1    =  11;
     AM_TURN2    =  12;
     AM_TURN3    =  13;
     AM_TURN4    =  14;
     AM_TURN5    =  15;
     AM_TURN6    =  16;
     AM_TURN7    =  17;
     AM_TURN8    =  18;
     AM_TURN9    =  19;
     AM_TURN10   =  20;
     AM_TURN11   =  21;
     AM_TURN12   =  22;
     AM_TURN13   =  23;
     AM_TURN14   =  24;
     AM_TURN15   =  25;
     AM_TURN16   =  26;
     AM_TURN17   =  27;
     AM_TURN18   =  28;
     AM_TURN19   =  29;

     AM_MOVE     =  30;
     AM_MOVE1    =  31;
     AM_MOVE2    =  32;
     AM_MOVE3    =  33;
     AM_MOVE4    =  34;
     AM_MOVE5    =  35;
     AM_MOVE6    =  36;
     AM_MOVE7    =  37;
     AM_MOVE8    =  38;
     AM_MOVE9    =  39;
     AM_MOVE10   =  40;
     AM_MOVE11   =  41;
     AM_MOVE12   =  42;
     AM_MOVE13   =  43;
     AM_MOVE14   =  44;
     AM_MOVE15   =  45;
     AM_MOVE16   =  46;
     AM_MOVE17   =  47;
     AM_MOVE18   =  48;
     AM_MOVE19   =  49;

     AM_HIT      =  50;
     AM_HIT1     =  51;
     AM_HIT2     =  52;
     AM_HIT3     =  53;
     AM_HIT4     =  54;
     AM_HIT5     =  55;
     AM_HIT6     =  56;
     AM_HIT7     =  57;
     AM_HIT8     =  58;
     AM_HIT9     =  59;
     AM_HIT10    =  60;
     AM_HIT11    =  61;
     AM_HIT12    =  62;
     AM_HIT13    =  63;
     AM_HIT14    =  64;
     AM_HIT15    =  65;
     AM_HIT16    =  66;
     AM_HIT17    =  67;
     AM_HIT18    =  68;
     AM_HIT19    =  69;

     AM_TURNNING   =  70;
     AM_TURNNING1  =  71;
     AM_TURNNING2  =  72;
     AM_TURNNING3  =  73;
     AM_TURNNING4  =  74;
     AM_TURNNING5  =  75;
     AM_TURNNING6  =  76;
     AM_TURNNING7  =  77;
     AM_TURNNING8  =  78;
     AM_TURNNING9  =  79;
     AM_TURNNING10 =  70;
     AM_TURNNING11 =  71;
     AM_TURNNING12 =  72;
     AM_TURNNING13 =  73;
     AM_TURNNING14 =  74;
     AM_TURNNING15 =  75;
     AM_TURNNING16 =  76;
     AM_TURNNING17 =  77;
     AM_TURNNING18 =  78;
     AM_TURNNING19 =  79;
  }

  ARR_BODY = 0;
  ARR_GLOVES = 1; //* 手腕
  ARR_UPUNDERWEAR = 2; //* 内衣
  ARR_SHOES = 3; //* 鞋子
  ARR_DOWNUNDERWEAR = 4; //* 裤子
  //5 空缺
  ARR_UPOVERWEAR = 6; //* 衣服
  ARR_HAIR = 7; //* 头发
  ARR_CAP = 8; //* 帽子
  ARR_WEAPON = 9; //* 武器
  ARR_10_Special = 10;
  ARR_11_Special = 11;
  ARR_12_Special = 12;
  ARR_13_Special = 13;

  ARR_MAX = 13;

  DR_0 = 0;
  DR_1 = 1;
  DR_2 = 2;
  DR_3 = 3;
  DR_4 = 4;
  DR_5 = 5;
  DR_6 = 6;
  DR_7 = 7;
  DR_DONTMOVE = 8;

  FM_STRING = 253;
  FM_REBOOT = 254;
  FM_NONE = 0;
  FM_CREATE = 1;
  FM_DESTROY = 2;
  FM_SHOW = 3;
  FM_HIDE = 4;
  FM_MOVE = 5;
  FM_HIT = 8;
  FM_SAY = 9;
  FM_PICKUP = 11;
  FM_TURN = 12;
  FM_STRUCTED = 15;
  FM_CHANGEFEATURE = 16;
  FM_GIVEMEADDR = 20;
  FM_ADDATTACKEXP = 23;
  FM_ADDITEM = 27;

  FM_ADDMONEY = 29;
  FM_DELMONEY = 30;
  FM_SOUNDBASE = 64;
  FM_GOTOXY = 73;

  FM_MOTION = 74;
  FM_DELITEM = 75;

  FM_GATHERVASSAL = 76;

  FM_SHOUT = 100;
  FM_WITHME = 101;
  //FM_ADDPROTECTEXP = 102;

  FM_SYSOPMESSAGE = 103;
  FM_BOW = 104;
  FM_CURRENTUSER = 105;

  FM_SOUND = 106;
  FM_CLICK = 107;

  FM_SAYUSEMAGIC = 108;
  FM_GUILDATTACK = 109;

  FM_GATE = 110;

  FM_ENOUGHSPACE = 111;

  FM_ALLOWGUILDNAME = 112;
  FM_ALLOWGUILDSYSOPNAME = 113;

  FM_CANCELEXCHANGE = 114;
  FM_SHOWEXCHANGE = 115;

  FM_REFILL = 116;

  FM_DBLCLICK = 117;
  FM_CHANGEPROPERTY = 118;
  FM_REMOVEGUILDMEMBER = 119;
  FM_CHECKGUILDUSER = 120;
  FM_DEADHIT = 121;
  FM_HEAL = 122;
  FM_KILL = 123;
  FM_LIFEPERCENT = 124; //怪物和动态物体活力百分比
  FM_IAMHERE = 125;

  FM_NPC = 126;
  FM_MenuSAY = 127;

  FM_DELITEM_Copy = 128;
  FM_LeftText = 129;
  FM_CHANGEFEATURE_NameColor = 130;

  //  FM_CHANGEMagic  = 132;         //改变 武功
  FM_MagicEffect = 133; //
  FM_Effect = 134; //

  FM_UserWearItem = 134;
  FM_SETPOSITION = 135;
  FM_EXCHANGE_UPDATE = 136;
  FM_MOTION2 = 137;
  FM_ADDvirtueEXP = 138;
  FM_DELITEM_KEY = 139;
  FM_BOOTH = 140; //摊位 消息
  FM_drink = 141; //喝水
  FM_Dredge = 142;
  FM_ADDQUESTITEM = 143;
  FM_Drag = 144;

  PM_LETMEIN = 1;
  PM_LETMEOUT = 2;

  MM_SHOW = 1;
  MM_HIDE = 2;
  MM_MOVE = 3;

  MESSAGE_NONE = 0;
  MESSAGE_LOGIN = 1;
  MESSAGE_CREATELOGIN = 2;
  MESSAGE_SELCHAR = 3;
  MESSAGE_GAMEING = 4;
  MESSAGE_AGREE = 5;
  MESSAGE_FindPasswordResult = 6;

  udpReceiverc_MouseInfo = 1;
  udpReceiverc_Connect = 2;
  udpReceiverc_Moniter = 3;
  udpReceiverc_ItemMoveInfo = 4;
  udpReceiverc_Monster_die = 5;

  //  SM_SETCLIENTCONDITION = 2;

  SM_RECONNECT_Balance = 252;
  SM_CONNECTTHRU = 253;
  SM_RECONNECT = 254;
  SM_CLOSE = 255; // 滚傈 撇覆鞍澜

  SM_NONE = 0;
  SM_WINDOW = 1;
  SM_MESSAGE = 2;

  SM_CHARINFO = 3;
  SM_CHATMESSAGE = 4;

  SM_ATTRIBBASE = 5;
  SM_HAVEITEM = 6;
  SM_HAVEMAGIC = 7;
  SM_WEARITEM = 8;

  SM_NEWMAP = 9;
  SM_SHOW = 10;
  SM_HIDE = 11;
  SM_SAY = 12;
  SM_MOVE = 13;
  SM_TURN = 15;
  SM_SETPOSITION = 16;

  SM_CHANGEFEATURE = 18;
  SM_MAGIC = 19;
  SM_SOUNDBASE = 21;

  SM_MOTION = 22;

  SM_ATTRIB_VALUES = 23;
  SM_ATTRIB_FIGHTBASIC = 24;
  SM_ATTRIB_LIFE = 25;

  SM_EVENTSTRING = 26;
  SM_STRUCTED = 27;

  SM_SHOWITEM = 28;
  SM_SHOWMONSTER = 29;
  SM_HIDEITEM = 30;
  SM_HIDEMONSTER = 31;

  SM_USEDMAGICSTRING = 32;
  SM_MOVINGMAGIC = 33;

  SM_BASICMAGIC = 34;
  SM_SOUNDSTRING = 35;

  SM_SAYUSEMAGIC = 36;
  SM_BOSHIFTATTACK = 37;

  SM_RAINNING = 38;
  SM_SOUNDBASESTRING = 39;

  SM_SOUNDBASESTRING2 = 40; //废弃
  SM_SOUNDEFFECT = 41;

  SM_SHOWINPUTSTRING = 42;

  SM_HIDEEXCHANGE = 43;
  SM_SHOWEXCHANGE = 44;

  SM_SHOWCOUNT = 45;
  SM_CHANGEPROPERTY = 46;

  SM_SHOWDYNAMICOBJECT = 47;
  SM_HIDEDYNAMICOBJECT = 48;
  SM_CHANGESTATE = 49;

  SM_SHOWSPECIALWINDOW = 50;

  SM_LOGITEM = 51;
  SM_CHECK = 52;

  // for Battle Server
  SM_SHOWBATTLEBAR = 53; // 俺牢措傈矫狼 拳搁惑窜狼 劝仿官甫 钎矫
  SM_SHOWCENTERMSG = 54; // 吝居俊 荤阿屈阑 弊府绊 巩磊甫 免仿

  // saset
  SM_HIDESPECIALWINDOW = 55;
  // 拳搁俊 栋乐绰 SpecialWindow 甫 摧档废 努扼捞攫飘俊霸 夸没茄促
  SM_NETSTATE = 56;
  SM_NPCITEM = 57;
  SM_charattrib = 58; //发送 自己的属性

  SM_itempro = 60; //物品 详细 资料
  SM_keyf5f12 = 61; //热键
  SM_MapObject = 62;
  SM_ShowPassWINDOW = 63;
  SM_GameExit = 64;
  SM_CHANGEFEATURE_NameColor = 65;
  SM_ReliveTime = 66;
  //    SM_SHOWRollMSG  = 67;          // 滚动 广告
  SM_HailFellow = 68;
  SM_GUILD = 69; //门派
  SM_NumSay = 70;
  SM_MOVEOk = 71;
  SM_SelChar = 72;
  SM_SHOWINPUTSTRING2 = 73;
  SM_InputOk = 74; //输入 确认
  SM_EMAIL = 75; //邮件
  SM_Auction = 76; //拍卖

  SM_boMOVE = 77;
  SM_MagicEffect = 78;
  SM_CHANGEMagic = 79;
  SM_ItemTextAdd = 80;
  SM_Quest = 81; //任务
  SM_Procession = 82;
  SM_Billboardcharts = 83;
  SM_LockMoveTime = 84; //锁定 不能移动 一定时间
  SM_UPDATAITEM = 85; //升级 物品
  SM_ITEM_UPDATE = 86; //物品属性 发生变化
  SM_PowerLevel = 87; //境界等级
  SM_Emporia = 88;
  SM_money = 89;
  SM_Effect = 90;
  SM_LifeData = 91; //发送 自己的属性
  SM_ATTRIB_UPDATE = 92;
  SM_HAVEITEM_list = 93; //背包 物品 列表
  SM_MOTION2 = 94;
  SM_MSay = 95;
  SM_TM = 96;
  SM_LeftText = 97;
  SM_ItemInputWindows = 98;
  SM_MsgBoxTemp = 99; //临时 提示筐 可显示大量 文字
  SM_Village = 100;
  SM_Booth = 101;
  SM_Designation = 102;
  SM_HAVEITEM_LIST_QUEST = 103;
  SM_ShowVirtualObject = 104;
  SM_HIDEVirtualObject = 105;
  SM_Job = 106;
  SM_SHOW_Npc_MONSTER = 107;
  SM_CHANGE_Npc_MONSTER = 108;
  SM_die_Npc_MONSTER = 109;

  SM_CHARMOVEFRONTDIEFLAG = 255;
  // 烙矫荤侩 纳腐磐啊 磷篮荤恩困肺 瘤唱哎荐 乐绰 版快甫 TRUE肺 汲沥

  SHOWEXCHANGE_add = 1;

  Designation_menu = 10;
  Designation_user = 11;
  Designation_Del = 12;

  Booth_Send_BuyList = 102;
  Booth_Send_SellList = 103;

  ItemInputWindows_Open = 1;
  ItemInputWindows_Close = 2;
  ItemInputWindows_Clear = 3;
  ItemInputWindows_key = 4;

  TM_string = 1;
  TM_GETLOG = 2;
  TM_ITEM = 3;
  TM_ADDMONEY = 4;
  TM_GM = 5;
  TM_GETFile = 6;
  TM_ClearLOG = 7;

  ATTRIB_UPDATE_Adaptive = 1;

  ITEM_UPDATE_rlocktime = 1;
  ITEM_UPDATE_rlockState = 2;
  ITEM_UPDATE_rDurability = 3;
  ITEM_UPDATE_rtimemode_del = 4;
  ITEM_UPDATE_add = 6;
  ITEM_UPDATE_del = 7;
  ITEM_UPDATE_rcolor = 8;
  ITEM_UPDATE_ChangeItem = 9;
  ITEM_UPDATE_rcount_add = 10;
  ITEM_UPDATE_rcount_dec = 11;
  ITEM_UPDATE_rboident = 12;
  ITEM_UPDATE_rboBlueprint = 13;
  ITEM_UPDATE_rSpecialLevel = 14;
  ITEM_UPDATE_rcount_UP = 15;

  Emporia_GetItemList = 1;
  Emporia_BUY = 2;
  Emporia_showForm = 3;
  Emporia_Windows_close = 4;
  Emporia_money = 5;

  //20090904增加
   //20090904增加
  Booth_edit_Windows_Open = 1;
  Booth_edit_Windows_Close = 2;
  Booth_edit_Begin = 3;
  Booth_edit_End = 4;
  Booth_edit_item = 5;
  Booth_edit_item_upcount = 6;
  Booth_edit_item_del = 7;
  Booth_edit_Message = 8;

  Booth_user_Windows_Open = 11;
  Booth_user_Windows_Close = 12;
  Booth_user_Buy_OK = 13;
  Booth_user_Sell_OK = 14;
  Booth_user_item = 15;
  Booth_user_item_upcount = 16;
  Booth_user_item_del = 17;

  Booth_user_Message = 20; //摆摊留言
  Booth_CHANGEFEATURE = 21; //摊位 外观

  SHOWEXCHANGE_head = 1;
  SHOWEXCHANGE_Left = 2;
  SHOWEXCHANGE_right = 3;

  WINDOW_NONE = 0;
  WINDOW_ITEMS = 1;
  WINDOW_WEARS = 2;
  WINDOW_SCREEN = 3;
  WINDOW_BASICFIGHT = 4;
  WINDOW_MAGICS = 5;
  WINDOW_EXCHANGE = 6;

  WINDOW_ITEMLOG = 7;

  WINDOW_ALERT = 8;
  WINDOW_AGREE = 9;

  WINDOW_GUILDMAKE = 10;
  WINDOW_GUILDINFO = 11;
  WINDOW_GUILDWAR1 = 12;
  WINDOW_GUILDWAR2 = 13;
  WINDOW_GUILDMAGIC = 14;

  // USE BATTLE SERVER
  WINDOW_GROUPWINDOW = 20;
  WINDOW_ROOMWINDOW = 21;
  WINDOW_GRADEWINDOW = 22;

  WINDOW_ITEMTradehide = 24;
  WINDOW_MENUSAY = 25;

  WINDOW_ITEMTrade_buf = 26; //NPC 交易窗口
  WINDOW_ITEMTrade_sell = 27; //NPC 交易窗口

  WINDOW_ShortcutItem = 28; //快捷 栏 物品

  WINDOW_ShowPassWINDOW_Item = 29;
  WINDOW_ShowPassWINDOW_ItemUnLock = 30;
  WINDOW_ShowPassWINDOW_ItemUPDATE = 31;

  WINDOW_ShowPassWINDOW_LogItem = 32;
  WINDOW_ShowPassWINDOW_LogItemUnLock = 33;
  WINDOW_ShowPassWINDOW_LogItemUPDATE = 34;
  WINDOW_ShowPassWINDOW_GameExit = 35;
  WINDOW_ShowPassWINDOW_Close = 36;
  WINDOW_Email = 37;
  WINDOW_Auction = 38;
  WINDOW_InputCount = 39;
  WINDOW_UPdateItemLevel = 40;
  WINDOW_UPdateItemSetting = 41;
  WINDOW_UPdateItemSetting_del = 42;
  WINDOW_Emporia = 43;
  WINDOW_Close_All = 44;
  WINDOW_Booth_edit = 45;
  WINDOW_Booth_user = 46;
  WINDOW_MAGICS_Rise = 47;
  WINDOW_MAGICS_Mystery = 48;

  AGREE_GUILDMAKE = 0;

  DRAGACTION_NONE = 0;
  DRAGACTION_DROPITEM = 2;
  DRAGACTION_ADDEXCHANGEITEM = 15;

  DRAGACTION_FROMITEMTOLOG = 16;
  DRAGACTION_FROMLOGTOITEM = 17;

  CM_IPADDR = 251;
  CM_PackId = 250; //网络通知包
  CM_NONE = 0;

  CM_PICKUP = 1;
  CM_KEYDOWN = 2;
  CM_Balance = 3; //Balance 获取 验证码
  CM_UPdataItem = 4;
  CM_PowerLevel = 5;
  CM_CLICK = 6;
  CM_DBLCLICK = 7;
  CM_DRAGDROP = 8;
  CM_KEYf5f12SAVE = 9; //热键
  CM_ShowPassWindows = 10;

  CM_HailFellow = 11;
  CM_MSay = 12;

  CM_SOUND = 14;
  CM_TURN = 15;
  CM_MOVE = 16;
  CM_CLICKPERCENT = 17;
  CM_MENUSAY = 18;
  CM_GET = 19; //获取 属性 包
  CM_itempro = 20; //物品详细 资料

  CM_EMAIL = 21;
  CM_Auction = 22;
  CM_Quest = 23;
  CM_CREATEIDPASS2 = 24;
  CM_CHECK = 26;
  CM_Guild = 27;
  CM_SET_OK = 28; //设置 开关
  CM_INPUTSTRING2 = 29;
  CM_InputOk = 30;

  CM_MAKEGUILDDATA = 31;
  CM_GUILDINFODATA = 32;
  CM_IDPASSAZACOM = 33;
  CM_INPUTSTRING = 34;
  CM_SELECTCOUNT = 35;
  CM_CANCELEXCHANGE = 36;
  CM_MOUSEEVENT = 37;
  CM_WINDOWCONFIRM = 38;
  CM_CLOSE = 39;
  CM_VERSION = 40;

  CM_IDPASS = 41;
  CM_CREATEIDPASS = 42;
  CM_CHANGEPASSWORD = 43;
  CM_CREATECHAR = 44;
  CM_DELETECHAR = 45;
  CM_SELECTCHAR = 46;
  CM_ExChange = 47;
  CM_Emporia = 48;
  CM_UserObject = 49;
  CM_SAY = 50;

  CM_HIT = 51;
  CM_AGREEDATA = 52;
  CM_MAKEGUILDMAGIC = 53;
  CM_NETSTATE = 54;
  CM_CREATEIDPASS3 = 55;
  CM_NPCTrade = 56;
  CM_Procession = 57;
  CM_Billboardcharts = 58;
  CM_ITEMLOG = 59;
  CM_UPDATEPASSWORD = 60; //
  CM_FINDPASSWORD = 61;
  CM_ItemText = 62;
  CM_ItemInputWindows = 63;
  CM_Booth = 64;
  CM_CHANGECharName = 65;
  CM_Designation = 66;
  CM_drink = 67;
  CM_Job = 68;
  ////////////////////////////////////////////////////////////
  UserObject_WearItem = 1;

  Job_Item_Material = 1; //物品 生产 材料表
  Job_Skill = 2; //职业 技能 属性
  Job_blueprint_Menu = 3; //生产 图纸菜单
  Job_create = 4;

  PowerLevel_ADD = 1;
  PowerLevel_DEC = 2;
  PowerLevel_level = 3;

  UPdateItem_UPLevelselect = 1; //升级
  UPdateItem_UPLevel = 2; //升级

  UPdateItem_Settingselect = 3; //镶嵌 宝石
  UPdateItem_Setting = 4; //镶嵌 宝石

  UPdateItem_Setting_delselect = 5; //清除镶嵌 宝石
  UPdateItem_Setting_del = 6; //清除镶嵌 宝石

  UPdateItem_Windows_close = 100; //关闭窗口

  ExChange_listAdd = 1;
  ExChange_listDEl = 2;
  ExChange_msg = 3;
  ExChange_msgOk = 4;
  ExChange_msgNO = 5;
  ExChange_ok = 6;
  ExChange_CANCEL = 7;

  ITEMLOG_OUT = 1; //出仓库
  ITEMLOG_IN = 2; //进仓库

  Procession_ADD = 1;
  Procession_DEL = 2;
  Procession_LIST = 3;
  Procession_headman = 4;
  Procession_disband = 5;
  Procession_Create = 6;
  Procession_ADDMsg = 7;
  Procession_ADDMsgOk = 8;
  Procession_ADDMsgNO = 9;
  Procession_exit = 10;
  Procession_additem = 11;
  Procession_say = 12;
  Procession_AddExp = 13; //经验

  Billboardcharts_Energy = 1;
  Billboardcharts_Prestige = 2;

  Quest_GETlist = 1;
  Quest_GET = 2;
  Quest_DEL = 3;
  Quest_listDEL = 4;
  Quest_listadd = 5;
  QuestTempArrUPdate = 6;
  QuestTempArrList = 7;

  DB_CHECKCONNECT = 1;
  DB_STRING = 2;
  DB_CHECKCONNECT_OK = 3;
  DB_USERFIELDS = 4;

  HAVEITEMMAXCOUNT = 3;

  RAINTYPE_RAIN = 0;
  RAINTYPE_SNOW = 1;

  MenuFT_NONE = 0;
  MenuFT_SELL = 1;
  MenuFT_BUY = 2;
  MenuFT_DEAL = 3;
  MenuFT_SAY = 4;
  MenuFT_HELP = 5;
  MenuFT_QUEST = 6;

  MenuFT_GUILDWAR = 7;

  MenuFT_SELLDIR = 8;
  MenuFT_BUYDIR = 9;
  MenuFT_logitem = 10;
  MenuFT_OK = 11;
  MenuFT_Cancel = 12;
  MenuFT_email = 13;
  MenuFT_auction = 14;
  MenuFT_windowsclse = 15;
  MenuFT_UPdateItem_UPLevel = 16;
  MenuFT_UPdateItem_Setting = 17;
  MenuFT_UPdateItem_Setting_del = 18;

  NPCsay_CMD = 1;

  GET_charattrib = 1;
  GET_MapObject = 2;
  Get_KEYf5f12 = 3;
  Get_ItemText = 4; //身上 物品 描述
  Get_Quest = 5;

  itemprolock = 1;
  itemproUNlock = 2;
  itemproGET = 3;
  itemproGET_Magic = 4;
  itemproGET_MagicBasic = 5;

  HailFellowChangeProperty = 1;
  HailFellow_GameExit = 2;
  HailFellow_Message_ADD = 3; //被人 增加
  HailFellow_Message_ADD_OK = 4;
  HailFellow_Message_ADD_NO = 5;
  HailFellow_ADD = 6;
  HailFellow_DEL = 7;
  HailFellow_state_onlise = 8;
  HailFellow_state_downlide = 9;

  GUILD_list = 1;
  GUILD_list_add = 2;
  GUILD_list_del = 3;
  GUILD_list_online = 4;
  GUILD_list_GameExit = 5;
  GUILD_list_ForceDel = 6; //强行  剔除
  GUILD_noticeUPdate = 7; //修改 公告
  GUILD_GradeNameUPDATE = 8; //封号  被修该
  GUILD_list_head = 9;
  GUILD_list_SubSysop = 10;
  GUILD_Create_name = 11;
  GUILD_list_addMsg = 12;
  GUILD_list_addMsgOk = 13;
  GUILD_list_addMsgNo = 14;
  GUILD_list_hit = 15; //被 攻击
  GUILD_list_ForceDelAll = 16; //强行  剔除       实际就是 灭门派
  GUILD_sys = 20;
  GUILD_add = 21; //收人
  GUILD_del = 22; //剔除
  GUILD_del_i = 23; //剔除
  GUILD_set_SubSysop = 24; //设置 副门主
  GUILD_del_SubSysop = 25; //删除 副门主
  GUILD_del_SubSysop_ic = 26; //放弃职位
  GUILD_Level = 27;
  GUILD_Lifedata_add = 28;
  GUILD_Lifedata_del = 29;
  GUILD_Lifedata_update = 30;
  GUILD_Lifedata_Clear = 31;
  GUILD_set_Sysop = 32; //设置 门主

  GUILD_job_None = 0;
  GUILD_job_Sysop = 1;
  GUILD_job_SubSysop = 2;

  SHOWCENTERMSG_BatMsg = 1;
  SHOWCENTERMSG_RollMSG = 2;
  SHOWCENTERMSG_BatMsgTOP = 3;

  SET_OK_wearFD = 1; //使用 时装
  SET_OK_wear = 2; //使用装备
  SET_OK_msg = 3; //

  ShowInputString_type_marryinput = 1; //输入求婚 名字
  ShowInputString_type_marrysetofficiator = 2; //输入主婚人 名字

  ShowInputOk_type_marryMsg = 1; //求婚 消息
  ShowInputOk_type_marry_showmarriage = 2; //要求 男女回答问题
  ShowInputOk_type_marry_setofficiator = 3; //要求 应答 是否当主婚人
  ShowInputOk_type_ummarry = 4; //要求 离婚
  ShowInputOk_type_ExChange = 5; //交易

  EMAIL_read = 1; //阅读
  EMAIL_list = 2; //列表
  EMAIL_del = 3; //删除
  EMAIL_get = 4; //收取
  EMAIL_NEW = 5; //新邮件
  EMAIL_WindowsClose = 6;
  EMAIL_WindowsOpen = 7;
  EMAIL_STATE_NEWEMAIL = 8; //新邮件 状态

  Auction_Item_GetList = 1; //列表
  Auction_Item_ListAdd = 2; //列表 增加
  Auction_Item_ListDel = 3; //列表 减少

  Auction_Consignment = 7; //寄售 发布
  Auction_ConsignmentCancel = 8; //寄售 取消
  Auction_buy = 9; //购买 确认

  Auction_Bargainor_GetNameList = 10; //列表
  Auction_Bargainor_ListAdd = 11; //列表
  Auction_Bargainor_ListDel = 12; //列表
  Auction_getItemText = 13; //获取 物品属性 详细描述
  Auction_getNext = 14; //下一页
  Auction_getBack = 15; //上一页
  Auction_getList = 16; //开始  搜索
  Auction_WindowsClose = 20;
  Auction_WindowsOpen = 21;

type

  TCharData = record
    CharName: string[20];
    ServerName: string[19];
    boCHANGECharName: boolean;
  end;
  TLGRecord = record
    PrimaryKey: string[20];
    PassWord: string[20];
    UserName: string[20];
    Birth: string[20];
    Address: string[50];
    NativeNumber: string[20];
    MasterKey: string[20];
    Email: string[50];
    Phone: string[20];
    ParentName: string[20];
    ParentNativeNumber: string[20];
    CharInfo: array[0..5 - 1] of TCharData;
    IpAddr: string[16];
    MakeDate: string[20];
    LastDate: string[20];
  end;
  PTLGRecord = ^TLGRecord;

  TDistributeType = (pdtRandom, pdtAtLiberty);
  TBillboardchartstype = (bctPrestige, bctEnergy);
  TBillboardchartsdata = record
    rid: integer;
    rname: string[32];
    rEnergy: integer;
    rPrestige: integer;
    rboman: string[2];
  end;
  pTBillboardchartsdata = ^TBillboardchartsdata;

  TMsgType = (mtNone, mtSys, mtSay, mtLeftText, mtLeftText2, mtLeftText3);
  //mtLeftText左边 滚动 消息
  TConfirmDialogtype = (cdtNone, cdtHailFellow, cdtHailFellowDel, cdtGuildAdd,
    cdtGuildDel
    , cdtGuilnoticeUPdate, cdtGuildDel_Force, cdtGuilGradeNameUPdate
    , cdtGuildelevate //
    , cdtGuildSetSys
    , cdtguildSubSysopdel
    , cdtguildSysdel_SubSysop
    , cdtguild_createName
    , cdtguild_addMsg
    , cdtShowInputString2
    , cdtShowInputOk
    , cdtProcession_ADDMsg
    , cdtProcession_ADD
    , cdtItemStirng
    , cdDel_Designation
    );
  TEffectData = record
    rWavNumber: integer;
    rPercent: integer; // 100盒啦
  end;
  PTEffectData = ^TEffectData;

  TDbkey = record
    rmsg: byte;
    rconid: integer;
    rkey: word;
  end;
  PTDbKey = ^TDbKey;

  TDbString = record
    rmsg: byte;
    rconid: integer;
    rWordString: TWordString;
  end;
  PTDbString = ^TDbString;

  TNameString = string[20]; //array[0..NAME_SIZE - 1] of byte; // 茄臂 9臂磊

  TLightDark = (gld_light, gld_dark);
  //Feature面容 wfs_normal无   wfs_care战斗姿势   wfs_sitdown打坐wfs_die死亡
  TFeatureState = (wfs_normal, wfs_care, wfs_sitdown, wfs_die, wfs_running,
    wfs_running2);
  //隐藏的; 秘密的; 神秘的
  THiddenState = (hs_100, hs_0, hs_1, hs_99); //hs_0 隐身
  //行动
  TActionState = (as_free, as_ice, as_slow);
  TLightEffectKind = (lek_none, lek_follow, lek_future, lek_cumulate,
    lek_cumulate_follow);
  //效果 附加 设置  lek_follow跟随模式 lek_cumulate 累积方式
  TFeature_npc_MONSTER = record
    rrace: byte;
    rMonType: byte;
    rTeamColor: word;
    rImageNumber: word;
    raninumber: byte;
    rHideState: THiddenState;
    AttackSpeed: word;
    WalkSpeed: word;
    rfeaturestate: TFeatureState;
  end;
  TFeature = record
    rrace: byte; //有3个地方 标记种族 1，rrace  2，ClassKind  3，BasicObjectType
    raninumber: byte; //动画 配置 物体SDB里的rAnimate字段
    rfeaturestate: TFeatureState; // 0 = normal, 1 = fight, 2 = die
    rboman: Boolean;
    rhitmotion: byte; //动作
    rnation: byte; //部落 国家 20090907
    rMonType: byte; //1 人形怪物 0怪物   20090907

    rArr: array[0..ARR_WEAPON * 2 + 1] of byte;
    //rArr: array[0..32] of byte;
    //2个一组 （图片，颜色）一共16组
    //0 - 9 和身上佩带一一对应 人基本图象  0外观基本描述  1-5 估计是头手脚等
    //10-16

    rImageNumber: word; // 悼拱捞唱, 酒捞袍老版快.
    rImageColorIndex: byte; // 阁胶磐 祸惑
    rTeamColor: word; // 辨靛 祸惑
    rNameColor: word; // 捞抚 祸惑
    rHideState: THiddenState;
    rActionState: TActionState; //冻结
    rEffectNumber: word; //效果 图片ID
    rEffectKind: TLightEffectKind; //效果 类型
    rfellowship: integer; //新 团队
    rboFashionable: boolean; //时装模式

    AttackSpeed: word;
    WalkSpeed: word;
    rEffect_WEAPON_color: word;
  end;
  pTFeature = ^TFeature;
  THitTargetsType = (_htt_nation, _htt_All, _htt_Monster, _htt_Npc);
  //全部攻击，攻击怪物，攻击NPC，攻击其他部落
  THaveItemClassAffair = (hicaRoll_back, hicaStart, hicaConfirm);
  //新增加 本属性 标志自己属于什么类型
  TBasicObjectType = (botNone, botNpc, botMonster, botUser, botItemObject,
    boDynamicObject, boStaticItem, boMirrorObject
    , boGateObject
    , boDoorObject
    , boSoundObj
    , boItemGen
    , boObjectChecker
    , boGuildObject
    , boLifeObject
    , boGuildNpc
    , boVirtualObject
    , boMineObject
    , boGroupMoveObject);
  TBasicData = record
    P: Pointer; //Self  本类 实体
    id: longint;
    //    prestige:integer;          //声望
    Feature: TFeature;
    dir, x, y, nx, ny: word;
    Name: TNameString;
    ViewName: TNameString;
    Guild: TNameString;
    ConsortName: TNameString; //配偶 名字

    ClassKind: Byte;
    //有3个地方 标记种族 1，rrace  2，ClassKind  3，BasicObjectType
    LifePercent: Byte;
    GuardX: array[0..10 - 1] of ShortInt; //体积大物体最大可占10*10位置
    GuardY: array[0..10 - 1] of ShortInt;
    BasicObjectType: TBasicObjectType;
    //有3个地方 标记种族 1，rrace  2，ClassKind  3，BasicObjectType
    REWelkingEffect: integer; //走路效果

    boNotHit: boolean; //是否接受攻击 TRUE 不接受攻击
    MapPathID: integer;
    rbooth: boolean;
    boNotAddExp: boolean;
    HitTargetsType: THitTargetsType;
    MasterId: integer; //20091015主人ID元神 才会有主人
    boMoveKill: boolean;
    //20091019 实现 滚石 功能 按照路线 移动，一定范围内 怪物，NPC，人死亡。
    boMoveKillView: integer;
    boHaveSwap: boolean; //变身
  end;
  PTBasicData = ^TBasicData;

  TLifeDataDownState = set of (
    _ldds_damageBody, _ldds_damageHead, _ldds_damageArm, _ldds_damageLeg
    , _ldds_armorBody, _ldds_armorHead, _ldds_armorArm, _ldds_armorLeg
    , _ldds_AttackSpeed, _ldds_avoid, _ldds_recovery, _ldds_HitArmor,
    _ldds_accuracy
    );

  TLifeData = record
    //damage 攻击
    damageBody: integer; //身体
    damageHead: integer; //头
    damageArm: integer; //武器
    damageLeg: integer; //腿
    //armor 防御
    armorBody: integer;
    armorHead: integer;
    armorArm: integer;
    armorLeg: integer;

    AttackSpeed: integer; //攻击速度
    avoid: integer; //躲避
    recovery: integer; //恢复
    HitArmor: Integer;
    accuracy: integer; //新-命中 2009 3 23 日 增加
    //维持

  end;
  pTLifeData = ^TLifeData;

  TItemLifeData = record
    name: TNameString;
    ViewName: TNameString;
    LifeData: TLifeData;
  end;
  pTItemLifeData = ^TItemLifeData;
  THitData = record
    //4攻击
    damageBody: integer;
    damageHead: integer;
    damageArm: integer;
    damageLeg: integer;
    ToHit: integer;
    HitType: integer;
    HitLevel: integer;
    boHited: Boolean;
    HitedCount: integer;
    HitFunction: integer;
    HitFunctionSkill: integer;
    //20090924增加
    HitTargetsType: THitTargetsType; //攻击类型
  end;
  TEnmitydatatype = (edyUser, edyMonster, edyNpc, eUserProcession);
  TEnmitydata = record
    rAttacker: integer; //攻击者
    rtype: TEnmitydatatype;
    rRunTime: integer; //活动时间 最后攻击时间，30秒后 释放
    rEnmity: integer; //仇恨值   攻击我生命 合计
    rname: string[32];
  end;
  pTEnmitydata = ^TEnmitydata;
  //镶嵌 宝石
  Tsetting = record
    rsettingcount: byte;
    rsetting1: string[20];
    rsetting2: string[20];
    rsetting3: string[20];
    rsetting4: string[20];
  end;
  PTsetting = ^Tsetting;
  TItemDataUPdataLevel = record
    rlevel, //等级
      rmoney, //需要钱
      rhuanxian, //需要幻仙
      rPrestige, //需要荣誉
      rBijou //需要宝石 稳定石头
      : integer;
  end;
  pItemDataUPdataLevel = ^TItemDataUPdataLevel;
  //
{Name,ViewName,Kind,Desc,Grade,QuestNum,NeedItem,NotHaveItem,DelItem,AddItem,
boDouble,boColoring,Shape,WearPos,WearShape,ActionImage,HitMotion,HitType,Color,
Sex,Weight,NeedGrade,Price,BuyPrice,RepairPrice,ServerId,X,Y,SoundEvent,SoundDrop,
boPower,AttackSpeed,Recovery,LongAvoid,Avoid,LongAccuracy,Accuracy,KeepRecovery,
DamageBody,DamageHead,DamageArm,DamageLeg,ArmorBody,ArmorHead,ArmorArm,ArmorLeg,
RandomCount,NameParam1,NameParam2,Material,JobKind,boUpgrade,MaxUpgrade,boTalentExp,
boDurability,Durability,,Abrasion,ToolConst,SuccessRate,boNotTrade,
boNotExchange,boNotDrop,boNotSkill,boNotSSamzie,cLife,Attribute,,RoleType,
Script,MaxCount,BoNotSave,ExtJobExp,}
  boothtype = (bt_buy, bt_sell);
  { TMaterialdata = record
       rname: string[20];
       rcount: integer;
   end;}

  TWeaponLevelColorData = record
    Name: TNameString;
    ViewName: TNameString;
    LevelArr: array[0..20] of word;
  end;
  pTWeaponLevelColorData = ^TWeaponLevelColorData;

  TMaterialData = record
    Name: TNameString;
    NameArr: array[0..4 - 1] of TNameString;
    CountArr: array[0..4 - 1] of integer;
  end;
  pTMaterialData = ^TMaterialData;
  TItemData = record
    rlock: boolean; //false 正常  true锁定（穿戴在身上就不累计属性）
    rName: TNameString;
    rNameColor: integer;

    rStarLevel: integer; //星级20090925
    rStarLevelMax: integer; //星级20090925
    rSoundEvent: TEffectData;
    rSoundDrop: TEffectData;
    rNeedGrade: integer; //(需要等级) 掌和招式=6 灵动=6 风灵=7
    rKind: byte; //状态很多，其中有限制交易

    rHitMotion: byte; //攻击 动画
    rHitType: byte; //攻击 类型
    rLifeDataBasic: TLifeData; //基本属性  (保存 DB)
    rLifeDataLevel: TLifeData; //升级等级 （保存到DB）
    rLifeDataSetting: TLifeData; //镶嵌宝石、精炼 (固定的)
    rLifeDataAttach: TLifeData; //附加属性
    rLifeDataSuit: TLifeData; //套装
    rboident: boolean; //是否可 鉴定

    rId: integer; //新ID 编号 不发到客户端
    rboLOG: boolean; //新开关 记录
    rDecSize: integer; //新 DecSize(损坏大小) 每次磨损几点耐久
    rNameParam: array[0..2 - 1] of string[20];
    rServerId: integer;
    rx, ry: integer;

    //rOwnerRace: Byte;
    //rOwnerServerID: Integer;
    //rOwnerName: string[20];                                                 //array[0..20 - 1] of byte;
    //rOwnerIP: string[20];                                                   //array[0..20 - 1] of byte;
    //rOwnerX, rOwnerY: Integer;

    rTempOwner: TEnmitydata; //临时 物品 属于 谁  创建后30秒 清除本值
    rActionImage: Word; //Action图片

    rMaxCount: integer; //新(最大持有数量)
    rSpecialKind: integer;
    //新特殊 KIND
    //KIND=6状态下
    //        1，掉落
    //        2，生产
    //        3，荣誉
    //        4，合成
    //        5，修炼武功专用
    //        6，任务
    //        7，经验珠子


    //KIND=131属性物品的，重叠标志,脚本自定义;
    //KIND=121宝石的，等级,脚本自定义;
    //KIND=132精炼辅助石头的，类型
    //所有物品100-255以上定义.
    //      100,世界通告,物品名字,人物名字,坐标,地图.1,增加到背包通告,2,扣持久通告.

    rScripter: string[64]; //2009 3 24 增加
    //        rboQuest: boolean;                                                      //任务装备 物品 过地图 就自动删除
            //客户端需要的 =========================================================
    rViewName: TNameString; //名字
    rSex: byte; //性别要求  (0,1 女,2男)
    rShape: word; //外观 图片 ID
    rcolor: byte; //颜色
    rPrice: integer; //价格
    rCount: integer; //数量

    rlockState: byte; //新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
    rlocktime: word; //新 解锁状态 时间
    rboDouble: Boolean; //重叠

    rboNotTrade: boolean; //新开关 NPC交易
    rboNotExchange: boolean; //新开关 玩家交换
    rboNotDrop: boolean; //新开关 丢弃地上
    rboNotSSamzie: boolean; //新开关 存放福袋

    rboTimeMode: boolean; //新开关 时间模式
    rDateTime: tdatetime; //时间
    rDateTimeSec: integer;
    //特殊时间 秒单位 1，rboTimeMode 时间模式 物品最长有效时间；2，KIND 131 附加物品属性有效时间；
  //装备
    rGrade: byte; //新-品介
    rWearArr: byte;
    //(装备部位) 9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕
    rWearShape: byte; //装备后 外观图片
    boUpgrade: boolean; //新 (允许升级)
    MaxUpgrade: byte; //新 (最大升级别)
    rboDurability: boolean; //新开关 消耗持久
    rDurability: integer; //持久
    rCurDurability: integer; //当前持久
    rSmithingLevel: word; //精练等级   //新 装备等级

    rboColoring: Boolean; //(允许染色)
    rboNOTRepair: boolean; //新开关 是否可修理
    rRepairPrice: integer; //维修价格

    rLifeData: TLifeData; //物品属性
    rboSetting: boolean; //是否 随即产生孔
    rSetting: Tsetting;

    rAttach: word;
    //新 附加属性                                                   //镶嵌宝石
    rboBlueprint: boolean; //20091012设计图 TRUE不能穿戴.
    //  rboPrestige: boolean;                                                   //20091012荣誉装备 用特殊字段自定义代替
     // MaterialArr: array[0..3] of TMaterialdata;                              //合成材料
    rMaterial: TMaterialdata;
    rSpecialExp: integer; //20091014经验
    rSpecialLevel: integer;

    rNeedEnergyLevel: integer; //拥有物品 前提元气等级
    rNeedItem: string[20]; //任务 需要物品 才掉落，直接增加到背包
    rNeedItemCount: integer;
    rDecDelay: integer;
    rAttribute: integer;

    rDelItem: string[20];
    rDelItemCount: integer;
    rAddItem: string[20];
    rAddItemCount: integer;

    //        rNotHaveItemArr: array[0..15 - 1] of TNameString;                       //待取消
     //       rNotHaveItemCountArr: array[0..15 - 1] of integer;

    rjobKind: integer; //如果可生产，职业 类型
    TimeTick: integer; //物品属性时间变量
    rcLife: integer; //物品增加活力
    rboJobDown: boolean; //生产下载给客户端标志
    rQuestNum: integer; //任务ID
    rWeaponLevelColor_PP: pTWeaponLevelColorData; //武器 发光配制方案
    rcreatename: TNameString; //制造者名字
    rboQuestProcession: boolean; //任务 支持队伍标记
    rSuitId: integer; //套装ID
    rMix: TNameString; //合成 目标 物品

    rdiePunish: integer;
    //1,死亡掉落；2，死亡破损 ,3，夺宝物品；死亡掉落/下线掉落/换地图掉落。
    rRandomCount: integer; // 几率
    rboExplosion: boolean; //掉落是否爆开
  end;
  PTItemdata = ^TItemData;

  TBoothShopData = record
    rstate: boolean;
    rHaveItemKey: integer; //背包位置
    rPrice: integer;
    rCount: integer;
  end;
  PTBoothShopData = ^TBoothShopData;

  TAtomItem = record
    rItemName: string[64];
    rItemCount: Integer;
    rColor: Integer;
  end;
  TCheckSkill = record
    rName: string[64];
    rLevel: Integer;
  end;
  TCheckItem = record
    rName: string[64];
    rCount: Integer;
    rRandomCount: integer;
  end;
  pTCheckItem = ^TCheckItem;
  TDynamicObjectData = record
    rName: string[64];
    rViewName: string[20];
    rKind: Byte; //集合值
    rShape: Word;
    rLife: Integer;
    rDamage: integer;
    rArmor: integer;
    rStepCount: integer;
    rSStep: array[0..3 - 1, 0..5 - 1] of Byte;
    rEStep: array[0..3 - 1, 0..5 - 1] of Byte;
    rSoundEvent: TEffectData;
    rSoundSpecial: TEffectData;
    rGuardX: array[0..10 - 1] of ShortInt; //有可能是占位置
    rGuardY: array[0..10 - 1] of ShortInt;
    rEventItem: TCheckItem; //EventItem(需要物品) 通过需要物品才能激活事件
    rEventDropItem: TCheckItem;
    //EventDropItem(掉落物品) 通过物品栏拥有必须物品才能激活事件掉落物品
    rEventSay: string[64]; //EventSay(事件说明)
    rEventAnswer: string[64]; //EventAnswer(事件答案
    rboRemove: Boolean;
    //boRemove(允许删除) 例:设置为 "TRUE"打破箱子后会消失屏幕,而火炉被点火后消失屏幕
    rOpennedInterval: Integer; //(开启间隔)
    rScripter: string[64]; //2009 3 24 增加
    rRegenInterval: Integer; //RegenInterval(刷新间隔
    rShowInterval: Integer;
    rHideInterval: Integer;
  end;
  PTDynamicObjectData = ^TDynamicObjectData;

  TCreateDynamicObjectData = record
    rBasicData: TDynamicObjectData;
    {
    rState : Integer;
    rRegenInterval : Integer;
    rLife : Integer;
    }
    rNeedAge: Integer; //NeedAge(需要年龄)
    rNeedSkill: array[0..5 - 1] of TCheckSkill;
    //NeedSkill(需要技能) 如:"伏式气功:5000"= 需要玩家"伏式气功"到达"50.00"才能激活"动态对象"
    rNeedItem: array[0..5 - 1] of TCheckItem; //NeedItem(需要物品)
    rGiveItem: array[0..5 - 1] of TCheckItem; //GiveItem(给予物品)
    rDropItem: array[0..5 - 1] of TCheckItem; //DropItem(掉落物品)
    rDropMop: array[0..5 - 1] of TCheckItem;
    //DropMop(召唤怪物) 格式:"分身忍者:2"=召唤两个"分身忍者"
    rCallNpc: array[0..5 - 1] of TCheckItem; //CallNpc(召唤npc)

    rServerId: integer;
    rX, rY: array[0..5] of Integer;
    //6个坐标，随机刷在某个位置；X(坐标) 动态对象坐标X   Y(坐标) 动态对象坐标Y

    rDropX, rDropY: Word;
    //DropX(掉落坐标)物品掉落具体坐标X      DropY(掉落坐标)物品掉落具体坐标Y
    rWidth: integer;
    rboDelay: boolean;
  end;
  PTCreateDynamicObjectData = ^TCreateDynamicObjectData;

  TItemDrugData = record
    rName: TNameString;
    rtype: integer;
    rUsedCount: integer;
    rEventEnergy: integer; // 锭府芭唱 嘎芭唱 殿殿狼 捞亥飘锭 家厚登绰剧.
    rEventInPower: integer;
    rEventOutPower: integer;
    rEventMagic: integer;
    rEventLife: integer;
    rEventHeadLife: integer;
    rEventArmLife: integer;
    rEventLegLife: integer;
  end;
  PTItemDrugdata = ^TItemDrugData;

  {ViewName,     Kind,MagicType,patternType,RelationMagic,RangeType,AttackCount,NeedMagic,
  ,MagicRelation,Function,EnergyPoint,AttackSpeed,Recovery,KeepRecovery,Avoid,accuracy,
  DamageBody,    DamageHead,DamageArm,DamageLeg,DamageEnergy,ArmorBody,ArmorHead,ArmorArm,
  ArmorLeg,      ArmorEnergy,eEnergy,eInPower,eOutPower,eMagic,eLife,eDamageHead,eDamageArm,
  eDamageLeg,    5Energy,5InPower,5OutPower,5Magic,5Life,5DamageHead,5DamageArm,5DamageLeg,
  kEnergy,       kInPower,kOutPower,kMagic,kDamageHead,kDamageArm,kLife,kDamageLeg,Shape,GoodChar,
  BadChar,       Notice,BowSpeed,BowImage,BowType,,,SoundStart,SoundEnd,SoundStrike,SoundSwing,SoundEvent,
  MinRange,      MaxRange,EffectDelay,PushLength,boNotRecovery,Stun,ScreenEffectNum,ScreenEffectDelay,
  RelationProtect,SameSection,
  }
  TMagicData = record

    //--------------------------------------
    //              发到客户端 字段
    rID: integer; //ID 在加栽 武功 编号
    rname: TNameString; //名字
    rMagicType: integer;
    rcLifeData: TLifeData; //实际 属性
    rcSkillLevel: integer; //等级
    rSkillExp: integer; //经验
    rShape: integer;

    rGuildMagictype: byte;

    rBowImage: integer;
    rBowSpeed: integer;
    rBowType: Byte;
    // rPercent : integer;

    rFunction: byte;

    rGoodChar: integer;
    rBadChar: integer;

    rLifeData: TLifeData;
    {
         rArmorHead : integer;
         rArmorBody : integer;
         rArmorArm : integer;
         rArmorLeg : integer;
         rDamageHead : integer;
         rDamageBody : integer;
         rDamageArm : integer;
         rDamageLeg : integer;

         ravoid : integer;
         rrecovery : integer;
         rAttackSpeed : integer;
    }

    rEventDecEnergy: integer; // 锭府芭唱 嘎芭唱 殿殿狼 捞亥飘锭 家厚登绰剧.
    rEventDecInPower: integer;
    rEventDecOutPower: integer;
    rEventDecMagic: integer;
    rEventDecLife: integer;

    r5SecDecEnergy: integer; // 蜡瘤且锭 5檬付促 林绰 剧
    r5SecDecInPower: integer;
    r5SecDecOutPower: integer;
    r5SecDecMagic: integer;
    r5SecDecLife: integer;

    rEventBreathngEnergy: integer;
    rEventBreathngInPower: integer;
    rEventBreathngOutPower: integer;
    rEventBreathngMagic: integer;
    rEventBreathngLife: integer;

    rKeepEnergy: integer; // 秦瘤 登瘤 救阑 弥家剧.
    rKeepInPower: integer;
    rKeepOutPower: integer;
    rKeepMagic: integer;
    rKeepLife: integer;

    rMagicProcessTick: integer;

    rSoundStrike: TEffectData;
    rSoundSwing: TEffectData;
    rSoundStart: TEffectData;
    rSoundEvent: TEffectData;
    rSoundEnd: TEffectData;
    ////////////////////////////////////////////////////////////////////////
    //                            新段                                    //
    ////////////////////////////////////////////////////////////////////////
    rMotionType, //动作类型 1-9
      rEffectColor, //动作效果 颜色
      rSEffectNumber, //使用当时 效果
      rSEffectNumber2, //使用之后 效果
      rCEffectNumber, //使用之中 效果
      rEEffectNumber //攻击命中 效果
      : integer;
    rEnergyPoint: integer; //元气点 （满级 后增加元气点）
    rMagicRelation: word;
  end;
  PTMagicData = ^TMagicData;

  TMagicParamData = record
    ObjectName: string[20];
    MagicName: string[20];
    NameParam: array[0..5 - 1] of string[20];
    NumberParam: array[0..5 - 1] of Integer;
  end;
  PTMagicParamData = ^TMagicParamData;

  TMonsterData = record
    rName: TNameString;
    rViewName: TNameString;
    rSoundNormal: TEffectData;
    rSoundAttack: TEffectData;
    rSoundDie: TEffectData;
    rSoundStructed: TEffectData;

    rAttackName: TNameString; //目前发现 没使用
    rIdleName: TNameString; //目前发现 没使用

    rWalkSpeed: integer; //移动速度
    rActionWidth: integer; //(活动范围)

    rDamage: integer; //(身体攻击)
    rDamageHead: integer; //(头部攻击)
    rDamageArm: integer; //(手部攻击)
    rDamageLeg: integer; //(腿部攻击)

    rarmor: integer; //(身体防御)

    rAttackSpeed: integer; //(攻击速度)
    rAccuracy: integer; //(命中)
    ravoid: integer; //(躲闪)
    rrecovery: integer; //(恢复)

    rHitArmor: Integer; //HitArmor(击破防御)

    rspendlife: integer;
    //(消耗活力) 受到攻击,但伤害不超过自身防御所掉的活力,默认"10"
    rLife: integer; //活力
    rAnimate: integer; //(赋予生命)
    rShape: integer; //(外形)

    rboLOG: boolean; //新 记录开关
    rRegenInterval: integer; //刷新间隔//2009 3 24 日增加
    rboViewHuman: Boolean; //允许看见玩家
    rboAutoAttack: Boolean; //允许自动攻击 主动攻击
    rboAttack: Boolean; //允许攻击
    rEscapeLife: integer; //逃跑活力值
    rViewWidth: integer; //可视范围
    rboChangeTarget: Boolean;
    //允许改变攻击目标) 如果受到其他人攻击,将会改变攻击目标
    rboBoss: Boolean; //允许为BOSS
    rboVassal: Boolean; //允许联手攻击
    rVassalCount: integer; //联手数量
    rboice: Boolean;
    rHaveItemListP: pointer;
    //rHaveItem: array[0..10 - 1] of TCheckItem;
    rAttackMagic: TMagicData;
    //AttackMagic(攻击武功) 攻击时使用的武功(格式:"迷宫标枪术:10000")
    rHaveMagic: string[64];
    //HaveMagic(使用武功) 自身拥有能力(透视 变身术 医病术 搜集术)
    rScripter: string[64]; //2009 3 24 日增加

    rVirtue: integer; //(浩然正气)
    rExtraExp: integer; //(额外特殊经验值)
    rVirtueLevel: integer; //(浩然正气等级) 上限浩然正气

    r3HitExp: integer; //(真气经验)
    rShortExp: integer; //(近距离经验) 一层武功
    rLongExp: integer; //(远距离经验) 一层武功
    rRiseShortExp: integer; //(二层近距离经验) 二层武功
    rRiseLongExp: integer; //(二层远距离经验) 二层武功
    rHandExp: integer; //(掌风经验)
    rBestShortExp: integer; //(绝世武功1级经验)
    rBestShortExp2: integer; //(绝世武功2级经验)
    rBestShortExp3: integer; //(绝世武功3级经验)

    rLimitSkill: integer; //(修炼武功上限) 修改"稻草人"50.01限制在这里修改

    //       rstarttime: ttime;                                                      //2009 3 24 增加
   //        rendtime: ttime;                                                        //2009 3 24 增加

    rMonType: integer; //类型  1是人型怪物
    rboman: Boolean; //性别
    rArr: array[0..31] of byte; //人型怪物 面貌
    rhitmotion: integer;
    rboNOTAddExp: boolean; //被攻击 是否给经验 20090916
    rboControl: boolean;
    rxControl: integer;
    ryControl: integer;
  end;
  PTMonsterData = ^TMonsterData;
  //Name,ViewName,Virtue,VirtueLevel,NpcText,boMinimapShow,boSale,boSeller,boProtecter,
  //boObserver,boAutoAttack,boHit,animate,shape,Image,Damage,Armor,ArmorHead,ArmorArm,
  //ArmorLeg,Life,AttackSpeed,Avoid,Recovery,SpendLife,HitArmor,ActionWidth,SoundStart,
  //SoundAttack,SoundDie,SoundNormal,SoundStructed,EffectStart,EffectStructed,EffectEnd,
  //HaveItem,AttackMagic,AttackSkill,HaveMagic,RegenInterval,boBattle,boRightRemove,
  TNpcData = record
    rName: TNameString;
    rViewName: TNameString;
    rAnimate: integer;
    rShape: integer;
    rImage: integer;
    rMinimapShow: boolean;
    rdamage: integer;
    rAttackSpeed: integer;
    ravoid: integer;
    rrecovery: integer;
    rspendlife: integer;
    rarmor: integer;
    rHitArmor: Integer;
    rLife: integer;
    rboSeller: Boolean;
    rboProtecter: Boolean;
    rboAutoAttack: Boolean;
    rActionWidth: integer;
    rHaveItem: array[0..10 - 1] of TCheckItem;

    rSoundNormal: TEffectData;
    rSoundAttack: TEffectData;
    rSoundDie: TEffectData;
    rSoundStructed: TEffectData;

    rNpcText: string[64]; //array[0..64] of byte;
    rboHit: boolean; //2009 4 8 新增加
    rRegenInterval: integer; //2009 3 24 日增加
    rScripter: string[64]; //2009 3 24 日增加
  end;
  PTNpcData = ^TNpcData;

  {
  TNpcData = record
    rname : TNameString;
    rdamage : integer;
    rAttackSpeed : integer;
    ravoid : integer;
    rrecovery : integer;
    rspendlife : integer;
    rarmor : integer;
    rLife : integer;
    rboMan : Boolean;
    rboSeller: Boolean;
    rboProtecter: Boolean;
    rActionWidth : integer;
    rNpcText: TNameString;
    rItemDataArr : array [0..10] of TItemData;
  end;
  PTNpcData = ^TNpcData;
  }

  TMenuSTATE = (
    nsNONE //空
    , nsSelect //1，选择 NPC
    , nsSAY //2，对话 状态  在本状态后才能 买卖仓库
    , nsSELL //3，NPC 出售
    , nsBUF //4，NPC  收购
    , nsLOGITEM //5，仓库
    , nsemail //6,邮件
    , nsauction //7，寄售
    , nsUPdateitemLevel //8,升级装备
    , nsUPdateitemSetting //8,升级装备
    , nsUPdateitemSettingdel //8,升级装备
    );
  TLifeObjectState = (los_init, los_exit, los_none, los_die, los_escape,
    los_Attack, los_moveattack, los_deadattack,
    los_follow, los_stop, los_rest, los_movework,
    los_eat, los_move, los_kill
    );
  TExpType = (_et_none
    , _et_NPC //NPC给于
    , _et_HUMAN //人给于
    , _et_MONSTER //怪物给于
    , _et_MONSTER_die //死亡经验
    , _et_PET //元神给于经验
    , _et_PET_MONSTER_die
    , _et_Procession //队伍给于
    );
  TExpData = record
    Exp: integer;
    ExpType: TExpType;
    LevelMax: integer; //最大等级

  end;

  TSubData = record
    TargetId: integer;
    VassalCount: integer; // 磊脚捞 荤侩窍霸登搁 临绢惦...
    ServerId: integer;
    tx, ty: integer;
    ItemData: TItemData;
    HitData: THitData;
    ExpData: TExpData;
    motion: integer;
    motionMagicType: integer; //2009 4 19 增加
    motionMagicColor: integer; //2009 4 19 增加
    percent: byte;
    sysopscope: integer;
    attacker: integer;
    attackerMasterId: integer;
    BowImage: integer;
    BowSpeed: integer;
    BowType: Byte;
    EEffectNumber: integer;

    SubName: TNameString;
    GuildName: TNameString;
    SayString: TWordString;
    ShoutColor: integer;
    sound: word; //新 增加
    delItemKey: integer;
    delItemcount: integer;
    ProcessionClass: pointer;
  end;

  TCurAttribData = record
    CurEnergy: integer; // 元气
    CurInPower: integer; // 内功
    CurOutPower: integer; // 外功
    CurMagic: integer; // 武功
    CurLife: integer; // 活力

    CurHealth: integer;
    CurSatiety: integer;
    CurPoisoning: integer;
    CurHeadSeak: integer;
    CurArmSeak: integer;
    CurLegSeak: integer;
  end;
  //称号
  TDesignationData = record
    // rLifeData: TLifeData;                                                   //20091014 荣誉称号
    rname: string[20];
    rcurid: integer;
    rIdArr: array[0..10 - 1] of integer;
    rNameArr: array[0..10 - 1] of TNameString;
  end;
  {个烹傍拜（打头） 赣府傍拜（打手） 迫傍拜（打脚）
  促府傍拜（攻击） 傍拜加档（速度） 磊技焊沥（恢复） 雀乔（躲闪） 沥犬档（命中）}
  TAttribData = record

    Age, cAge: integer; //年龄
    Light, cLight: integer; //阳气
    Dark, cDark: integer; //阴气
    Energy, //最大 元气（原始）   真实 的元气
      cEnergy //最大 元气
      : integer; //DefaultValue, cDefaultValue:integer;

    InPower, cInPower: integer; //内功
    OutPower, cOutPower: integer; //外功
    Magic, cMagic: integer; //武功
    Life, cLife: integer; //活力 生命

    cHeadSeak: integer; //头
    cArmSeak: integer; //手
    cLegSeak: integer; //脚

    cHealth: integer; //健康  （翻译）自己定义（健康）
    cSatiety: integer; //厌腻  （翻译）自己定义（饱和）
    cPoisoning: integer; //施毒法（翻译）自己定义（中毒）

    Talent, cTalent: integer; //才能
    GoodChar, cGoodChar: integer; //神性
    BadChar, cBadChar: integer; //魔性
    lucky, clucky: integer; //幸运  运气 （翻译）
    adaptive, cadaptive: integer; //耐性
    Revival, cRevival: integer; //再生
    immunity, cimmunity: integer; //免疫
    virtue, cvirtue: integer; //浩然

    prestige: integer; //荣誉

    //三魂六魄
    r3f_sky, //天
      r3f_terra, //地
      r3f_fetch //魂
      : INTEGER;
  end;
  //任务 属性 特殊情况下的 属性
  TAttribQuestData = record
    AttribLifeData: TLifeData;
    Age: integer; //年龄
    Light: integer; //阳气
    Dark: integer; //阴气
    virtue: integer; //浩然
    adaptive: integer; //耐性
    Revival: integer; //再生

    Energy: integer; //元气
    InPower: integer; //内功
    OutPower: integer; //外功
    Magic: integer; //武功
    Life: integer; //活力 生命
    HeadSeak: integer; //头
    ArmSeak: integer; //手
    LegSeak: integer; //脚

    Health: integer; //健康  （翻译）自己定义（健康）
    Satiety: integer; //厌腻  （翻译）自己定义（饱和）
    Poisoning: integer; //施毒法（翻译）自己定义（中毒）

    Talent: integer; //才能
    GoodChar: integer; //神性
    BadChar: integer; //魔性
    lucky: integer; //幸运  运气 （翻译）
    immunity: integer; //免疫

    //        prestige: integer;                                                      //荣誉
            //三魂六魄
    r3f_sky, //天
      r3f_terra, //地
      r3f_fetch //魂
      : INTEGER;

  end;
  //:0:0:0:0:0:0:0:0
//9个
//长刀:1:1:0:0:0:0:0:0
{第1位 数量关系
第2位 颜色<取ITEM.SDB颜色字段>
第3位 现在耐久 <剩余多少耐久度> 比如:神秘箱子:0:1:186:200:0:0:0:0,说明该物品剩余186点耐久度.
第4位 总耐久   <取ITEM.SDB文件boDurability,Durability,DecDelay,DecSize字段设置>   比如:神秘箱子:0:1:186:200:0:0:0:0 说明该物品总耐久度为200点.
第5位 装备等级      装备分（1。2。3。4）
第6位 属性 附加属性    <玩家在附加装备属性时,TGS根据AdditionalAttrib文件夹下的配置表算法得到附加属性进行保存,04版分20个等级的附加属性>02版无次功能,详见隐龙版TGS1000目录下AdditionalAttrib文件夹内表设置.
第7位 物品锁状态， <分为加锁、不加锁、解锁三种状态    0,无锁状态，1,是加锁状态,2,是解锁状态>
第8位 解锁状态    默认是1440分钟解锁,比如:狐狸骨头:1:1:0:0:0:0:2:10 ,说明该物品已经解锁10分钟.}

  TDBItemData = record //***统一*** 定为 简易物品
    rID: integer; //装备编号
    rName: string[20]; //array[0..20 - 1] of byte; //名字
    rCount: Integer; //数量
    rColor: Byte; //颜色
    rDurability: integer; //耐久
    rDurabilityMAX: integer; //耐久
    rSmithingLevel: word; //装备等级
    rAttach: word; //附加属性
    rlockState: byte; //物品锁状态   0,无锁状态，1,是加锁状态,2,是解锁状态
    rlocktime: word; //解锁状态 时间
    rSetting: Tsetting; //镶嵌 宝石
    rDateTime: tdatetime; //时间       时间模式  使用
    //   rLifeDataLevel: TLifeData;                                              //升级等级 （保存到DB）
    rBoident: boolean; //鉴定
    rStarLevel: byte; //星级
    rboBlueprint: boolean; //设计图
    rSpecialExp: integer;
    rCreateName: string[20];
    rDummy1: word; //保留字段1
    rDummy2: dword;
    rDummy3: dword;
    rDummy4: dword;
  end;
  TDBItemDataQuest = record //***统一*** 定为 简易物品
    rName: string[20]; //array[0..20 - 1] of byte; //名字
    rCount: Integer; //数量
    rDummy1: dword; //保留字段1
    rDummy2: dword;
    rDummy3: dword;
    rDummy4: dword;
  end;

  TCutItemData = TDBItemData; //精简 物品
  pTCutItemData = ^TCutItemData;
  TExChangeItem = record
    rsend: boolean; //是否被发送
    ritem: TItemData;
    rkey: word;
  end;
  pTExChangeItem = ^TExChangeItem;
  // :0
  TDBMagicData = record
    rName: string[20]; //array[0..20 - 1] of byte;
    rSkill: Integer;
  end;
  pTDBMagicData = ^TDBMagicData;
  TDBBasicMagicData = record
    Skill: integer;
  end;
  // :0
  TDBBasicRiseMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    Skill: Integer;
  end;
  // :0
  TDBHaveRiseMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    Skill: Integer;
  end;
  // :0
  TDBHaveMysteryMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    Skill: Integer;
  end;
  //:0:0:0:0:0:0:0:0:0:0:0:0
  //13   高级 特殊 武工
  TDBHaveBestSpecialMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    T: array[0..12 - 1] of INTEGER; //临时 占位置
  end;
  //:0:0:0:0:0:0:0:0:0:0:0:0
  TDBHaveBestProtectMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    T: array[0..12 - 1] of INTEGER; //临时 占位置
  end;
  //:0:0:0:0:0:0:0:0:0:0:0:0
  TDBHaveBestAttackMagicData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    T: array[0..12 - 1] of byte; //临时 占位置
  end;

  //:0:0:0:0:0:0:0:0
  //9个    有可能 就是TDBItemData
  TDBHaveMaterialItemData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    T: array[0..8 - 1] of INTEGER; //临时 占位置
  end;
  //:0:0:0:0:0:0:0
  //8个
  TDBHaveMarketItemData = record
    Name: string[20]; //array[0..20 - 1] of byte;
    T: array[0..7 - 1] of INTEGER; //临时 占位置
  end;
  TDBPersonData = record
    Name: string[20]; //array[0..20 - 1] of byte;
  end;
  //仓库
  TItemRecordHeader = record
    boLocked: Boolean; //是否被锁定
    OwnerName: string[20]; //array[0..20 - 1] of byte; //拥有者名字
    LockPassword: string[9]; //array[0..9 - 1] of byte; //锁定 密码
    // LastUpdate:array[0..11 - 1] of byte;
  end;
  PTItemRecordHeader = ^TItemRecordHeader;
  TItemLogData = TDBItemData;
  pTItemLogData = ^TItemLogData;
  TItemLogRoom = record
    boUsed: Boolean; //是否 使用
    ItemData: array[0..(10) - 1] of TItemLogData;
  end;
  TItemLogRecord = record
    Header: TItemRecordHeader;
    rsize: integer;
    data: array[0..10 * 8 - 1] of TItemLogData;
  end;

  PTItemLogRecord = ^TItemLogRecord;

  TPaidType = (pt_none,
    pt_invalidate, //过期
    pt_validate, //有效 日期算
    pt_test, //测试
    pt_timepay //秒卡

    );
  //, pt_nametime, pt_ipmoney, pt_iptime);

  TPaidData = record
    rLoginId: string[20];
    rIpAddr: string[20];
    rRemainDay: Integer;
    rMakeDate: string[20];
    rPaidType: TPaidType;
    rmaturity: tdatetime;
    rCode: Byte;
  end;
  PTPaidData = ^TPaidData;
  //===========================================================================
  TDBMagicData_20091013 = record
    rName: string[20]; //array[0..20 - 1] of byte;
    rSkill: Integer;
  end;
  TLifeData_20091013 = record
    //damage 攻击
    damageBody: integer; //身体
    damageHead: integer; //头
    damageArm: integer; //武器
    damageLeg: integer; //腿
    //armor 防御
    armorBody: integer;
    armorHead: integer;
    armorArm: integer;
    armorLeg: integer;

    AttackSpeed: integer; //攻击速度
    avoid: integer; //躲避
    recovery: integer; //恢复
    HitArmor: Integer;
    accuracy: integer; //新-命中 2009 3 23 日 增加
  end;
  Tsetting_20091013 = record
    rsettingcount: byte;
    rsetting1: string[20];
    rsetting2: string[20];
    rsetting3: string[20];
    rsetting4: string[20];
  end;
  TDBItemData_20091013 = record //***统一*** 定为 简易物品
    rID: integer; //装备编号
    rName: string[20]; //array[0..20 - 1] of byte; //名字
    rCount: Integer; //数量
    rColor: Byte; //颜色
    rDurability: integer; //耐久
    rDurabilityMAX: integer; //耐久
    rSmithingLevel: word; //装备等级
    rAttach: word; //附加属性
    rlockState: byte; //物品锁状态   0,无锁状态，1,是加锁状态,2,是解锁状态
    rlocktime: word; //解锁状态 时间
    rSetting: Tsetting_20091013; //镶嵌 宝石
    rDateTime: tdatetime; //时间       时间模式  使用
    rLifeDataLevel: TLifeData_20091013; //升级等级 （保存到DB）
    rBoident: boolean; //鉴定
    rStarLevel: byte; //星级
    rboBlueprint: boolean; //设计图
    rDummy1: word; //保留字段1
    rDummy2: dword;
    rDummy3: dword;
    rDummy4: dword;
  end;
  TItemRecordHeader_20091013 = record
    boLocked: Boolean; //是否被锁定
    OwnerName: string[20]; //array[0..20 - 1] of byte; //拥有者名字
    LockPassword: string[9]; //array[0..9 - 1] of byte; //锁定 密码
  end;
  TItemLogRecord_20091013 = record
    Header: TItemRecordHeader_20091013;
    rsize: integer;
    data: array[0..10 * 4 - 1] of TDBItemData_20091013;
  end;
  TDBRecord_20091013 = record
    PrimaryKey: string[20]; //array[0..20 - 1] of byte; // 某腐疙
    ID: integer; //新 人物编号
    // SUser:byte;                //使用 标记   没办法 只能放在PrimaryKey 之后，有代码直接把PrimaryKey当0号位置
    rPaidType: TPaidType; //用户  点卡 类型
    MasterName: string[20]; //array[0..20 - 1] of byte; // 拌沥疙
    Password: string[20]; //array[0..20 - 1] of byte; //新 物品密码
    GroupKey: integer; //新  角色团队

    Guild: string[20]; //array[0..20 - 1] of byte; // 角色门派
    LastDate: tdatetime; //array[0..12 - 1] of byte; //最后登陆时间
    CreateDate: tdatetime; //array[0..12 - 1] of byte; //创建角色时间
    Sex: boolean; //array[0..6 - 1] of byte; // 性别 男或女

    ServerId: byte; // 角色所在服务器地图 0表示新手村 1表示长城以南
    x: word; // X 坐标
    y: word; // Y 坐标
    GOLD_Money: integer; //新 元宝
    prestige: integer; //新 声望

    Light: Integer; // 剧扁

    Dark: Integer; // 澜扁
    Energy: Integer; // 元气
    InPower: Integer; // 内功
    OutPower: Integer; // 外功
    Magic: Integer; // 武功
    Life: Integer; // 活力

    Talent: integer; // 犁瓷
    GoodChar: integer; // 脚己
    BadChar: integer; // 付己
    Adaptive: integer; // 郴己
    Revival: integer; // 犁积
    Immunity: integer; // 搁开
    Virtue: integer; // 浩然正气

    CurEnergy: integer; // 总元气
    CurInPower: integer; // 内功
    CurOutPower: integer; // 外功
    CurMagic: integer; // 武功
    CurLife: integer; // 活力

    CurHealth: integer; // 头防百分比*模糊
    CurSatiety: integer; // 手防百分比*模糊
    CurPoisoning: integer; // 腿防百分比*模糊
    CurHeadSeek: integer; // 泅犁 赣府 劝仿
    CurArmSeek: integer; // 泅犁 迫 劝仿
    CurLegSeek: integer; // 泅犁 促府 劝仿

    ExtraExp, //新   额外 真气经验
      AddableStatePoint, //新   三层 真气
      TotalStatePoint, //新   总真气
      CurrentGrade //新
      : integer;
    FashionableDress: boolean; //新 时装模式
    //佩带
    WearItemArr: array[0..(8) - 1] of TDBItemData_20091013; //穿戴
    FashionableDressArr: array[0..(8) - 1] of TDBItemData_20091013; //时装

    //拥有 Have
    HaveItemArr: array[0..30 - 1] of TDBItemData_20091013;
    // 物品栏物品 默认为30个格子

  //基本武功，分一层和二层基本
    BasicMagicArr: array[0..10 - 1] of TDBMagicData_20091013; //基本武功 一层武功
    BasicRiseMagicArr: array[0..10 - 1] of TDBMagicData_20091013;
    //新 基本二层武功 9个

  //一层武功和二层武功
    HaveMagicArr: array[0..30 - 1] of TDBMagicData_20091013; //一层 30个
    HaveRiseMagicArr: array[0..30 - 1] of TDBMagicData_20091013; //新 二层30个

    //掌风武功
    HaveMysteryMagicArr: array[0..30 - 1] of TDBMagicData_20091013;
    //新 掌风武功 30个

  //三层武功
 // HaveBestSpecialMagicArr:array[0..15 - 1] of TDBHaveBestSpecialMagicData; //新 三层招式 15个
//  HaveBestProtectMagicArr:array[0..5 - 1] of TDBHaveBestProtectMagicData; //新 三层护体 5个
 // HaveBestAttackMagicArr:array[0..5 - 1] of TDBHaveBestAttackMagicData; //新 三层攻击武功 5个

//   HaveMaterialItemArr:array[0..5 - 1] of TDBHaveMaterialItemData; //0-4,新  身上 物品
 // HaveMarketItemArr:array[0..10 - 1] of TDBHaveMarketItemData; //0-9,新   市场 物品

//  PersonArr:array[1..5 - 1] of TDBPersonData; //新 1 - 4, 陌生 人

    KeyArr: array[0..9] of BYTE; //0 - 9, 新  热键
    ShortcutKeyArr: array[0..9] of BYTE; //0 - 9, 新  热键

    CompleteQuestNo: integer; //新 任务 完成ID
    CurrentQuestNo: integer; //新 任务 当前ID
    Queststep: integer; //新 任务 步骤ID
    QuesttempArr: array[0..19] of integer; //新 任务 临时变量

    tempArr: array[0..99] of integer; //新 临时变量

    SubCurrentQuestNo: integer; //新 分支任务 当前ID
    SubQueststep: integer; //新 分支任务 步骤ID

    JobKind: byte; //新   职业：共四个职业 1、2、3、4、
    //新 增加 仓库
    ItemLog: TItemLogRecord_20091013; //4行

    //三魂六魄
    r3f_sky, //天
      r3f_terra, //地
      r3f_fetch //魂
      : INTEGER;
    Dummy1: string[66]; //array[0..66 - 1] of byte; //模型人;假人

  end;
  PTDBRecord_20091013 = ^TDBRecord_20091013;

  TDBRecord = record
    PrimaryKey: string[20]; //array[0..20 - 1] of byte; // 某腐疙
    ID: integer; //新 人物编号
    // SUser:byte;                //使用 标记   没办法 只能放在PrimaryKey 之后，有代码直接把PrimaryKey当0号位置
    rPaidType: TPaidType; //用户  点卡 类型
    MasterName: string[20]; //array[0..20 - 1] of byte; // 拌沥疙
    Password: string[20]; //array[0..20 - 1] of byte; //新 物品密码
    GroupKey: integer; //新  角色团队

    Guild: string[20]; //array[0..20 - 1] of byte; // 角色门派
    LastDate: tdatetime; //array[0..12 - 1] of byte; //最后登陆时间
    CreateDate: tdatetime; //array[0..12 - 1] of byte; //创建角色时间
    Sex: boolean; //array[0..6 - 1] of byte; // 性别 男或女

    ServerId: byte; // 角色所在服务器地图 0表示新手村 1表示长城以南
    x: word; // X 坐标
    y: word; // Y 坐标
    GOLD_Money: integer; //新 元宝
    prestige: integer; //新 声望

    Light: Integer; // 剧扁

    Dark: Integer; // 澜扁
    Energy: Integer; // 元气
    InPower: Integer; // 内功
    OutPower: Integer; // 外功
    Magic: Integer; // 武功
    Life: Integer; // 活力

    Talent: integer; // 犁瓷
    GoodChar: integer; // 脚己
    BadChar: integer; // 付己
    Adaptive: integer; // 郴己
    Revival: integer; // 犁积
    Immunity: integer; // 搁开
    Virtue: integer; // 浩然正气

    CurEnergy: integer; // 总元气
    CurInPower: integer; // 内功
    CurOutPower: integer; // 外功
    CurMagic: integer; // 武功
    CurLife: integer; // 活力

    CurHealth: integer; // 头防百分比*模糊
    CurSatiety: integer; // 手防百分比*模糊
    CurPoisoning: integer; // 腿防百分比*模糊
    CurHeadSeek: integer; // 泅犁 赣府 劝仿
    CurArmSeek: integer; // 泅犁 迫 劝仿
    CurLegSeek: integer; // 泅犁 促府 劝仿

    ExtraExp, //新   额外 真气经验
      AddableStatePoint, //新   三层 真气
      TotalStatePoint, //新   总真气
      CurrentGrade //新
      : integer;

    FashionableDress: boolean; //新 时装模式
    //佩带
    WearItemArr: array[0..(14) - 1] of TDBItemData; //穿戴
    FashionableDressArr: array[0..(14) - 1] of TDBItemData; //时装

    //拥有 Have
    HaveItemArr: array[0..30 - 1] of TDBItemData; // 物品栏物品 默认为30个格子

    //基本武功，分一层和二层基本
    BasicMagicArr: array[0..10 - 1] of TDBMagicData; //基本武功 一层武功
    BasicRiseMagicArr: array[0..10 - 1] of TDBMagicData; //新 基本二层武功 9个

    //一层武功和二层武功
    HaveMagicArr: array[0..30 - 1] of TDBMagicData; //一层 30个
    HaveRiseMagicArr: array[0..30 - 1] of TDBMagicData; //新 二层30个

    //掌风武功
    HaveMysteryMagicArr: array[0..30 - 1] of TDBMagicData; //新 掌风武功 30个

    //三层武功
   // HaveBestSpecialMagicArr:array[0..15 - 1] of TDBHaveBestSpecialMagicData; //新 三层招式 15个
  //  HaveBestProtectMagicArr:array[0..5 - 1] of TDBHaveBestProtectMagicData; //新 三层护体 5个
   // HaveBestAttackMagicArr:array[0..5 - 1] of TDBHaveBestAttackMagicData; //新 三层攻击武功 5个

 //   HaveMaterialItemArr:array[0..5 - 1] of TDBHaveMaterialItemData; //0-4,新  身上 物品
   // HaveMarketItemArr:array[0..10 - 1] of TDBHaveMarketItemData; //0-9,新   市场 物品

  //  PersonArr:array[1..5 - 1] of TDBPersonData; //新 1 - 4, 陌生 人

    KeyArr: array[0..9] of BYTE; //0 - 9, 新  热键
    ShortcutKeyArr: array[0..9] of BYTE; //0 - 9, 新  热键

    CompleteQuestNo: integer; //新 任务 完成ID
    CurrentQuestNo: integer; //新 任务 当前ID
    Queststep: integer; //新 任务 步骤ID
    QuesttempArr: array[0..19] of integer; //新 任务 临时变量

    tempArr: array[0..99] of integer; //新 临时变量

    SubCurrentQuestNo: integer; //新 分支任务 当前ID
    SubQueststep: integer; //新 分支任务 步骤ID

    JobKind: byte; //新   职业：共四个职业 1、2、3、4、

    //新 增加 仓库
    ItemLog: TItemLogRecord; //4行
    //三魂六魄
    r3f_sky, //天
      r3f_terra, //地
      r3f_fetch //魂
      : INTEGER;
    DesignationCurID: integer; //当前 称号
    DesignationArr: array[0..10 - 1] of integer; //称号 列表
    HaveItemQuestArr: array[0..30 - 1] of TDBItemDataQuest;
    JobKindLevelExp: integer;
    //武功删除数量，每日0点减少或者清除本数字
    DelMagicCount: byte;
    DelMagicTime: Tdatetime;

    //双倍经验
    MagicExpMulCount: byte; //倍数
    MagicExpMulEndTime: Tdatetime; //倍数 结束时间
    //领取时间
    MagicExpUseTime: Tdatetime;

    Dummy2: array[0..500 - 1 - 26] of byte;
    //原始62
    Dummyb: string[62]; //array[0..66 - 1] of byte; //模型人;假人
  end;
  PTDBRecord = ^TDBRecord;

  TAuctionPriceType = (aptGold, aptGOLD_Money);
  TAuctionData = record
    rid: integer;
    ritemimg: integer;
    rItem: TCutItemData; //物品
    rPricetype: TAuctionPriceType;
    rPrice: integer; //价格
    rTime: Tdatetime; //开始时间
    rMaxTime: integer; //出售最长时间
    rBargainorName: string[20]; //出售人名字
  end;
  pTAuctionData = ^TAuctionData;
  TEmaildata = record
    FID: integer;
    FDestName: string[64]; //目的 名字
    FTitle: string[64]; //标题
    FEmailText: string[255]; //内容
    FsourceName: string[64]; //来源 名字
    FTime: tdatetime;
    FGOLD_Money: integer; //【元宝】
    Fbuf: TCutItemData; //保存 精简物品
  end;
  pTEmaildata = ^TEmaildata;
  TEmailNamedata = record
    rUserName: string[20]; // 名字
    rRegDate: Tdatetime; //注册时间
  end;
  pTEmailNamedata = ^TEmailNamedata;

  TExChangeData = record
    rExChangeId: LongInt; //对方 ID
    rExChangeName: string[32]; //对方名字
    rboCheck: boolean; //自己 确定 状态
    rItems: array[0..3] of TExChangeItem; //自己要交易 物品
  end;
  PTExChangeData = ^TExChangeData;

  TPosByDieData = record
    rServerID: Integer;
    rDestServerID: Integer;
    rDestX, rDestY: Word;
  end;
  PTPosByDieData = ^TPosByDieData;

  // 巩颇措傈 滚傈
  {
  TCreateMonsterData = record
     Name : string[64];
     x, y  : Integer;
     Width : Integer;
     Count : integer;
     Member : String;
     Interval : integer;
     DurationLifeTick : integer;
  end;
  PTCreateMonsterData = ^TCreateMonsterData;

  TCreateNpcData = record
     Name : String [20];
     MapID : Integer;
     X, Y  : Integer;
     Width : Integer;
     RegenInterval : Integer;
     FuncNo : Integer;
     BookName : String [64];
  end;
  PTCreateNpcData = ^TCreateNpcData;
  }

  // 2001.5.31 滚傈
  TCreateMonsterData = record
    mName: string[64];
    Index: integer;
    x, y: integer;
    Width, CurCount, Count: integer;
    Member: string[64];
    Interval: integer;
    DurationLifeTick: integer;
    rnation: byte;
    rmappathid: integer;

  end;
  PTCreateMonsterData = ^TCreateMonsterData;

  TCreateNpcData = record
    mName: string[64];
    Index: integer;
    x, y: integer;
    Width, CurCount, Count: integer;
    Interval: Integer;
    DurationLifeTick: integer;
    BookName: string[64];
    rnation: byte;
    rmappathid: integer;
  end;
  PTCreateNpcData = ^TCreateNpcData;

  TAreaClassData = record
    Name: string[32];
    Index: Byte;
    Func: string[64];
    Desc: string[128];
  end;
  PTAreaClassData = ^TAreaClassData;
  TCreateGroupMoveData = record
    Name, GateName, ViewName: string[20];
    Shape, SStep, EStep, Width, X, Y,
      TargetX, TargetY, AddWidth, MapID, TargetMapID, MoveNum: integer;
    AddItem: string[20];
  end;
  PTCreateGroupMoveData = ^TCreateGroupMoveData;

  TCreateGateData = record
    Name: string[64];
    ViewName: string[20];
    MapID: Integer;
    X, Y: integer;
    TargetX, TargetY: integer;
    EjectX, EjectY: integer;
    targetserverid: integer;
    Kind: Byte;
    shape: integer;
    Interval: integer;
    DurationLifeTick: integer;
    Width: Integer;
    NeedAge: Integer;
    OverEnergy: integer;
    AgeNeedItem: Integer;
    NeedItem: array[0..5] of TCheckItem;
    Quest: Integer;
    QuestNotice: string[128];
    RegenInterval: Integer;
    ActiveInterval: Integer;
    EjectNotice: string[128];
    RandomPosCount: Byte;
    Show: boolean;
    RandomX: array[0..10 - 1] of Word;
    RandomY: array[0..10 - 1] of Word;
    Scripter: string[128]; //2009 3 24 新增加
  end;
  PTCreateGateData = ^TCreateGateData;

  TCreateMirrorData = record
    Name: string[32];
    X, Y, MapID: Integer;
    boActive: Boolean;
  end;
  PTCreateMirrorData = ^TCreateMirrorData;

  TCreateVirtualObject = record
    Name: string[32];
    X, Y, Width, Height, Kind, Life: integer;
  end;
  pTCreateVirtualObject = ^TCreateVirtualObject;
  TMineShapeData = record
    Name: TNameString;
    Shape: integer;
    SStep: integer;
    EStep: integer;
    GuardXArr: array[0..10 - 1] of integer;
    GuardYArr: array[0..10 - 1] of integer;
  end;
  pTMineShapeData = ^TMineShapeData;

  TMineData = record
    Name: TNameString;
    ViewName: TNameString;
    PickConst: integer;
    DepositsArr: array[0..5] of integer;
    ItemArr: array[0..9] of TNameString;
    Sound: integer;
    RegenIntervalsArr: array[0..2] of integer;
    DropMopName: TNameString;
    DropMopCount: integer;
  end;
  pTMineData = ^TMineData;
  //Name,ViewName,Grade,StartLevel,EndLevel,MaxItemGrade,1Grade,2Grade,3Grade,4Grade,5Grade,6Grade,7Grade,8Grade,9Grade,10Grade,Alchemist,Chemist,Designer,Craftsman
  TJobGradeData = record
    Name: TNameString;
    ViewName: TNameString;
    Grade, StartLevel, EndLevel, MaxItemGrade: integer;
    GradeArr: array[0..12 - 1] of integer;
    Alchemist, //炼金术士
      Chemist, //chemist
      Designer, //裁缝
      Craftsman //工匠
      : TNameString;
    AlchemistShape, //炼金术士
      ChemistShape, //chemist
      DesignerShape, //裁缝
      CraftsmanShape //工匠
      : integer;
  end;
  pTJobGradeData = ^TJobGradeData;

  TMineAvailData = record
    Name: TNameString;
    GroupName: TNameString;
    MapID: integer;
    PositionCount: integer;
    SettingCount: integer;
    MineArr: array[0..5 - 1] of TNameString;
    MineSArr: array[0..5 - 1] of integer;
    MineEArr: array[0..5 - 1] of integer;
    Desc: TNameString;
  end;
  pTMineAvailData = ^TMineAvailData;

  //ToolRate.sdb
  TToolRateData = record
    Name: TNameString;
    Mine: TNameString;
    Tool: TNameString;
    SFreqArr: array[0..10 - 1] of integer;
    EFreqArr: array[0..10 - 1] of integer;
  end;
  pTToolRateData = ^TToolRateData;
  TCreateMineObject = record
    Name: string[32];
    GroupName: string[32];
    Shape, X, Y: integer;
  end;
  pTCreateMineObject = ^TCreateMineObject;

  TCreateDoorData = record
    Name: string[20];
    DoorName: string[20];
    Shape: Integer;
    MapID, X, Y: Word;
    TMapID, TX, TY: Word;
    Width: Integer;
    NeedAge: Integer;
    NeedItem: string[64];
    NeedQuest: Integer;
    NeedGuild: string[64];
    RegenInterval: Integer;
    ActiveInterval: Integer;
  end;
  PTCreateDoorData = ^TCreateDoorData;

  TGuildNpcData = record
    rName: string[20];
    rX, rY: Integer;
    rSex: Byte;
  end;
  PTGuildNpcData = ^TGuildNpcData;

  TCreateGuildData = record
    Name: string[20];
    Title: string[80];

    MapID: Integer;
    x, y: integer;
    Durability: Integer;
    MaxDurability: Integer; //最大 血量
    FguildMaxNum: integer; //新       上线人数量
    FguildLeve: integer; //新       等级

    rMaxEnegy, rEnegy: integer; //元气

    GuildMagic: string[20];
    MagicExp: integer;
    MakeDate: string[20];
    Sysop: string[20]; //门主
    SubSysop: array[0..3 - 1] of string[20]; //副 门主
    GuildNpc: array[0..5 - 1] of TGuildNpcData;
    GuildWear: array[0..2 - 1] of TAtomItem;
    BasicPoint, AwardPoint: Integer;
    BattleRejectCount: Word;
    ChallengeGuild: string[20];
    ChallengeGuildUser: string[20];
    ChallengeDate: string[20];
    AddLifeTick: Tdatetime; //上次加血时间
  end;
  PTCreateGuildData = ^TCreateGuildData;

  TMakeGuildData = record
    GuildName: string[20];
    Sysop: string[20];
    AgreeChar: array[0..9 - 1] of string[20];
    boAgree: array[0..9 - 1] of Boolean;
  end;
  PTMakeGuildData = ^TMakeGuildData;

  TSpecialWindowSt = record
    rWindow: Byte;
    rAgreeType: Byte;
    rSenderID: Integer;
  end;
  PTSpecialWindowSt = ^TSpecialWindowSt;

  TNpcFunctionData = record
    Index: Integer;
    FuncType: Byte;
    Text: string[32];
    FileName: string[64];
    StartQuest, NextQuest: Integer;
  end;
  PTNpcFunctionData = ^TNpcFunctionData;

  {
  TCreateGateData = record
     mName : string[64];
     index : integer;
     x, y : integer;
     targetx, targety: integer;
     EjectX, EjectY : integer;
     targetserverid : integer;
     shape : integer;
     Interval : integer;
     DurationLifeTick : integer;
     Width : Integer;
     NeedAge : Integer;
     AgeNeedItem : Integer;
     NeedItem : array[0..5] of TCheckItem;
     Quest : Integer;
     QuestNotice : String [128];
     RegenInterval : Integer;
     ActiveInterval : Integer;
     EjectNotice : String [128];
  end;
  PTCreateGateData = ^TCreateGateData;
  }

  TCreateAreaData = record
    mName: string[64];
    ServerID: Integer;
    X, Y: integer;
    TargetServerID: Integer;
    TargetX, TargetY: Integer;
    Width: Integer;
  end;
  PTCreateAreaData = ^TCreateAreaData;

  TItemGenData = record
    Name: string[20];

    ItemName: string[20];
    ItemCount: Integer;

    CreateInterval: Integer;
    RegenInterval: Integer;

    ItemCreateX, ItemCreateY, ItemCreateW: Word;
    ItemRegenX, ItemRegenY, ItemRegenW: Word;
  end;
  PTItemGenData = ^TItemGenData;

  TCreateSoundObjData = record
    Name: string[20];
    SoundName: integer;
    MapID: Integer;
    X, Y: Word;
    PlayInterval: Integer;
  end;
  PTCreateSoundObjData = ^TCreateSoundObjData;

  {
  TGuildNpcData = record
    rName: string [64];
    rIndex : Integer;
    rX, rY : Integer;
  end;
  PTGuildNpcData = ^TGuildNpcData;

  TCreateGuildData = record
    mName : string [64];
    index : integer;
    x, y  : integer;
    Sysop : string [64];
    SubSysop0, SubSysop1, SubSysop2: string [64];
    Durability : integer;
    GuildMagic : string [64];
    MakeDate : string [64];
    MagicExp : integer;
    GuildNpcDataArr : array [0..5-1] of TGuildNpcData;
  end;
  PTCreateGuildData = ^TCreateGuildData;
  }

///////////////////////////////////
//        Server Structure       //
///////////////////////////////////
  TSExChange = record
    rmsg: byte;
    rIcons: array[0..8 - 1] of word;
    rColors: array[0..8 - 1] of byte;
    rCheckLeft, rCheckRight: Boolean;
    rWordString: TWordString; // left name, right name, item name ,,,,
  end;
  PTSExChange = ^TSExChange;

  TSShowInputString = record
    rmsg: byte;
    rInputStringid: LongInt;
    rWordString: TWordString; // CaptionString, ListString,,,,
  end;
  PTSShowInputString = ^TSShowInputString;

  TSShowSpecialWindow = record
    rMsg: Byte;
    rWindow: Byte;
    rKEY1: INTEGER; //可传送 头像
    rKEY2: INTEGER;
    rKey3: integer; //他用
    rCaption: TNameString;
    rWordString: TWordString;
  end;
  PTSShowSpecialWindow = ^TSShowSpecialWindow;

  // saset
  TSHideSpecialWindow = record
    rMsg: Byte;
    rWindow: Byte;
  end;
  PTSHideSpecialWindow = ^TSHideSpecialWindow;

  TSShowMakeGuildWindow = record
    rMsg: Byte;
    rWindow: Byte;
    rSysopName: string[20];
  end;
  PTSShowMakeGuildWindow = ^TSShowMakeGuildWindow;

  TSShowGuildInfoWindow = record
    rMsg: Byte;
    rWindow: Byte;
    rboEdit: Byte; // if 1 for sysop else for others
    rGuildName: string[20];
    rGuildX, rGuildY: Word;
    rCreateDate: string[20];
    rSysop: string[20];
    rSubSysop: array[0..3 - 1] of string[20];
    rGuildNpc: array[0..5 - 1] of string[20];
    rGuildNpcX, rGuildNpcY: array[0..5 - 1] of Word;
    rGuildTitle: string[80];
    rGuildMagic: string[20];
    rGuildAward: string[20];
    rGuildDura: Integer;
  end;
  PTSShowGuildInfoWindow = ^TSShowGuildInfoWindow;

  TSShowGuildWarWindow = record
    rMsg: Byte;
    rWindow: Byte;
  end;
  PTSShowGuildWarWindow = ^TSShowGuildWarWindow;

  TSShowGuildMagicWindow = record
    rMsg: Byte;
    rWindow: Byte;
    rSpeed, rDamageBody: Word; // 100
    rRecovery, rAvoid: Word; // 100
    rDamageHead, rDamageArm, rDamageLeg: Word;
    rArmorBody, rArmorHead, rArmorArm, rArmorLeg: Word; // 228
    rOutPower, rInPower, rMagicPower, rLife: Word; // 80
  end;
  PTSShowGuildMagicWindow = ^TSShowGuildMagicWindow;

  TCGuildMagicData = record
    rMsg: Byte;
    rWindow: Byte;
    rMagicName: string[20];
    rMagicType: Byte;
    // MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP,
  // MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING
    rSpeed, rDamageBody: Word; // 100
    rRecovery, rAvoid: Word; // 100
    rDamageHead, rDamageArm, rDamageLeg: Word;
    rArmorBody, rArmorHead, rArmorArm, rArmorLeg: Word; // 228
    rOutPower, rInPower, rMagicPower, rLife: Word; // 80
  end;
  PTCGuildMagicData = ^TCGuildMagicData;

  TSShowBattleBar = record
    rMsg: Byte;
    rWinType: Byte; // 1 : 备浇1俺 (1魄) 2 : 2俺 (3魄) 3 : 3俺 (5魄)
    rLeftName: array[0..60 - 1] of Char;
    rLeftWin: Byte;
    rLeftPercent: Byte;
    rRightName: array[0..60 - 1] of Char;
    rRightWin: Byte;
    rRightPercent: Byte;
  end;
  PTSShowBattleBar = ^TSShowBattleBar;

  TSShowCenterMsg = record
    rMsg: Byte;
    rColor: Word;
    rtype: byte; //类型
    rText: TWordString;
  end;
  PTSShowCenterMsg = ^TSShowCenterMsg;

  TSCount = record
    rmsg: byte;
    rCountid: LongInt;
    rsourkey: word;
    rdestkey: word;
    rCountCur: LongInt;
    rCountMax: LongInt;
    rCountName: TWordString;
  end;
  PTSCount = ^TSCount;

  TCSelectCount = record
    rmsg: byte;
    rboOk: Boolean;
    rsourkey: word;
    rdestkey: word;
    rCountid: LongInt;
    rCount: LongInt;
  end;
  PTCSelectCount = ^TCSelectCount;

  TCInputString = record
    rmsg: byte;
    rInputStringId: LongInt;
    rSelectedList: TNameString;
    rInputString: TWordString;
  end;
  PTCInputString = ^TCInputString;

  TSReConnect = record
    rmsg: byte;
    rId: TNameString;
    rPass: TNameString;
    rCharName: TNameString; // LendName
    rIpAddr: TNameString; // addr
    rPort: integer; // port
  end;
  PTSReConnect = ^TSReConnect;

  TSConnectThru = record
    rMsg: Byte;
    rIpAddr: TNameString;
    rPort: Integer;
    ryid: integer;
  end;
  PTSConnectThru = ^TSConnectThru;

  TSRainning = record
    rmsg: byte;
    rspeed: integer;
    rCount: integer;
    rOverray: integer;
    rTick: integer;
    rRainType: byte;
  end;
  PTSRainning = ^TSRainning;

  TSMessage = record
    rmsg: byte;
    rkey: word;
    rWordString: TWordString;
  end;
  PTSMessage = ^TSMessage;
  //物品 详细 描述 右点
  {1，图片
2，物品名字
3，品
4，详细描述
5，锁}
  TSitemPro = record
    rmsg: byte;
    rkey: byte; //区分 武功  物品
    rcolor: byte;
    rshape: word; //物品 图片
    rGrade: byte; //品
    rlockState: byte; //新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
    rlocktime: word;
    rSmithingLevel: word; //新 装备等级
    rname: TNameString;
    rWordString: TWordString;
  end;
  pTSitemPro = ^TSitemPro;
  TSWindow = record
    rmsg: byte;
    rwindow: byte;
    rboShow: Boolean;
  end;
  PTSWindow = ^TSWindow;

  TSNewMap = record
    rmsg: byte;
    rMapName: TNameString;
    rCharName: TNameString; //人名字
    rId: LongInt;
    rx, ry: word;
    rObjName: TNameString;
    rTilName: TNameString;
    rRofName: TNameString;
    rMapTitle: TNameString;
  end;
  PTSNewMap = ^TSNewMap;

  TSShow = record
    rmsg: byte;
    rId: LongInt;
    // rNameString:array[0..60 - 1] of byte;
    rdir, rx, ry: word;
    rFeature: TFeature;
    rWordString: TWordString;
  end;
  PTSShow = ^TSShow;

  TSShow_Npc_MONSTER = record
    rmsg: byte;
    rId: LongInt;
    rdir, rx, ry: word;

    rFeature_npc_MONSTER: TFeature_npc_MONSTER;

    rWordString: TWordString;
  end;
  pTSShow_Npc_MONSTER = ^TSShow_Npc_MONSTER;
  TSChangeFeature_Npc_MONSTER = record
    rmsg: byte;
    rId: LongInt;
    rFeature_npc_MONSTER: TFeature_npc_MONSTER;
  end;
  PTSChangeFeature_Npc_MONSTER = ^TSChangeFeature_Npc_MONSTER;

  TSdie_Npc_MONSTER = record
    rmsg: byte;
    rId: LongInt;
    rfeaturestate: TFeatureState;
  end;
  pTSdie_Npc_MONSTER = ^TSdie_Npc_MONSTER;

  // AniItem 010102 ankudo
  TDynamicObjectState = (dos_Closed, dos_Openning, dos_Openned, dos_Scroll);
  TSShowDynamicObject = record
    rmsg: byte;
    rId: LongInt;
    rNameString: TNameString;
    rx, ry: word;
    rShape: word;
    rState: Byte;
    rFrameStart, rFrameEnd: Word;
    rGuardX: array[0..10 - 1] of ShortInt;
    rGuardY: array[0..10 - 1] of ShortInt;
  end;
  PTSShowDynamicObject = ^TSShowDynamicObject;

  TSShowItem = record
    rmsg: byte;
    rId: LongInt;
    rNameString: TNameString;
    rx, ry: word;
    rshape: word;
    rcolor: byte;
    rRace: byte;
  end;
  PTSShowItem = ^TSShowItem;

  TssVirtualObject = record
    rmsg: byte;
    rId: LongInt;
    rNameString: TNameString;
    rx, ry: word;
    Width, Height: word;
    rRace: byte;
  end;
  pTssVirtualObject = ^TssVirtualObject;

  TSShowMonster = record
    rmsg: byte;
    rId: LongInt;
    rNameString: TNameString;
    rdir, rx, ry: word;
    rshape: word;
    rcolor: byte;
  end;
  PTSShowMonster = ^TSShowMonster;

  TSHide = record
    rmsg: byte;
    rId: LongInt;
  end;
  PTSHide = ^TSHide;

  TSTurn = record
    rmsg: byte;
    rId: LongInt;
    rdir, rx, ry: word;
  end;
  PTSTurn = ^TSTurn;

  TSMove = record
    rmsg: byte;
    rId: LongInt;
    rdir, rx, ry: word;
  end;
  PTSMove = ^TSMove;
  TSMagicEffect = record
    rmsg: byte;
    rId: LongInt;
    reffectNum: integer;
    reffecttype: TLightEffectKind;
  end;
  pTSMagicEffect = ^TSMagicEffect;
  TSEffect = record
    rmsg: byte;
    rId: LongInt;
    reffectNum: word;
    reffecttype: TLightEffectKind;
  end;
  pTSEffect = ^TSEffect;

  TSNameColor = record
    rmsg: byte;
    rId: LongInt;
    rNameColor: word;
  end;
  pTSNameColor = ^TSNameColor;
  TSCHANGEMagic = record
    rmsg: byte;
    rId: LongInt;
    rMagictype: word;
    rMagicColorIndex: byte;
    rAttackSpeed: integer;
  end;
  pTSCHANGEMagic = ^TSCHANGEMagic;

  TSSay = record
    rmsg: byte;
    rId: LongInt;
    rkind: byte;
    rWordString: TWordString;
  end;
  PTSSay = ^TSSay;

  TSChatMessage = record
    rmsg: byte;
    rFColor: word;
    rBColor: word;
    rWordString: TWordString;
  end;
  PTSChatMessage = ^TSChatMessage;

  tsLeftText = record
    rmsg: byte;
    rFColor: word;
    rtype: TMsgType;
    rWordString: TWordString;
  end;
  ptsLeftText = ^tsLeftText;

  TSMapObject = record
    rmsg: byte;
    rx: word;
    ry: word;
    rtype: word;
    rWordString: TWordString;
  end;
  pTSMapObject = ^TSMapObject;

  TSChangeFeature = record
    rmsg: byte;
    rId: LongInt;
    rFeature: TFeature;
  end;
  PTSChangeFeature = ^TSChangeFeature;

  TSChangeState = record
    rmsg: byte;
    rId: LongInt;
    rState: byte;
    rFrameStart, rFrameEnd: Word;
  end;
  PTSChangeState = ^TSChangeState;

  TSChangeProperty = record
    rmsg: byte;
    rId: LongInt;
    rWordString: TWordString;
  end;
  PTSChangeProperty = ^TSChangeProperty;

  TSHailFellowChangeProperty = record
    rmsg: byte;
    rkey: byte;
    rstate: byte;
    rx, ry: word;
    rMapName: TNameString;
    rName: TNameString;
  end;
  pTSHailFellowChangeProperty = ^TSHailFellowChangeProperty;
  TSHailFellowbasic = record
    rmsg: byte;
    rkey: byte;
    rName: TNameString;
  end;
  pTSHailFellowbasic = ^TSHailFellowbasic;

  TSkey = record
    rmsg: byte;
    rKEY: array[0..7] of byte;
    rKEY2: array[0..7] of byte;
  end;
  pTSkey = ^TSkey;

  //服务器 和 客户 物品 结构
  TSHaveItem = record
    rmsg: byte;
    rkey: byte;
    rdel: boolean;

  end;
  PTSHaveItem = ^TSHaveItem;

  TSENDUPDATEITEMTYPE = (suitHave, suitWear, suitWearFd);
  TWearItemtype = (witWear, witWeardel, witWearFD, witWearFDdel
    , witWearUser, witWeardelUser, witWearFDUser, witWearFDdelUser);
  TSWearItem = record
    rmsg: byte;
    rkey: byte;
    rtype: TWearItemtype;

  end;
  PTSWearItem = ^TSWearItem;

  TsendMagicType = (smt_DefaultMagic, smt_HaveMagic, smt_MagicAddExp
    , smt_ini, smt_HaveRiseMagic, smt_HaveMysteryMagic);
  TSHaveMagic = record
    rmsg: byte;
    rType: TsendMagicType;
    rkey: byte;
    rdel: boolean;
  end;
  PTSHaveMagic = ^TSHaveMagic;

  TAttribUPDATEType = (aut_rLight, aut_rDark,

    aut_rtalent,
    aut_rGoodChar,
    aut_rBadChar,
    aut_rlucky,
    aut_radaptive,
    aut_rRevival,
    aut_rimmunity,
    aut_rvirtue,
    aut_rhealth,
    aut_rsatiety,
    aut_rpoisoning,
    aut_rheadseak,
    aut_rarmseak,
    aut_rlegseak,
    aut_rAge,
    aut_rCurEnergy, aut_rEnergy,
    aut_rCurInPower, aut_rInPower,
    aut_rCurOutPower, aut_rOutPower,
    aut_rCurMagic, aut_rMagic,
    aut_rCurLife, aut_rLife,

    aut_rCurheadseak,
    aut_rCurarmseak,
    aut_rCurlegseak,
    aut_rCurhealth,
    aut_rCursatiety,
    aut_rCurpoisoning,
    aut_rprestige,
    aut_rprestige_Add
    );

  TSAttribUPDATE = record
    rmsg: byte;
    rType: TAttribUPDATEType;
    rvaluer: integer;
  end;
  pTSAttribUPDATE = ^TSAttribUPDATE;

  TSAttribBase = record
    rmsg: byte;
    rAge: word;
    rCurEnergy, rEnergy: integer;
    rCurInPower, rInPower: word;
    rCurOutPower, rOutPower: word;
    rCurMagic, rMagic: word;
    rCurLife, rLife: word;
  end;
  PTSAttribBase = ^TSAttribBase;

  TSAttribValues = record
    rmsg: byte;
    rLight: word;
    rDark: word;
    rMagic: word;
    rtalent: word;
    rGoodChar: word;
    rBadChar: word;
    rlucky: word;
    radaptive: word; // 利览
    rRevival: word; // 犁积
    rimmunity: word;
    rvirtue: word; // 龋楷瘤扁

    rhealth: word;
    rsatiety: word;
    rpoisoning: word;
    rCurhealth: word;
    rCursatiety: word;
    rCurpoisoning: word;

    rheadseak: word;
    rarmseak: word;
    rlegseak: word;
    rCurheadseak: word;
    rCurarmseak: word;
    rCurlegseak: word;

  end;
  PTSAttribValues = ^TSAttribValues;

  //获取  属性 网络包
  TGET_cmd = record
    rmsg: byte;
    rKEY: byte;
    rKEY2: byte;
    rKEY3: byte;
    rKEY4: byte;
  end;
  PTGET_cmd = ^TGET_cmd;

  TBasicCmd = record
    rmsg: byte;
    rKEY: byte;
    rCMD1: INTEGER;
    rCMD2: INTEGER;
  end;
  pTBasicCmd = ^TBasicCmd;

  Tcharattrib = record
    rmsg: byte;
    rEnergy: integer;
    rEnergyName: TNameString;
    rAttackSpeed: integer;
    rAvoid: integer;
    rAccuracy: integer;
    rRecovery: integer;
    rKeepRecovery: integer;
    rDamageBody: integer;
    rDamageHead: integer;
    rDamageArm: integer;
    rDamageLeg: integer;
    rArmorBody: integer;
    rArmorHead: integer;
    rArmorArm: integer;
    rArmorLeg: integer;
    rInPower: integer;
    rOutPower: integer;
    rMagic: integer;
    rLife: integer;
    rDefaultValue: integer;
    //        rAttribTotal:integer;
    rShoutLevel: TNameString;
  end;
  pTcharattrib = ^Tcharattrib;
  TSAttribFightBasic = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTSAttribFightBasic = ^TSAttribFightBasic;

  TSAttribLife = record
    rmsg: byte;
    rcurLife: word;
  end;
  PTSAttribLife = ^TSAttribLife;

  TSLifeData = record
    rmsg: byte;
    //damage 攻击
    damageBody: word; //身体
    damageHead: word; //头
    damageArm: word; //武器
    damageLeg: word; //腿
    //armor 防御
    armorBody: word;
    armorHead: word;
    armorArm: word;
    armorLeg: word;

    AttackSpeed: word; //攻击速度
    avoid: word; //躲避
    recovery: word; //恢复
    HitArmor: word;
    accuracy: word;
  end;
  pTSLifeData = ^TSLifeData;

  TSEventString = record
    rmsg: byte;
    rKEY: word; //类型
    rWordString: TWordString;
  end;
  PTSEventString = ^TSEventString;

  TSStructed = record
    rmsg: byte;
    rId: LongInt;
    rRace: Byte;
    rpercent: Byte;
  end;
  PTSStructed = ^TSStructed;
  TsGuild = record
    id: integer;
    rJob: byte; //职位
    rage: byte; //年龄
    rONLine: byte; //在线 状况
  end;
  TsGuildList = record
    rmsg: byte;
    rKEY: byte;
    rnum: byte;

  end;
  PTSGuildList = ^TSGuildList;

  TSMovingMagic = record
    rmsg: byte;
    rsid, reid: LongInt; // 金荤恩   , 嘎篮荤恩
    rtx, rty: word; // 档馒瘤 (嘎篮荤恩捞 绝阑版快)
    rMoveingStyle: byte; // 朝扼啊绰 葛剧
    rsf, rmf, ref: byte; // 矫累 朝扼皑 档馒矫 葛剧
    rspeed: byte; // 加档
    rafterimage: byte; // 儡惑
    rafterover: byte; // 儡惑 坷滚饭捞
    rtype: byte; // 0 : default, 1 : 归蓖具青贱

  end;
  PTSMovingMagic = ^TSMovingMagic;

  TSSoundString = record
    rmsg: byte;
    // rHiByte, rLoByte:byte;
    // rSoundName:array[0..12] of byte;
    rsound: word;
    rX, rY: Word;
  end;
  PTSSoundString = ^TSSoundString;

  TSSoundBaseString = record
    rmsg: byte;
    rRoopCount: word;
    rWordString: TWordString;
  end;
  PTSSoundBaseString = ^TSSoundBaseString;

  TSHaveWearItem = record
    rmsg: byte;
    rkey: byte;
    rName: TNameString;
    rColor: byte;
    rShape: word;
  end;
  PTSHaveWearItem = ^TSHaveWearItem;

  TSAttribHeader = record
    rmsg: byte;
    rTrade: TNameString;
    rlevel: byte;
    rexperience: LongInt;
    rnextexperience: LongInt;
    rMoney: Longint;
  end;
  PTSAttribHeader = ^TSAttribHeader;

  TSAttribTail = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTSAttribTail = ^TSAttribTail;

  TSAttribMana = record
    rmsg: byte;
    rcurMana: word;
  end;
  PTSAttribMana = ^TSAttribMana;

  TSAttribMoney = record
    rmsg: byte;
    rMoney: LongInt;
  end;
  PTSAttribMoney = ^TSAttribMoney;

  TSAttribExperience = record
    rmsg: byte;
    rExperience: LongInt;
  end;
  PTSAttribExperience = ^TSAttribExperience;

  TSAttribStem = record
    rmsg: byte;
    rcurStem: word;
  end;
  PTSAttribStem = ^TSAttribStem;

  TSSetTilAndObj = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTSSetTilAndObj = ^TSSetTilAndObj;

  TSHaveItemInfo = record
    rmsg: byte;
    rkey: byte;
    rShape: word;
    rkind: byte;
    rWordString: TWordString;
  end;
  PTSHaveItemInfo = ^TSHaveItemInfo;

  TSHaveMagicInfo = record
    rmsg: byte;
    rkey: byte;
    rtype: byte;
    rLevel: byte;
    rShape: integer;
    rWordString: TWordString;
  end;
  PTSHaveMagicInfo = ^TSHaveMagicInfo;

  TSMotion = record
    rmsg: byte;
    rId: LongInt;
    rmotion: word;
  end;
  PTSMotion = ^TSMotion;
  TSMotion2 = record
    rmsg: byte;
    rId: LongInt;
    rmotion: word;
    rEffectimg: word;
    rEffectColor: byte;
  end;
  pTSMotion2 = ^TSMotion2;

  TSHit = record
    rmsg: byte;
    rid: LongInt;
    rdir: word;
  end;
  PTSHit = ^TSHit;

  TSMagic = record
    rmsg: byte;
    rid: LongInt;
    rdir: word;
  end;
  PTSMagic = ^TSMagic;

  TSMenu = record
    rmsg: byte;
    rid: LongInt;
    rn: byte;
    rtitlecolor: word;
    rselectcolor: word;
    rdisplaytime: word;
    rIcons: array[0..32 - 1] of word;
    rMenuTitle: TNameString;
    rWordString: TWordString;
  end;
  PTSMenu = ^TSMenu;

  TSSetPosition = record
    rmsg: byte;
    rid: LongInt;
    rdir: word;
    rx: word;
    ry: word;
  end;
  PTSSetPosition = ^TSSetPosition;

  TSSendDelay = record
    rmsg: byte;
    rsenddelay: word;
  end;
  PTSSendDelay = ^TSSendDelay;

  TSScrollText = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTSScrollText = ^TSScrollText;

  TSReEnterAddress = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTSReEnterAddress = ^TSReEnterAddress;

  TSLogItem = record
    rmsg: byte;
    rkey: byte;
    rbodel: boolean;

  end;
  PTSLogItem = ^TSLogItem;

  TSNPCItem = record
    rmsg: byte;
    rkey: byte;
    rName: TNameString;
    rCount: word;
    rColor: byte;
    rShape: word;
    rPrice: integer; //价格

  end;
  PTSNPCItem = ^TSNPCItem;

  TSNPCSAY = record
    rmsg: byte;
    rkey: byte;
    rWordString: TWordString;
  end;
  PTSNPCSAY = ^TSNPCSAY;

  TSCheck = record
    rMsg: Byte;
    rCheck: Byte; // 1捞搁 甘颇老 眉农, 2搁 努扼捞攫飘 Tick 眉农
  end;
  PTSCheck = ^TSCheck;

  TWordInfoString = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTWordInfoString = ^TWordInfoString;

  ///////////////////////////////////
  //        Client Structure       //
  ///////////////////////////////////

  TCKey = record
    rmsg: byte;
    rkey: word;
  end;
  PTCKey = ^TCKey;

  TCVer = record
    rmsg: byte;
    rVer: word;
    rNation: word;
  end;
  PTCVer = ^TCVer;

  TCIdPass = record
    rmsg: byte;
    rId: TNameString;
    rPass: TNameString;
    ryid: integer;
  end;
  PTCIdPass = ^TCIdPass;

  TCIdPassAzacom = record
    rmsg: byte;
    rId: TNameString;
    rPass: TNameString;
    rAzaComid: TNameString;
  end;
  PTCIdPassAzaCom = ^TCIdPassAzaCom;

  TCCreateIdPass = record
    rmsg: byte;
    rid: TNameString;
    rPass: TNameString;
    rName: TNameString;
    rTelephone: TNameString;
    rBirth: TNameString;
  end;
  PTCCreateIdPass = ^TCCreateIdPass;

  TCCreateIdPass2 = record
    rmsg: byte;
    rid: TNameString;
    rPass: TNameString;
    rName: TNameString;
    rMasterKey: TNameString;
    rNativeNumber: TNameString;
  end;
  PTCCreateIdPass2 = ^TCCreateIdPass2;

  TCCreateIdPass3 = record
    rMsg: Byte;
    rID: string[12];
    rPass: string[12];
    rName: string[12];
    rNativeNumber: string[18];
    rMasterKey: string[12];
    rEmail: string[32];
    rPhone: string[15];
    rParentName: string[12];
    rParentNativeNumber: string[18];
  end;
  PTCCreateIDPass3 = ^TCCreateIDPass3;

  TCChangePassWord = record
    rmsg: byte;
    rNewPass: TNameString;
  end;
  PTCChangePassWord = ^TCChangePassWord;

  TCChangeCharName = record
    rmsg: byte;
    rOldName: string[20];
    rOldServerName: string[20];
    rNewName: string[20];
  end;
  pTCChangeCharName = ^TCChangeCharName;
  //修改页面处修改的密码
  TCUpdatePassword = record
    rMsg: Byte;
    rID: string[12];
    rPass: string[12];
    rNewPass: string[12];
    rEmail: string[32];
    rMasterKey: string[12];
  end;
  PTCUpdatePassword = ^TCUpdatePassword;

  //找回密码
  TFindPassword = record
    rMsg: Byte;
    rID: string[12];
    rEmail: string[32];
    rMasterKey: string[12];
  end;

  PTFindPassword = ^TFindPassword;

  TCCreateChar = record
    rmsg: byte;
    rchar: TNameString;
    rSex: byte;
    rVillage: TNameString;
    rServer: TNameString;
  end;
  PTCCreateChar = ^TCCreateChar;

  TCDeleteChar = record
    rmsg: byte;
    rchar: TNameString;
    rServer: TNameString;
  end;
  PTCDeleteChar = ^TCDeleteChar;

  TCSelectChar = record
    rmsg: byte;
    rchar: TNameString;
    rServer: TNameString;
  end;
  PTCSelectChar = ^TCSelectChar;

  TCSay = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTCSay = ^TCSay;
  TCGuild = record
    rmsg: byte;
    rkey: byte;
    rWordString: TWordString;
  end;
  pTCGuild = ^TCGuild;

  TCNPC = record
    rmsg: byte;
    rKEY: byte;
    rItemKey: integer;
    rnum: integer;
  end;
  pTCNPC = ^TCNPC;

  TCPassEtc = record
    rmsg: byte;
    rKEY: byte;
    rPass: TNameString;
  end;
  pTCPassEtc = ^TCPassEtc;

  TCMove = record
    rmsg: byte;
    rdir: word;
    rx, ry: word;
    rmmAnsTick: integer;
  end;
  PTCMove = ^TCMove;
  TCdrink = record
    rmsg: byte;
    rclickedId: LongInt;
    rX, rY: word;
  end;
  PTCdrink = ^TCdrink;

  TCClick = record
    rmsg: byte;
    rwindow: byte;
    rShift: TShiftState;
    rclickedId: LongInt;
    rkey: word;
  end;
  PTCClick = ^TCClick;

  TCDragDrop = record
    rmsg: byte;
    rsourwindow: byte;
    rdestwindow: byte;
    rsourId: LongInt;
    rdestId: LongInt;
    rsx, rsy: word;
    rdx, rdy: word;
    rsourkey: word;
    rdestkey: word;
  end;
  PTCDragDrop = ^TCDragDrop;

  TCHit = record
    rmsg: byte;
    rkey: word;
    rtid: integer;
    // rtx, rty:word;
  end;
  PTCHit = ^TCHit;

  TCWindowConfirm = record
    rMsg: Byte;
    rWindow: Word;
    rboCheck: Boolean;
    rButton: Byte;
    rText: string[30];
  end;
  PTCWindowConfirm = ^TCWindowConfirm;

  TCGiveItem = record
    rmsg: byte;
    rkey: word;
    rid: LongInt;
  end;
  PTCGiveItem = ^TCGiveItem;

  TCChangeItem = record
    rmsg: byte;
    rfir, rsec: word;
  end;
  PTCChangeItem = ^TCChangeItem;

  TCChangeMagic = record
    rmsg: byte;
    rfir, rsec: word;
  end;
  PTCChangeMagic = ^TCChangeMagic;

  TCMouseEvent = record
    rmsg: byte;
    revent: array[0..10 - 1] of integer;
  end;
  PTCMouseEvent = ^TCMouseEvent;

  TCCheck = record
    rMsg: Byte;
    rCheck: Byte;
    rTick: Integer;
    // rCheck啊 1捞搁 rTick = 0 (甘颇老绝澜) or 1 (甘颇老乐澜)
    // rCheck啊 2捞搁 rTick = timeGetTime();
  end;
  PTCCheck = ^TCCheck;

  TCMakeGuildData = record
    rMsg: Byte;
    rGuildName: string[20];
    rSubSysop: array[0..3 - 1] of string[20];
    rAgreeChar: array[0..6 - 1] of string[20];
  end;
  PTCMakeGuildData = ^TCMakeGuildData;

  TCGuildInfoData = record
    rMsg: Byte;
    rGuildName: string[20];
    rGuildX, rGuildY: Word;
    rCreateDate: string[20];
    rSysop: string[20];
    rSubSysop: array[0..3 - 1] of string[20];
    rGuildNpc: array[0..5 - 1] of string[20];
    rGuildNpcX, rGuildNpcY: array[0..5 - 1] of Word;
    rGuildTitle: string[80];
    rGuildMagic: string[20];
    rGuildAward: string[20];
    rGuildDura: Integer;
    rGuildWear1: string[40];
    rGuildWear2: string[40];
  end;
  PTCGuildInfoData = ^TCGuildInfoData;

  TCGuildWarData = record
    rMsg: Byte;
    rWGName: string[20];
    rWGSysop: string[20];
    rTime: Byte;
  end;
  PTCGuildWarData = ^TCGuildWarData;

  TSNetState = record
    rMsg: Byte;
    rID: Integer;
    rMadeTick: Integer;
  end;
  PTSNetState = ^TSNetState;

  TCNetState = record
    rMsg: Byte;
    rID: Integer;
    rMadeTick: Integer;
    rCurTick: Integer;
  end;
  PTCNetState = ^TCNetState;

  /////////    FSSockM SocketFunction    //////////////

  TSocketSendFunction = procedure(cnt: integer; pb: pbyte) of object;

  // LoginDb Type
  TGMGuildData = record
    rmsg: byte;
    rGuildId: integer;
    rboAllow: Boolean;
    rGuildName: string[20];
    rSysopName: string[20];
  end;
  PTGMGuildData = ^TGMGuildData;

  TGMData = record
    rmsg: byte;
    rLogInId: string[20];
    rLogInPass: string[20];
    rCharName: string[20];
    rWordString: TWordString;
  end;
  PTGMData = ^TGMData;

  TLeaveData = record
    reventTick: integer;
    rboSendSaveAndClose: Boolean;
    GMD: TGMData;
  end;
  PTLeaveData = ^TLeaveData;

  ///////////////    udp type   ////////////////

  TStringData = record
    rmsg: byte;
    rWordString: TWordString;
  end;
  PTStringData = ^TStringData;

  {const
      PM_NONE         = 0;
      PM_CHECKPAID    = 1;
      PM_CHECKRESULT  = 2;
      PM_CHECKPAID2   = 3;
     }
type
  TPDData = record
    rmsg: byte;
    rConId: integer;
    rLoginId: string[20];
    rIpaddr: string[20];
    rRemainDay: integer;
    rboTimePay: Boolean;
    rSenderPort: integer;
  end;
  PTPDData = ^TPDData;

  TPDData2 = record
    rmsg: byte;
    rConId: integer;
    rLoginId: string[20];
    rIpaddr: string[20];
    rRemainDay: integer;
    rboTimePay: Boolean;
    rSenderPort: integer;
    rMakeDate: string[20];
  end;
  PTPDData2 = ^TPDData2;

  ////////////////////////////////////
  // Game Server and Notice Server
  ////////////////////////////////////
const
  GNM_NONE = 0;
  GNM_INUSER = 1;
  GNM_OUTUSER = 2;
  GNM_ALLCLEAR = 3;

  NGM_NONE = 0;
  NGM_REQUESTCLOSE = 1;
  NGM_REQUESTALLUSER = 2;

  // Login Server Message
{  LG_INSERT       = 0;
  LG_SELECT       = 1;
  LG_DELETE       = 2;
  LG_UPDATE       = 3;
 }
  // DB Server Message
  DB_INSERT = 0;
  DB_SELECT = 1;
  DB_DELETE = 2;
  DB_UPDATE = 3;
  DB_LOCK = 4;
  DB_UNLOCK = 5;
  DB_CONNECTTYPE = 6;
  DB_ITEMSELECT = 7;
  DB_ITEMUPDATE = 8;

  DB_Email = 10;
  DB_Auction = 11;

  DB_LG_INSERT = 12;
  DB_LG_SELECT = 13;
  DB_LG_DELETE = 14;
  DB_LG_UPDATE = 15;

  // DB_New_Type_Email = 1;
   // Game Server Message
  GM_CONNECT = 0;
  GM_DISCONNECT = 1;
  GM_SENDUSERDATA = 2;
  GM_SENDGAMEDATA = 3;
  GM_DUPLICATE = 4;
  GM_SENDALL = 5;
  GM_UNIQUEVALUE = 6;
  GM_CLIENT = 7; //发送到客户端
  GM_GATE = 8; //发送到GATE
  GM_BA = 9; //发送到GATE
  GM_PING = 10;

  // Balance Server Message
  BM_GATEINFO = 0;
  BM_Exequatur = 1;

  DB_OK = 0;
  DB_ERR = 1;
  DB_ERR_NOTFOUND = 2;
  DB_ERR_DUPLICATE = 3; //此人物名称已被使用
  DB_ERR_IO = 4; //发生I/O错误
  DB_ERR_INVALIDDATA = 5; //此为不适用的名称
  DB_ERR_NOTENOUGHSPACE = 6; //人物资料已满，无法再建立

  MapobjectNpc = 1;
  MapobjectONE = 2;
  MapobjectGate = 3;
  MapobjectUserProcession = 4;

  EventString_Magic = 1;
  EventString_Magic_Attrib = 2;
  EventString_Attrib = 3;

  Email_INSERT = 0;
  Email_SELECT = 1;
  Email_DELETE = 2;
  Email_UPDATE = 3;
  Email_SELECTLoad = 4;
  Email_RegNameINSERT = 5;
  Email_RegNameSELECT = 6;

  Auction_INSERT = 0;
  Auction_SELECT = 1;
  Auction_DELETE = 2;
  Auction_UPDATE = 3;
  Auction_SELECTLoad = 4;
  Auction_SELECTAllName = 5;
type
  TGateInfo = record
    bofull: Boolean; //满员
    boChecked: Boolean; //开放
    RemoteIP: string[20];
    RemotePort: Integer;
    UserCount: Integer;
    ReceiveTick: Integer;
  end;
  pTGateInfo = ^TGateInfo;

  TExequaturdata = record
    rid: integer; //验证ID
    rname: string[32];
    rpassword: string[32];
    rTime: integer;
  end;
  pTExequaturdata = ^TExequaturdata;

  TBMExequatur = record
    state: boolean;
  end;
  PTBMExequatur = ^TBMExequatur;

  TConnectInfo = record
    RemoteIP: string;
    RemotePort: Integer;
    LocalPort: Integer;
  end;

  TNoticeData = record
    rMsg: Byte;
    rLoginID: string[20];
    rCharName: string[20];
    rIpAddr: string[20];
    rPaidType: TPaidType;
    rCode: Byte;
  end;
  PTNoticeData = ^TNoticeData;

  TBalanceData = record
    rMsg: Byte;
    rIpAddr: string[20]; //array[0..20 - 1] of char;
    rPort: Integer;
    rUserCount: Integer;
  end;
  PTBalanceData = ^TBalanceData;

  //-----------2009.9.7新增------------
  TBoothItemData = record
    rKey: byte; //背包位置
    rPrice: integer;
    rCount: word;
  end;
  PTBoothItemData = ^TBoothItemData;

  TBoothItemDataArr = array[0..11] of TBoothItemData;

  TBoothData = record
    rMsg: byte;
    rType: byte;
    rBoothName: string[32];
    BuyArr: TBoothItemDataArr;
    SellArr: TBoothItemDataArr;
  end;
  PTBoothData = ^TBoothData;
  //--------------------------------------

  TComData = record
    Size: Integer;
    Data: array[0..deftype_MAX_PACK_SIZE - 1] of Byte;
  end;
  PTComData = ^TComData;

  TWordComData = record
    Size: Word;
    Data: array[0..deftype_MAX_PACK_SIZE - 1] of Byte;
  end;
  PTWordComData = ^TWordComData;
  //包基本格式
  TPacketData = record
    PacketSize: Word;
    RequestID: Integer;
    RequestMsg: Byte;
    ResultCode: Byte;
    Data: TWordComData; //array[0..uPackets_MAX_PACKET_SIZE - 1] of byte;
  end;
  PTPacketData = ^TPacketData;

  TPackType = (_pt_repeat, _pt_ok);
  TCCPack = record
    msg: byte;
    rid: integer;
    rtype: TPackType;
  end;
  pTCCPack = ^TCCPack;

  TWordComDataPack = record
    rver: integer;
    rid: integer;
    rlen: integer;
    rbuf: TWordComData;
  end;
  pTWordComDataPack = ^TWordComDataPack;
  TGuildUserData = record
    rid: integer; //ID
    rName: string[32]; //名字
    rGradeName: string[32]; //封号
    rLastDay: integer; //持续 天  入会 开始
    rage: integer; //年龄
    ronline: boolean; //在线状况
    rjob: integer; //职位
  end;
  PTGuildUserData = ^TGuildUserData;

  ItemTextType = (ittWearItemText, ittWearItemTextFD, ittWearItemTextUser,
    ittWearItemTextFDUser);

  TitemTextdata = record
    rname: string[64];
    rdesc: string[255];
  end;
  pTitemTextdata = ^TitemTextdata;
function PaidtypeTostr(rPaidType: TPaidType): string;
function strTOpaidtype(str: string): TPaidType;

procedure EnCryption(buf: pointer; asize: integer);
procedure DeCryption(buf: pointer; asize: integer);

function TMagicDataToStr(aitem: TMagicData): string;
function ColorSysToDxColor(aColor: dword): word;
function WinRGB(r, g, b: word): word;
procedure WordComData_ADDString(var adata: TWordComData; astr: string);
function WordComData_GETString(var adata: TWordComData; var id: integer):
  string;

procedure WordComData_ADDStringPro(var adata: TWordComData; astr: string);
function WordComData_GETStringPro(var adata: TWordComData; var id: integer):
  string;

procedure WordComData_ADDbyte(var adata: TWordComData; ap: byte);
procedure WordComData_ADDword(var adata: TWordComData; ap: word);
procedure WordComData_ADDdword(var adata: TWordComData; ap: dword);
procedure WordComData_ADDdatetime(var adata: TWordComData; ap: tdatetime);

function WordComData_GETword(var adata: TWordComData; var id: integer): integer;
function WordComData_GETbyte(var adata: TWordComData; var id: integer): integer;
function WordComData_GETdword(var adata: TWordComData; var id: integer):
  integer;
function WordComData_GetDatetime(var adata: TWordComData; var id: integer):
  Tdatetime;
procedure WordComData_ADDBuf(var adata: TWordComData; ap: pointer; alen:
  integer);
function WordComData_GETbuf(var adata: TWordComData; var id: integer; abuf:
  pointer; abufLen: integer): integer;

procedure TItemDataToTWordComData(var Source: TItemData; var ComData:
  TWordComData);
procedure TWordComDataToTItemData(var i: integer; var ComData: TWordComData; var
  aitem: TItemData);
procedure TMagicDataToTWordComData(var Source: TMagicData; var ComData:
  TWordComData);
procedure TWordComDataToTMagicData(var i: integer; var ComData: TWordComData; var
  aitem: TMagicData);

function StringReplaceGame(s: string): string;
function IsGameStr(s: string): boolean;

function Get10000To100(avalue: integer): string;
function GetDBErrorText(aid: integer): string;

implementation

uses StrUtils;

function IsGameStr(s: string): boolean;
begin
  result := false;
  if Pos('''', s) > 0 then
    exit;
  result := true;
end;

function StringReplaceGame(s: string): string;
begin
  // s := StringReplace(s, ';', '；', [rfReplaceAll]);
  s := StringReplace(s, '''', '’', [rfReplaceAll]);
  // s := StringReplace(s, '-', '—', [rfReplaceAll]);
  // s := StringReplace(s, '+', '＋', [rfReplaceAll]);
  result := s;
end;

function WordComData_GetDatetime(var adata: TWordComData; var id: integer):
  Tdatetime;
var
  alen: integer;
  tt: PDateTime;
begin
  result := 0;
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := sizeof(TDateTime);
  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[id];
  id := id + alen;
  result := tt^;
end;

procedure WordComData_AddDatetime(var adata: TWordComData; ap: Tdatetime);
var
  alen: integer;
  tt: PDateTime;
begin
  alen := sizeof(TDateTime);
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[adata.Size];
  tt^ := ap;
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDbyte(var adata: TWordComData; ap: byte);
var
  alen: integer;
  tt: pbyte;
begin
  alen := 1;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[adata.Size];
  tt^ := ap;
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDword(var adata: TWordComData; ap: word);
var
  alen: integer;
  tt: pword;
begin
  alen := 2;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[adata.Size];
  tt^ := ap;
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDBuf(var adata: TWordComData; ap: pointer; alen:
  integer);
var
  tt: pointer;
begin
  if alen <= 0 then
    exit;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  WordComData_ADDword(adata, alen); //增加 长度
  tt := @adata.Data[adata.Size];
  copymemory(tt, ap, alen);
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDdword(var adata: TWordComData; ap: dword);
var
  alen: integer;
  tt: pdword;
begin
  alen := 4;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[adata.Size];
  tt^ := ap;
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDString(var adata: TWordComData; astr: string);
var
  alen: integer;
begin
  alen := length(astr);
  if (alen < 0) or (alen > 255) then
    alen := 0;
  if (adata.Size + 1) > high(adata.Data) then
    exit;
  adata.Data[adata.Size] := alen;
  adata.Size := adata.Size + 1;
  if alen = 0 then
    exit;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  move(astr[1], adata.Data[adata.Size], alen);
  adata.Size := adata.Size + alen;
end;

procedure WordComData_ADDStringPro(var adata: TWordComData; astr: string);
var
  alen: integer;
begin
  alen := length(astr);
  if (alen < 0) or (alen > 65535) then
    alen := 0;
  if (adata.Size + 2) > high(adata.Data) then
    exit;

  WordComData_ADDword(adata, alen);
  if alen = 0 then
    exit;
  if (adata.Size + alen) > high(adata.Data) then
    exit;
  move(astr[1], adata.Data[adata.Size], alen);
  adata.Size := adata.Size + alen;
end;

function WordComData_GETbyte(var adata: TWordComData; var id: integer): integer;
var
  alen: integer;
  tt: pbyte;
begin
  result := 0;
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := 1;
  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[id];
  id := id + alen;
  result := tt^;
end;

function WordComData_GETword(var adata: TWordComData; var id: integer): integer;
var
  alen: integer;
  tt: pword;
begin
  result := 0;
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := 2;
  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[id];
  id := id + alen;
  result := tt^;
end;

function WordComData_GETbuf(var adata: TWordComData; var id: integer; abuf:
  pointer; abufLen: integer): integer;
var
  alen: integer;
  tt: pointer;
begin
  result := 0;
  if (id < 0) or (id > high(adata.Data)) then
    exit;

  alen := WordComData_GETword(adata, id);
  if (alen <= 0) or (alen > abufLen) then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[id];
  copymemory(abuf, tt, alen);
  id := id + alen;
  result := alen;
end;

function WordComData_GETdword(var adata: TWordComData; var id: integer):
  integer;
var
  alen: integer;
  tt: pdword;
begin
  result := 0;
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := 4;
  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  tt := @adata.Data[id];
  id := id + alen;
  result := tt^;
end;

function WordComData_GETString(var adata: TWordComData; var id: integer):
  string;
var
  alen: integer;
begin
  result := '';
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := adata.Data[id];
  id := id + 1;
  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  setlength(result, alen);
  move(adata.Data[id], result[1], alen);
  id := id + alen;
end;

procedure EnCryption(buf: pointer; asize: integer);
var
  i: integer;
  pb: pbyte;
  bb: byte;
begin
  pb := buf;
  for i := 1 to asize do
  begin
    bb := pb^;
    asm
          rol bb,3
    end;
    pb^ := bb;
    inc(pb);
  end;

end;

procedure DeCryption(buf: pointer; asize: integer);
var
  i: integer;
  pb: pbyte;
  bb: byte;
begin
  pb := buf;
  for i := 1 to asize do
  begin
    bb := pb^;
    asm
          ror bb,3
    end;
    pb^ := bb;
    inc(pb);
  end;

end;

function WordComData_GETStringPro(var adata: TWordComData; var id: integer):
  string;
var
  alen: integer;
begin
  result := '';
  if (id < 0) or (id > high(adata.Data)) then
    exit;
  alen := WordComData_GETword(adata, id);

  if alen <= 0 then
    exit;
  if (id + alen) > high(adata.Data) then
    exit;
  setlength(result, alen);
  move(adata.Data[id], result[1], alen);
  id := id + alen;
end;

function WinRGB(r, g, b: word): word;
begin
  Result := b + (g shl 5) + (r shl 10);
end;

function ColorSysToDxColor(aColor: dword): word;
begin
  result := WinRGB(GetRValue(acolor) div 8, GetGValue(acolor) div 8,
    GetBValue(acolor) div 8);
end;

procedure TItemDataToTWordComData(var Source: TItemData; var ComData:
  TWordComData);

  function isitem(var aLifeData: TLifeData): boolean;
  begin
    result := true;
    if (aLifeData.damageBody <> 0)
      or (aLifeData.damageHead <> 0)
      or (aLifeData.damageArm <> 0)
      or (aLifeData.damageLeg <> 0)

    or (aLifeData.armorBody <> 0)
      or (aLifeData.armorHead <> 0)
      or (aLifeData.armorArm <> 0)
      or (aLifeData.armorLeg <> 0)

    or (aLifeData.AttackSpeed <> 0)
      or (aLifeData.avoid <> 0)
      or (aLifeData.recovery <> 0)
      or (aLifeData.accuracy <> 0) then
      exit;

    result := false;
  end;

  procedure _addTLifeData(var aLifeData: TLifeData);
  var
    aState: TLifeDataDownState;
  begin
    aState := [];
    if (aLifeData.damageBody <> 0) then
      aState := aState + [_ldds_damageBody];
    if (aLifeData.damageHead <> 0) then
      aState := aState + [_ldds_damageHead];
    if (aLifeData.damageArm <> 0) then
      aState := aState + [_ldds_damageArm];
    if (aLifeData.damageLeg <> 0) then
      aState := aState + [_ldds_damageLeg];

    if (aLifeData.armorBody <> 0) then
      aState := aState + [_ldds_armorBody];
    if (aLifeData.armorHead <> 0) then
      aState := aState + [_ldds_armorHead];
    if (aLifeData.armorArm <> 0) then
      aState := aState + [_ldds_armorArm];
    if (aLifeData.armorLeg <> 0) then
      aState := aState + [_ldds_armorLeg];

    if (aLifeData.AttackSpeed <> 0) then
      aState := aState + [_ldds_AttackSpeed];
    if (aLifeData.avoid <> 0) then
      aState := aState + [_ldds_avoid];
    if (aLifeData.recovery <> 0) then
      aState := aState + [_ldds_recovery];
    if (aLifeData.accuracy <> 0) then
      aState := aState + [_ldds_accuracy];
    // copymemory(@ComData.Data[ComData.Size], @aState, sizeof(TLifeDataDownState));
     //ComData.Size := ComData.Size + sizeof(TLifeDataDownState);
    WordComData_ADDBuf(ComData, @aState, sizeof(TLifeDataDownState));

    if (aLifeData.damageBody <> 0) then
      WordComData_ADDword(ComData, aLifeData.damageBody);
    if (aLifeData.damageHead <> 0) then
      WordComData_ADDword(ComData, aLifeData.damageHead);
    if (aLifeData.damageArm <> 0) then
      WordComData_ADDword(ComData, aLifeData.damageArm);
    if (aLifeData.damageLeg <> 0) then
      WordComData_ADDword(ComData, aLifeData.damageLeg);

    if (aLifeData.armorBody <> 0) then
      WordComData_ADDword(ComData, aLifeData.armorBody);
    if (aLifeData.armorHead <> 0) then
      WordComData_ADDword(ComData, aLifeData.armorHead);
    if (aLifeData.armorArm <> 0) then
      WordComData_ADDword(ComData, aLifeData.armorArm);
    if (aLifeData.armorLeg <> 0) then
      WordComData_ADDword(ComData, aLifeData.armorLeg);

    if (aLifeData.AttackSpeed <> 0) then
      WordComData_ADDword(ComData, aLifeData.AttackSpeed);
    if (aLifeData.avoid <> 0) then
      WordComData_ADDword(ComData, aLifeData.avoid);
    if (aLifeData.recovery <> 0) then
      WordComData_ADDword(ComData, aLifeData.recovery);
    if (aLifeData.accuracy <> 0) then
      WordComData_ADDword(ComData, aLifeData.accuracy);

  end;
begin
  WordComData_ADDString(ComData, Source.rName);
  WordComData_ADDString(ComData, Source.rViewName);
  WordComData_ADDbyte(ComData, Source.rKind);
  WordComData_ADDdword(ComData, Source.rNameColor);

  WordComData_ADDbyte(ComData, Source.rSex);
  WordComData_ADDword(ComData, Source.rShape);
  WordComData_ADDbyte(ComData, Source.rcolor);
  WordComData_ADDdword(ComData, Source.rPrice);
  WordComData_ADDdword(ComData, Source.rCount);

  WordComData_ADDbyte(ComData, Source.rlockState);
  //新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
  if Source.rlockState <> 0 then
    WordComData_ADDword(ComData, Source.rlocktime); //新 解锁状态 时间

  WordComData_ADDbyte(ComData, byte(Source.rboDouble)); //重叠

  WordComData_ADDbyte(ComData, byte(Source.rboNotTrade)); //新开关 NPC交易
  WordComData_ADDbyte(ComData, byte(Source.rboNotExchange)); //新开关 玩家交换
  WordComData_ADDbyte(ComData, byte(Source.rboNotDrop)); //新开关 丢弃地上
  WordComData_ADDbyte(ComData, byte(Source.rboNotSSamzie)); //新开关 存放福袋
  //    WordComData_ADDbyte(ComData, byte(Source.rboQuest));                        //

  WordComData_ADDbyte(ComData, byte(Source.rboDurability)); //新开关 消耗持久
  if Source.rboDurability then
  begin
    WordComData_ADDdword(ComData, Source.rDurability); //持久
    WordComData_ADDdword(ComData, Source.rCurDurability); //当前持久
    WordComData_ADDbyte(ComData, byte(Source.rboNOTRepair)); //新开关 是否可修理
  end;

  WordComData_ADDbyte(ComData, byte(Source.rboTimeMode)); //新开关 时间模式
  if Source.rboTimeMode then
    WordComData_ADDdatetime(ComData, Source.rDateTime); //时间
  WordComData_ADDbyte(ComData, byte(Source.rSpecialKind));

  case Source.rKind of
    //        ITEM_KIND_WEARITEM2                                                     //24号
    ITEM_KIND_WEARITEM //6号
    // , ITEM_KIND_WEARITEM_29                                             //29 有头盔是29
    , ITEM_KIND_WEARITEM_GUILD //60号  掉持久
      , ITEM_KIND_WEARITEM_FD:
      begin
        WordComData_ADDString(ComData, (Source.rcreatename));
        WordComData_ADDbyte(ComData, Source.rGrade); //新-品介
        WordComData_ADDbyte(ComData, Source.rWearArr);
        //(装备部位) 9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕
        WordComData_ADDbyte(ComData, Source.rWearShape); //装备后 外观图片
        WordComData_ADDbyte(ComData, byte(Source.boUpgrade)); //新 (允许升级)
        WordComData_ADDbyte(ComData, Source.MaxUpgrade); //新 (最大升级别)

        WordComData_ADDword(ComData, Source.rSmithingLevel);
        //精练等级   //新 装备等级
        WordComData_ADDword(ComData, Source.rAttach); //新 附加属性
        WordComData_ADDbyte(ComData, byte(Source.rboColoring)); //(允许染色)
        WordComData_ADDbyte(ComData, (Source.rStarLevel)); //(星级)
        WordComData_ADDbyte(ComData, byte(Source.rboBlueprint)); //(设计图)
        if Source.rboBlueprint then
        begin

          WordComData_ADDString(ComData, Source.rMaterial.NameArr[0]);
          WordComData_ADDbyte(ComData, Source.rMaterial.CountArr[0]);
          WordComData_ADDString(ComData, Source.rMaterial.NameArr[1]);
          WordComData_ADDbyte(ComData, Source.rMaterial.CountArr[1]);
          WordComData_ADDString(ComData, Source.rMaterial.NameArr[2]);
          WordComData_ADDbyte(ComData, Source.rMaterial.CountArr[2]);
          WordComData_ADDString(ComData, Source.rMaterial.NameArr[3]);
          WordComData_ADDbyte(ComData, Source.rMaterial.CountArr[3]);
        end;
        //                WordComData_ADDbyte(ComData, byte(Source.rboPrestige));         //
        //特殊等级
        WordComData_ADDdword(ComData, Source.rSpecialLevel); //
      end;

  end;
  case Source.rKind of
    121: //宝石
      begin
        _addTLifeData(Source.rLifeDataBasic);
      end;
    //        ITEM_KIND_WEARITEM2                                                     //24号
    ITEM_KIND_WEARITEM //6号
    //        , ITEM_KIND_WEARITEM_29                                             //29 有头盔是29
    , ITEM_KIND_WEARITEM_GUILD //60号  掉持久
      :
      begin
        _addTLifeData(Source.rLifeDataBasic); //基础
        _addTLifeData(Source.rLifeDataLevel); //精炼
        _addTLifeData(Source.rLifeDataAttach); //附加
        _addTLifeData(Source.rLifeDataSetting); //镶嵌
        //套装
        WordComData_ADDbyte(ComData, Source.rSuitID);
        if Source.rSuitID > 0 then _addTLifeData(Source.rLifeDataSuit);

        //镶嵌
        WordComData_ADDbyte(ComData, Source.rSetting.rsettingcount);
        if Source.rSetting.rsettingcount > 0 then
        begin
          if Source.rSetting.rsettingcount >= 1 then
            WordComData_ADDString(ComData, Source.rSetting.rsetting1);
          if Source.rSetting.rsettingcount >= 2 then
            WordComData_ADDString(ComData, Source.rSetting.rsetting2);
          if Source.rSetting.rsettingcount >= 3 then
            WordComData_ADDString(ComData, Source.rSetting.rsetting3);
          if Source.rSetting.rsettingcount >= 4 then
            WordComData_ADDString(ComData, Source.rSetting.rsetting4);

        end;
        //坚定
        WordComData_ADDbyte(ComData, byte(Source.rboident));
      end;
  end;
end;

procedure TWordComDataToTItemData(var i: integer; var ComData: TWordComData; var
  aitem: TItemData);
{var
    t1: integer;
    }
  procedure _getTLifeData(var aLifeData: TLifeData);
  var
    aState: TLifeDataDownState;
  begin
    WordComData_GETbuf(ComData, i, @aState, sizeof(TLifeDataDownState));
    if _ldds_damageBody in aState then
      aLifeData.damageBody := WordComData_GETword(ComData, i);
    if _ldds_damageHead in aState then
      aLifeData.damageHead := WordComData_GETword(ComData, i);
    if _ldds_damageArm in aState then
      aLifeData.damageArm := WordComData_GETword(ComData, i);
    if _ldds_damageLeg in aState then
      aLifeData.damageLeg := WordComData_GETword(ComData, i);

    if _ldds_armorBody in aState then
      aLifeData.armorBody := WordComData_GETword(ComData, i);
    if _ldds_armorHead in aState then
      aLifeData.armorHead := WordComData_GETword(ComData, i);
    if _ldds_armorArm in aState then
      aLifeData.armorArm := WordComData_GETword(ComData, i);
    if _ldds_armorLeg in aState then
      aLifeData.armorLeg := WordComData_GETword(ComData, i);

    if _ldds_AttackSpeed in aState then
      aLifeData.AttackSpeed := Smallint(WordComData_GETword(ComData, i));
    if _ldds_avoid in aState then
      aLifeData.avoid := Smallint(WordComData_GETword(ComData, i));
    if _ldds_recovery in aState then
      aLifeData.recovery := Smallint(WordComData_GETword(ComData, i));
    if _ldds_accuracy in aState then
      aLifeData.accuracy := Smallint(WordComData_GETword(ComData, i));

  end;
begin
  fillchar(aitem, sizeof(TItemData), 0);
  with aitem do
  begin
    rName := WordComData_getString(ComData, i);
    rViewName := WordComData_getString(ComData, i);
    rKind := WordComData_GETbyte(ComData, i);

    rNameColor := WordComData_GETdword(ComData, i);

    rSex := WordComData_getbyte(ComData, i);
    rShape := WordComData_getword(ComData, i);
    rcolor := WordComData_getbyte(ComData, i);
    rPrice := WordComData_getdword(ComData, i);
    rCount := WordComData_getdword(ComData, i);

    rlockState := WordComData_getbyte(ComData, i);
    //新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
    if rlockState <> 0 then
      rlocktime := WordComData_getword(ComData, i); //新 解锁状态 时间

    rboDouble := boolean(WordComData_getbyte(ComData, i)); //重叠

    rboNotTrade := boolean(WordComData_getbyte(ComData, i)); //新开关 NPC交易
    rboNotExchange := boolean(WordComData_getbyte(ComData, i)); //新开关 玩家交换
    rboNotDrop := boolean(WordComData_getbyte(ComData, i)); //新开关 丢弃地上
    rboNotSSamzie := boolean(WordComData_getbyte(ComData, i)); //新开关 存放福袋
    //        rboQuest := boolean(WordComData_getbyte(ComData, i));                   //

    rboDurability := boolean(WordComData_getbyte(ComData, i)); //新开关 消耗持久
    if rboDurability then
    begin
      rDurability := WordComData_getdword(ComData, i); //持久
      rCurDurability := WordComData_getdword(ComData, i); //当前持久
      rboNOTRepair := boolean(WordComData_getbyte(ComData, i));
      //新开关 是否可修理
    end;

    rboTimeMode := boolean(WordComData_getbyte(ComData, i)); //新开关 时间模式
    if rboTimeMode then
      rDateTime := WordComData_getdatetime(ComData, i); //时间
      
    rSpecialKind := (WordComData_getbyte(ComData, i));
    case rKind of
//            ITEM_KIND_WEARITEM2                                                 //24号      // , ITEM_KIND_WEARITEM_29                                         //29 有头盔是29
      ITEM_KIND_WEARITEM //6号
        , ITEM_KIND_WEARITEM_GUILD //60号  掉持久
        , ITEM_KIND_WEARITEM_FD:
        begin
          rcreatename := (WordComData_GETString(ComData, i));
          rGrade := WordComData_getbyte(ComData, i); //新-品介
          rWearArr := WordComData_getbyte(ComData, i);
          //(装备部位) 9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕
          rWearShape := WordComData_getbyte(ComData, i); //装备后 外观图片
          boUpgrade := boolean(WordComData_getbyte(ComData, i)); //新 (允许升级)
          MaxUpgrade := WordComData_getbyte(ComData, i); //新 (最大升级别)

          rSmithingLevel := WordComData_getword(ComData, i);
          //精练等级   //新 装备等级
          rAttach := WordComData_getword(ComData, i); //新 附加属性
          rboColoring := boolean(WordComData_getbyte(ComData, i)); //(允许染色)
          rStarLevel := WordComData_getbyte(ComData, i);
          rboBlueprint := boolean(WordComData_getbyte(ComData, i)); //

          if rboBlueprint then
          begin
            rMaterial.NameArr[0] := copy(WordComData_getString(ComData, i), 1, 20);
            rMaterial.CountArr[0] := WordComData_getbyte(ComData, i);
            rMaterial.NameArr[1] := copy(WordComData_getString(ComData, i), 1, 20);
            rMaterial.CountArr[1] := WordComData_getbyte(ComData, i);
            rMaterial.NameArr[2] := copy(WordComData_getString(ComData, i), 1, 20);
            rMaterial.CountArr[2] := WordComData_getbyte(ComData, i);
            rMaterial.NameArr[3] := copy(WordComData_getString(ComData, i), 1, 20);
            rMaterial.CountArr[3] := WordComData_getbyte(ComData, i);
          end;
          //特殊等级
          rSpecialLevel := WordComData_GETdword(ComData, i);
        end;

    end;
    case rKind of
      121: //宝石
        begin
          _getTLifeData(rLifeDataBasic);
        end;
      //ITEM_KIND_WEARITEM2                                                 //24号      //, ITEM_KIND_WEARITEM_29                                         //29 有头盔是29
      ITEM_KIND_WEARITEM //6号
        , ITEM_KIND_WEARITEM_GUILD //60号  掉持久
        :
        begin
          _getTLifeData(rLifeDataBasic);
          _getTLifeData(rLifeDataLevel);
          _getTLifeData(rLifeDataAttach);
          _getTLifeData(rLifeDataSetting);
          //套装
          rSuitId := WordComData_getbyte(ComData, i);
          if rSuitId > 0 then _getTLifeData(rLifeDataSuit);
          //镶嵌
          rSetting.rsettingcount := WordComData_getbyte(ComData, i);
          if rSetting.rsettingcount > 0 then
          begin
            if rSetting.rsettingcount >= 1 then
              rSetting.rsetting1 := WordComData_getString(ComData, i);
            if rSetting.rsettingcount >= 2 then
              rSetting.rsetting2 := WordComData_getString(ComData, i);
            if rSetting.rsettingcount >= 3 then
              rSetting.rsetting3 := WordComData_getString(ComData, i);
            if rSetting.rsettingcount >= 4 then
              rSetting.rsetting4 := WordComData_getString(ComData, i);
          end;
          //鉴定
          rboident := boolean(WordComData_getbyte(ComData, i));
        end;
    end;

  end;
end;

procedure TMagicDataToTWordComData(var Source: TMagicData; var ComData:
  TWordComData);
begin
  WordComData_ADDdword(ComData, Source.rID);
  WordComData_ADDstring(ComData, Source.rname);
  WordComData_ADDdword(ComData, Source.rMagicType);
  WordComData_ADDdword(ComData, Source.rcSkillLevel);
  WordComData_ADDdword(ComData, Source.rSkillExp);
  WordComData_ADDdword(ComData, Source.rShape);
  WordComData_ADDbuf(ComData, @Source.rLifeData, sizeof(TLifeData));

end;

procedure TWordComDataToTMagicData(var i: integer; var ComData: TWordComData; var
  aitem: TMagicData);
begin
  fillchar(aitem, sizeof(TMagicData), 0);
  aitem.rID := WordComData_getdword(ComData, i);
  aitem.rname := WordComData_getstring(ComData, i);
  aitem.rMagicType := WordComData_getdword(ComData, i);
  aitem.rcSkillLevel := WordComData_getdword(ComData, i);
  aitem.rSkillExp := WordComData_getdword(ComData, i);
  aitem.rShape := WordComData_getdword(ComData, i);
  if WordComData_getbuf(ComData, i, @aitem.rLifeData, sizeof(TLifeData)) <= 0
    then
  begin //获取失败

  end;
end;

function Get10000To100(avalue: integer): string;
var
  n: integer;
  str: string;
begin
  str := InttoStr(avalue div 100) + '.';
  n := avalue mod 100;
  if n >= 10 then
    str := str + IntToStr(n)
  else
    str := str + '0' + InttoStr(n);

  Result := str;
end;

function GetDBErrorText(aid: integer): string;
begin

  case aid of
    DB_OK: result := 'DB_OK';
    DB_ERR: result := 'DB_ERR';
    DB_ERR_NOTFOUND: result := 'DB_ERR_NOTFOUND';
    DB_ERR_DUPLICATE: result := 'DB_ERR_DUPLICATE'; //此人物名称已被使用
    DB_ERR_IO: result := 'DB_ERR_IO'; //发生I/O错误
    DB_ERR_INVALIDDATA: result := 'DB_ERR_INVALIDDATA'; //此为不适用的名称
    DB_ERR_NOTENOUGHSPACE: result := 'DB_ERR_NOTENOUGHSPACE';
    //人物资料已满，无法再建立
  else
    result := '未知错误';
  end;

end;

function TMagicDataToStr(aitem: TMagicData): string;
begin
  result := '';
  with aitem do
  begin
    result := result + format('名字:%s', [rname]) + #13#10;
    Result := result + format('等级:%s', [Get10000To100(rcSkillLevel)]) +
    #13#10;
    if rcLifeData.AttackSpeed > 0 then
      result := result + format('速度:%d', [rcLifeData.AttackSpeed]) + #13#10;
    if rcLifeData.recovery > 0 then
      result := result + format('恢复:%d', [rcLifeData.recovery]) + #13#10;
    if rcLifeData.avoid > 0 then
      result := result + format('躲闪:%d', [rcLifeData.avoid]) + #13#10;
    if (rcLifeData.damageBody <> 0) or (rcLifeData.damageHead <> 0) or
      (rcLifeData.damageArm <> 0) or (rcLifeData.damageLeg <> 0) then
    begin
      result := result + '攻击:' + #13#10 + ' ';
      if rcLifeData.damageBody <> 0 then
        result := result + format('+身:%d', [rcLifeData.damageBody]) + ' ';
      if rcLifeData.damageHead <> 0 then
        result := result + format('+头:%d', [rcLifeData.damageHead]) + ' ';
      if rcLifeData.damageArm <> 0 then
        result := result + format('+手:%d', [rcLifeData.damageArm]) + ' ';
      if rcLifeData.damageLeg <> 0 then
        result := result + format('+脚:%d', [rcLifeData.damageLeg]) + ' ';
      result := result + #13#10;
    end;
    if (rcLifeData.armorBody <> 0) or (rcLifeData.armorHead <> 0) or
      (rcLifeData.armorArm <> 0) or (rcLifeData.armorLeg <> 0) then
    begin
      result := result + '防御:' + #13#10 + ' ';
      if rcLifeData.armorBody <> 0 then
        result := result + format('+身:%d', [rcLifeData.armorBody]) + ' ';
      if rcLifeData.armorHead <> 0 then
        result := result + format('+头:%d', [rcLifeData.armorHead]) + ' ';
      if rcLifeData.armorArm <> 0 then
        result := result + format('+手:%d', [rcLifeData.armorArm]) + ' ';
      if rcLifeData.armorLeg <> 0 then
        result := result + format('+脚:%d', [rcLifeData.armorLeg]) + ' ';
      result := result + #13#10;
    end;

  end;
end;

function strTOpaidtype(str: string): TPaidType;
begin

  if str = 'pt_none' then
    result := pt_none
  else if str = 'pt_invalidate' then
    result := pt_invalidate
  else if str = 'pt_validate' then
    result := pt_validate
  else if str = 'pt_test' then
    result := pt_test
  else if str = 'pt_timepay' then
    result := pt_timepay
      {else if str = 'pt_namemoney' then
result := pt_namemoney
else if str = 'pt_nametime' then
result := pt_nametime
else if str = 'pt_ipmoney' then
result := pt_ipmoney
else if str = 'pt_iptime' then
result := pt_iptime}
  else
    result := pt_none;
end;

function PaidtypeTostr(rPaidType: TPaidType): string;
begin
  case rPaidType of
    pt_none: result := 'pt_none';
    pt_invalidate: result := 'pt_invalidate';
    pt_validate: result := 'pt_validate';
    pt_test: result := 'pt_test';
    pt_timepay: result := 'pt_timepay';
    //  pt_namemoney:result := 'pt_namemoney';
    //  pt_nametime:result := 'pt_nametime';
     // pt_ipmoney:result := 'pt_ipmoney';
     // pt_iptime:result := 'pt_iptime';
  else
    result := 'pt_none';
  end;
end;

end.

