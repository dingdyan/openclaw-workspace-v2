package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '天机老人';

--升段配置
local _sd = {
  --可升段道具(id,最高段数)
  item = {
    ['雕火龙套'] = {1, 4},
    ['银狼破皇剑'] = {1, 4},
    ['烈爪'] = {1, 4},
    ['龙恨'] = {1, 4},
    ['黄龙斧'] = {1, 4},
    ['男子黄龙斗笠'] = {1, 4},
    ['女子黄龙斗笠'] = {1, 4},
    ['男子黄龙弓服'] = {1, 4},
    ['女子黄龙弓服'] = {1, 4},
    ['男子黄龙护腕'] = {1, 4},
    ['女子黄龙护腕'] = {1, 4},
    ['男子黄龙鞋'] = {1, 4},
    ['女子黄龙鞋'] = {1, 4},
    ['黄龙弓'] = {1, 4},
    ['黄龙斗甲'] = {1, 4},
	
    ['黄金手套'] = {2, 4},
    ['忍者剑'] = {2, 4},
    ['三叉剑'] = {2, 4},
    ['新罗宝剑'] = {2, 4},
    ['日本刀'] = {2, 4},
    ['三叉戟'] = {2, 4},
    ['桂林竹枪'] = {2, 4},
    ['磐龙斧'] = {2, 4},
    ['男子黄金头盔'] = {2, 4},
    ['女子黄金头盔'] = {2, 4},
    ['男子黄金护腕'] = {2, 4},
    ['女子黄金护腕'] = {2, 4},
    ['男子黄金战靴'] = {2, 4},
    ['女子黄金战靴'] = {2, 4},
    ['男子黄金铠甲'] = {2, 4},
    ['女子黄金铠甲'] = {2, 4},

    ['狐狸手套'] = {3, 4},	
    ['龙光剑'] = {3, 4},
    ['月光刀'] = {3, 4},
    ['狼牙戟'] = {3, 4},
    ['炎帝火灵斧'] = {3, 4},
    ['四季甲胄'] = {3, 4},
    ['驱魔烈火弓'] = {3, 4},
    ['男子妖华帽'] = {3, 4},
    ['女子妖华帽'] = {3, 4},
    ['男子妖华护腕'] = {3, 4},
    ['女子妖华护腕'] = {3, 4},
    ['男子利齿靴'] = {3, 4},
    ['女子利齿靴'] = {3, 4},
    ['男子妖华袍'] = {3, 4},
    ['女子妖华袍'] = {3, 4},

    ['九法手套'] = {4, 4},
    ['三飞剑'] = {4, 4},
    ['半月刀'] = {4, 4},
    ['罗汉竹枪'] = {4, 4},
    ['背星棍'] = {4, 4},
    ['军神槌'] = {4, 4},
    ['男子黑龙斗笠'] = {4, 4},
    ['女子黑龙斗笠'] = {4, 4},
    ['男子黑龙护腕'] = {4, 4},
    ['女子黑龙护腕'] = {4, 4},
    ['男子黑龙战靴'] = {4, 4},
    ['女子黑龙战靴'] = {4, 4},
    ['男子黑龙战甲'] = {4, 4},
    ['女子黑龙战甲'] = {4, 4},

    ['太极手套'] = {5, 4},
    ['太极日剑'] = {5, 4},
    ['太极月刀'] = {5, 4},
    ['太极神枪'] = {5, 4},
    ['太极斧'] = {5, 4},
    ['男子太极道冠'] = {5, 4},
    ['女子太极道冠'] = {5, 4},
    ['男子太极护腕'] = {5, 4},
    ['女子太极护腕'] = {5, 4},
    ['男子太极鞋'] = {5, 4},
    ['女子太极鞋'] = {5, 4},
    ['男子太极道袍'] = {5, 4},
    ['女子太极道袍'] = {5, 4},

    ['断铠手套'] = {6, 4},
    ['霸王剑'] = {6, 4},
    ['天王刀'] = {6, 4},
    ['西域魔人枪'] = {6, 4},
    ['帝王槌'] = {6, 4},
    ['北海连环弓'] = {6, 4},
    ['金丝斗甲'] = {6, 4},
    ['男子魔人帽'] = {6, 4},
    ['女子魔人帽'] = {6, 4},
    ['男子魔人护腕'] = {6, 4},
    ['女子魔人护腕'] = {6, 4},
    ['男子魔人战靴'] = {6, 4},
    ['女子魔人战靴'] = {6, 4},
    ['男子魔人道袍'] = {6, 4},
    ['女子魔人道袍'] = {6, 4},

  },
  --材料,机率,失败处理（0不处理，1降级，2消失，几率）
  mate = { 
    --黄龙
	[1] = {
      [1] = {'黄龙玉:10;钱币:1000', 100, 0, 0},
      [2] = {'黄龙玉:20;钱币:2000', 80, 0, 0},
      [3] = {'黄龙玉:30;钱币:3000', 50, 1, 5},
      [4] = {'黄龙玉:40;钱币:4000', 30, 1, 10},
	},
    --王陵
	[2] = {
      [1] = {'帝王魂:10;钱币:1000', 90, 0, 0},
      [2] = {'帝王魂:20;钱币:2000', 70, 0, 0},
      [3] = {'帝王魂:30;钱币:3000', 40, 1, 10},
      [4] = {'帝王魂:40;钱币:4000', 20, 1, 10},
	},
    --狐狸
	[3] = {
      [1] = {'红玫瑰:10;钱币:1000', 80, 0, 0},
      [2] = {'红玫瑰:20;钱币:2000', 60, 0, 0},
      [3] = {'红玫瑰:30;钱币:3000', 30, 1, 10},
      [4] = {'红玫瑰:40;钱币:4000', 15, 1, 10},
	},
    --极乐
	[4] = {
      [1] = {'极乐魂:10;钱币:10000', 70, 0, 0},
      [2] = {'极乐魂:20;钱币:20000', 50, 0, 0},
      [3] = {'极乐魂:30;钱币:30000', 25, 1, 10},
      [4] = {'极乐魂:40;钱币:40000', 15, 1, 10},
	},
    --太极
	[5] = {
      [1] = {'阴阳玉:10;钱币:10000', 70, 0, 0},
      [2] = {'阴阳玉:20;钱币:20000', 40, 0, 0},
      [3] = {'阴阳玉:30;钱币:30000', 25, 1, 10},
      [4] = {'阴阳玉:40;钱币:40000', 10, 1, 20},
	},
    --魔人
	[5] = {
      [1] = {'神兵图鉴:10;钱币:10000', 70, 0, 0},
      [2] = {'神兵图鉴:20;钱币:20000', 40, 0, 0},
      [3] = {'神兵图鉴:30;钱币:30000', 25, 1, 20},
      [4] = {'神兵图鉴:40;钱币:40000', 5, 1, 30},
	},
  },
  --附加成功率道具
  suss = {
    ['生死梦幻丹'] = 20,
    ['草芥丹'] = 10,
  },
};

--合成配置
--段数,材料,合成后装备,合成后段数
local _hc = {
  ['雕火龙套'] = {4, '合成石:100;钱币:500000', '黄金手套', 2},
  ['银狼破皇剑'] = {4, '合成石:100;钱币:500000', '新罗宝剑', 2},
  ['烈爪'] = {4, '合成石:100;钱币:500000', '三叉戟', 2},
  ['龙恨'] = {4, '合成石:100;钱币:500000', '桂林竹枪', 2},
  ['黄龙斧'] = {4, '合成石:100;钱币:500000', '磐龙斧', 2},
  ['女子黄龙斗笠'] = {4, '合成石:100;钱币:500000', '女子黄金头盔', 2},
  ['女子黄龙护腕'] = {4, '合成石:100;钱币:500000', '女子黄金护腕', 2},
  ['女子黄龙弓服'] = {4, '合成石:100;钱币:500000', '女子黄金铠甲', 2},
  ['女子黄龙鞋'] = {4, '合成石:100;钱币:500000', '女子黄金战靴', 2},
  ['男子黄龙斗笠'] = {4, '合成石:100;钱币:500000', '男子黄金头盔', 2},
  ['男子黄龙护腕'] = {4, '合成石:100;钱币:500000', '男子黄金护腕', 2},
  ['男子黄龙弓服'] = {4, '合成石:100;钱币:500000', '男子黄金铠甲', 2},
  ['男子黄龙鞋'] = {4, '合成石:100;钱币:500000', '男子黄金战靴', 2},
  ['黄金手套'] = {4, '合成石:100;钱币:500000', '狐狸手套', 2},
  ['新罗宝剑'] = {4, '合成石:100;钱币:500000', '龙光剑', 2},
  ['三叉戟'] = {4, '合成石:100;钱币:500000', '月光刀', 2},
  ['桂林竹枪'] = {4, '合成石:100;钱币:500000', '狼牙戟', 2},
  ['磐龙斧'] = {4, '合成石:100;钱币:500000', '炎帝火灵斧', 2},
  ['女子黄金头盔'] = {4, '合成石:100;钱币:500000', '女子妖华帽', 2},
  ['女子黄金护腕'] = {4, '合成石:100;钱币:500000', '女子妖华护腕', 2},
  ['女子黄金战靴'] = {4, '合成石:100;钱币:500000', '女子利齿鞋', 2},
  ['女子黄金铠甲'] = {4, '合成石:100;钱币:500000', '女子妖华袍', 2},
  ['男子黄金头盔'] = {4, '合成石:100;钱币:500000', '男子妖华帽', 2},
  ['男子黄金护腕'] = {4, '合成石:100;钱币:500000', '男子妖华护腕', 2},
  ['男子黄金战靴'] = {4, '合成石:100;钱币:500000', '男子利齿鞋', 2},
  ['男子黄金铠甲'] = {4, '合成石:100;钱币:500000', '男子妖华袍', 2},
  ['狐狸手套'] = {4, '合成石:100;钱币:500000', '九法手套', 2},
  ['龙光剑'] = {4, '合成石:100;钱币:500000', '三飞剑', 2},
  ['月光刀'] = {4, '合成石:100;钱币:500000', '半月刀', 2},
  ['狼牙戟'] = {4, '合成石:100;钱币:500000', '罗汉竹枪', 2},
  ['炎帝火灵斧'] = {4, '合成石:100;钱币:500000', '军神槌', 2},
  ['女子妖华帽'] = {4, '合成石:100;钱币:500000', '女子黑龙斗笠', 2},
  ['女子妖华护腕'] = {4, '合成石:100;钱币:500000', '女子黑龙护腕', 2},
  ['女子利齿鞋'] = {4, '合成石:100;钱币:500000', '女子黑龙战靴', 2},
  ['女子妖华袍'] = {4, '合成石:100;钱币:500000', '女子黑龙战甲', 2},
  ['男子妖华帽'] = {4, '合成石:100;钱币:500000', '男子黑龙斗笠', 2},
  ['男子妖华护腕'] = {4, '合成石:100;钱币:500000', '男子黑龙护腕', 2},
  ['男子利齿鞋'] = {4, '合成石:100;钱币:500000', '男子黑龙战靴', 2},
  ['男子妖华袍'] = {4, '合成石:100;钱币:500000', '男子黑龙战甲', 2},
  ['九法手套'] = {4, '合成石:100;钱币:500000', '太极手套', 2},
  ['三飞剑'] = {4, '合成石:100;钱币:500000', '太极日剑', 2},
  ['半月刀'] = {4, '合成石:100;钱币:500000', '太极月刀', 2},
  ['罗汉竹枪'] = {4, '合成石:100;钱币:500000', '太极神枪', 2},
  ['军神槌'] = {4, '合成石:100;钱币:500000', '太极斧', 2},
  ['女子黑龙斗笠'] = {4, '合成石:100;钱币:500000', '女子太极道冠', 2},
  ['女子黑龙护腕'] = {4, '合成石:100;钱币:500000', '女子太极护腕', 2},
  ['女子黑龙战靴'] = {4, '合成石:100;钱币:500000', '女子太极鞋', 2},
  ['女子黑龙战甲'] = {4, '合成石:100;钱币:500000', '女子太极道袍', 2},
  ['男子黑龙斗笠'] = {4, '合成石:100;钱币:500000', '男子太极道冠', 2},
  ['男子黑龙护腕'] = {4, '合成石:100;钱币:500000', '男子太极护腕', 2},
  ['男子黑龙战靴'] = {4, '合成石:100;钱币:500000', '男子太极鞋', 2},
  ['男子黑龙战甲'] = {4, '合成石:100;钱币:500000', '男子太极道袍', 2},
  ['太极手套'] = {4, '神兵图鉴:100;钱币:500000', '断铠手套', 2},
  ['太极日剑'] = {4, '神兵图鉴:100;钱币:500000', '霸王剑', 2},
  ['太极月刀'] = {4, '神兵图鉴:100;钱币:500000', '天王刀', 2},
  ['太极神枪'] = {4, '神兵图鉴:100;钱币:500000', '西域魔人枪', 2},
  ['太极斧 '] = {4, '神兵图鉴:100;钱币:500000', '帝王槌', 2},
  ['女子太极道冠'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人帽', 2},
  ['女子太极护腕'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人护腕', 2},
  ['女子太极鞋 '] = {4, '神兵图鉴:100;钱币:500000', '女子魔人战靴', 2},
  ['女子太极道袍'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人道袍', 2},
  ['男子太极道冠'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人帽', 2},
  ['男子太极护腕'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人护腕', 2},
  ['男子太极鞋 '] = {4, '神兵图鉴:100;钱币:500000', '男子魔人战靴', 2},
  ['男子太极道袍'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人道袍', 2},
  ['黄龙斗甲'] = {4, '神兵图鉴:100;钱币:500000', '四季甲胄', 2},
  ['黄龙弓'] = {4, '神兵图鉴:100;钱币:500000', '驱魔烈火弓', 2},
  ['四季甲胄'] = {4, '神兵图鉴:100;钱币:500000', '金丝斗甲', 2},
  ['驱魔烈火弓'] = {4, '神兵图鉴:100;钱币:500000', '北海连环弓', 2},
};

--升段合成配置
--鉴定装备
local _hcsd = {
  --允许合成的装备 对应材料ID配置
  Item = {
    --黄龙
    ['雕火龙套'] = 1,
    ['银狼破皇剑'] = 1,
    ['烈爪'] = 1,
    ['龙恨'] = 1,
    ['黄龙斧'] = 1,
    ['黄龙弓'] = 1,
    ['黄龙斗甲'] = {1, 15},
    ['男子黄龙弓服'] = 1,
    ['女子黄龙弓服'] = 1,
    ['男子黄龙斗笠'] = 1,
    ['女子黄龙斗笠'] = 1,
    ['男子黄龙护腕'] = 1,
    ['女子黄龙护腕'] = 1,
    ['男子黄龙鞋'] = 1,
    ['女子黄龙鞋'] = 1,
	--王灵
    ['黄金手套'] = 2,
    ['忍者剑'] = 2,
    ['日本刀'] = 2,
    ['三叉剑'] = 2,
    ['三叉戟'] = 2,
    ['桂林竹枪'] = 2,
    ['磐龙斧'] = 2,
    ['逐日弓'] = 2,
    ['黄巾刺'] = 2,
    ['狮吼剑'] = 2,
    ['新罗宝剑'] = 2,
    ['男子黄金铠甲'] = 2,
    ['女子黄金铠甲'] = 2,
    ['男子黄金头盔'] = 2,
    ['女子黄金头盔'] = 2,
    ['男子黄金护腕'] = 2,
    ['女子黄金护腕'] = 2,
    ['男子黄金战靴'] = 2,
    ['女子黄金战靴'] = 2,
  },
  --最高段数
  Max = 4,
  --材料,数量,成功率
  Mate = {
    --黄龙
    [1] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --王灵
    [2] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
  },
};

local MainMenu =
[[
装备升段与合成^
^
<「游标.bmp」『$00FFFF00| 装备 升段』/@sd>^
<「游标.bmp」『$00FFFF00| 合成 升段装备』/@hcsd>
]];

--<「游标.bmp」『$00FFFF00| 装备 合成』/@hc>

local SDMenu =
[[
请放入需要升段的装备与材料^
升级1段需要对应材料*1^
升级2段需要对应材料*2^
升级3段需要对应材料*3^
升级4段需要对应材料*4^
^
<「游标.bmp」『$00FFFF00| 已放入,确认升段』/@qrsd>
]];

local HCMenu =
[[
请放入需要合成的装备^
^
<「游标.bmp」『$00FFFF00| 已放入,确认合成』/@qrhc>
]];

local SDHCMenu =
[[
3件同段的装备可合成下一段^
注意:合成后保留主装备鉴定属性^
如合成失败副装备以及材料消失^
^
<『$00FFFF00| 已放入,开始升段』/@kssd>
]];


function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
    return;
  end;
  
  --合成升段
  if aStr == 'hcsd' then
    P_MenuSay(uSource, SDHCMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '主装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    P_ItemInputWindowsOpen(uSource, 1, '副装备1', '');
    P_setItemInputWindowsKey(uSource, 1, -1);
    P_ItemInputWindowsOpen(uSource, 2, '副装备2', '');
    P_setItemInputWindowsKey(uSource, 2, -1);
    return;
  end;
  
  --开始升段
  if aStr == 'kssd' then
    --判断放入物品
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段主装备');
      return;
	end;
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	if bKey < 0 or bKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local cKey = P_getItemInputWindowsKey(uSource, 2);
	if cKey < 0 or cKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData.Name == '' or _hcsd.Item[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入主装备或不能合成!');
      return;
	end;
	local bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	if bItemData.Name == '' or bItemData.Name ~= aItemData.Name or bItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备1 不符合条件');
      return;
	end;
	local cItemData = P_GetHaveItemInfoTabs(uSource, cKey);
	if cItemData.Name == '' or cItemData.Name ~= aItemData.Name or cItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备2 不符合条件');
      return;
	end; 
	--判断段数
	if aItemData.Upgrade >= _hcsd.Max then 
      P_MenuSay(uSource, '主装备 段数已满');
      return;
	end;
	--判断材料
	local Index = _hcsd.Item[aItemData.Name];
	local t = _hcsd.Mate[Index][aItemData.Upgrade + 1];
	if t == nil then 
      P_MenuSay(uSource, '主装备 不可升段');
      return;
	end; 
    --组成输出字符
    local Str = string.format('确认合成 %s(%d段)吗?^', aItemData.Name, aItemData.Upgrade + 1);
	Str = string.format('%s主装备:%s(%d段)^', Str, aItemData.Name, aItemData.Upgrade);
	Str = string.format('%s副装备1:%s(%d段)^', Str, bItemData.Name, bItemData.Upgrade);
	Str = string.format('%s副装备2:%s(%d段)^', Str, cItemData.Name, cItemData.Upgrade);
	Str = string.format('%s合成材料:%s^', Str, t[1]);
	Str = string.format('%s成功率:%d%%^', Str, t[2]);
    Str = string.format('%s^<『$00FFFF00| 确认合成』/@qrsd>^', Str);
    Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);    
    return;
  end;
  
  --开始升段
  if aStr == 'qrsd' then
    --判断放入物品
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段主装备');
      return;
	end;
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	if bKey < 0 or bKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local cKey = P_getItemInputWindowsKey(uSource, 2);
	if cKey < 0 or cKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData.Name == '' or _hcsd.Item[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入主装备或不能合成!');
      return;
	end;
	local bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	if bItemData.Name == '' or bItemData.Name ~= aItemData.Name or bItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备1 不符合条件');
      return;
	end;
	local cItemData = P_GetHaveItemInfoTabs(uSource, cKey);
	if cItemData.Name == '' or cItemData.Name ~= aItemData.Name or cItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备2 不符合条件');
      return;
	end; 
	--判断段数
	if aItemData.Upgrade >= _hcsd.Max then 
      P_MenuSay(uSource, '主装备 段数已满');
      return;
	end;
	--判断材料
	local Upgrade = aItemData.Upgrade + 1;
	local Index = _hcsd.Item[aItemData.Name];
	local t = _hcsd.Mate[Index][Upgrade];
	if t == nil then 
      P_MenuSay(uSource, '主装备 不可升段');
      return;
	end; 
	--分解材料为table
	local _t = lua_Strtotable(t[1], ';');
    for i, v in pairs(_t) do
      _t[i] = lua_Strtotable(v, ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要 %s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '天机老人');
      end
    end;
	--删除副装备
	P_DelHaveItemInfo(uSource, bKey, -1);
	P_DelHaveItemInfo(uSource, cKey, -1);
	--失败处理
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random(100);math.random(100);math.random(100);
	if math.random(100) > t[2] then 
      P_MenuSay(uSource, '很可惜,本次合成失败了');	
	 return;
	end;
	--改变主装备段数
	P_SetItemField(uSource, 0, 'rUpgrade', aKey, Upgrade);
	--提示
    P_MenuSay(uSource, string.format('%s 升段成功', aItemData.Name));
	--全服公告	
	M_topmsg(string.format('天机老人:恭喜 %s 合成了 %s(%d段)', B_GetRealName(uSource), aItemData.Name, Upgrade), 33023);  
    return;
  end;
  

  --升段
  if aStr == 'sd' then
    P_MenuSay(uSource, SDMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '升段装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    P_ItemInputWindowsOpen(uSource, 1, '附加材料', '');
    P_setItemInputWindowsKey(uSource, 1, -1);
    return;
  end;
  
  --确认升段
  if aStr == 'qrsd' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段的装备');
      return;
	end;
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil or ItemData.Name == '' or _sd.item[ItemData.Name] == nil then
      P_MenuSay(uSource, '放入装备不可升段!');
      return;
	end;
	if ItemData.Upgrade >= _sd.item[ItemData.Name][2] then 
      P_MenuSay(uSource, '装备段数已满!');
      return;
	end;
    --判断附加材料
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	local rItem = false;
	if bKey > -1 and bKey < 59 then 
      local bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	  if bItemData == nil or bItemData.Name == '' or _sd.suss[bItemData.Name] == nil then
        P_MenuSay(uSource, '附加材料放入错误!');
        return;
	  end;
	  rItem = true;
	end;
	local Index = _sd.item[ItemData.Name][1];
	local t = _sd.mate[Index][ItemData.Upgrade + 1];
	--分解材料为table
	local _t = lua_Strtotable(t[1], ';');
    for i, v in pairs(_t) do
      _t[i] = lua_Strtotable(v, ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要材料%s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '天机老人');
      end
    end;
	--成功率
	local m = t[2];
	--是否放入辅助道具
	if rItem then 
	  P_DelHaveItemInfo(uSource, bKey, 1);
	  m = m + math.floor(m / 100 * _sd.suss[bItemData.Name]);
	end;
	--判断是否成功
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();math.random();math.random();
	--升段成功
    if math.random(0, 100) <= m then
	  --改变段数
	  P_SetItemField(uSource, 0, 'rUpgrade', aKey, ItemData.Upgrade + 1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 成功', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段成功!^^<『$00FFFF00|继续升段』/@qrsd>^^<『$00FFFF00|返 回』/@fanhui>');
      return;
    end;
    --失败降级处理
	if t[3] == 1 and math.random(0, 100) <= t[4] then 
	  --改变段数
	  P_SetItemField(uSource, 0, 'rUpgrade', aKey, ItemData.Upgrade - 1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败,装备已降级', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!已降级^^<『$00FFFF00|返 回』/@fanhui>');
	--失败删除处理
	elseif t[3] == 2 and math.random(0, 100) <= t[4] then 
	  --删除装备
	  P_DelHaveItemInfo(uSource, aKey, -1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败,装备已消失', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!已消失^^<『$00FFFF00|返 回』/@fanhui>');
	--失败无惩罚
	else
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!^^<『$00FFFF00|返 回』/@fanhui>');
	end
    return;
  end;

  --合成
  if aStr == 'hc' then
    P_MenuSay(uSource, HCMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '合成装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  --确认合成
  if aStr == 'qrhc' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入合成的装备');
      return;
	end;
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil or ItemData.Name == '' or _hc[ItemData.Name] == nil then
      P_MenuSay(uSource, '放入装备不可合成!');
      return;
	end;
	--判断段数
	if ItemData.Upgrade ~= _hc[ItemData.Name][1] then 
      P_MenuSay(uSource, '放入装备段数不对!');
      return;
	end;
	--分解材料为table
	local _t = lua_Strtotable(_hc[ItemData.Name][2], ';');
	for m = 1, #_t do
	  _t[m] = lua_Strtotable(_t[m], ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要材料%s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '天机老人');
      end
    end;
	--删除装备
	P_DelHaveItemInfo(uSource, aKey, -1);
	--给与合成后装备
	P_addItemUpgrade(uSource, _hc[ItemData.Name][3], 1, _hc[ItemData.Name][4], '天机老人');
	--公告
	M_topmsg(string.format('%s 合成了 %s %d段', B_GetRealName(uSource), _hc[ItemData.Name][3], _hc[ItemData.Name][4]), 11295231);
	--提示
	P_MenuSay(uSource, '装备合成成功!');
    return;
  end;

 return;
end