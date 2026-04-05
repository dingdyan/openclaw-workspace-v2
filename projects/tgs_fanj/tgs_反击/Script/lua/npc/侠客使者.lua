package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local _dh = {
  ['get'] = {'侠客宝石', 10},
  ['set'] = {
    {'侠客手套', 1},
    {'侠客剑', 1},
    {'侠客刀', 1},
    {'侠客枪', 1},
    {'侠客斧', 1},
    {'男子侠客服', 1},
    {'女子侠客服', 1},
    {'男子侠客帽', 1},
    {'女子侠客帽', 1},
    {'男子侠客护腕', 1},
    {'女子侠客护腕', 1},
    {'男子侠客靴', 1},
    {'女子侠客靴', 1},
  },
}

local _xkp = {
  ['侠客牌1'] = {
    ['get'] = {
      {'侠客牌1', 1},
      {'侠客宝石', 20},
      {'侠客功勋', 200},
      {'金元', 2},	
	},
    ['set'] = {'侠客牌2', 1, '侠客牌(2级)'},
  },

  ['侠客牌2'] = {
    ['get'] = {
      {'侠客牌2', 1},
      {'侠客宝石', 30},
      {'侠客功勋', 300},
      {'金元', 3},		
	},
    ['set'] = {'侠客牌3', 1, '侠客牌(3级)'},	
  },

  ['侠客牌3'] = {
    ['get'] = {
      {'侠客牌3', 1},
      {'侠客宝石', 40},
      {'侠客功勋', 400},	
      {'金元', 4},		
	},
    ['set'] = {'侠客牌4', 1, '侠客牌(4级)'},	
  },

  ['侠客牌4'] = {
    ['get'] = {
      {'侠客牌4', 1},
      {'侠客宝石', 50},
      {'侠客功勋', 500},	
      {'金元', 5},		
	},
    ['set'] = {'侠客牌5', 1, '侠客牌(5级)'},	
  },

  ['侠客牌5'] = {
    ['get'] = {
      {'侠客牌5', 1},
      {'侠客宝石', 60},
      {'侠客功勋', 600},	
      {'金元', 6},		
	},
    ['set'] = {'侠客牌6', 1, '侠客牌(6级)'},	
  },

  ['侠客牌6'] = {
    ['get'] = {
      {'侠客牌6', 1},
      {'侠客宝石', 70},
      {'侠客功勋', 700},	
      {'金元', 7},		
	},
    ['set'] = {'侠客牌7', 1, '侠客牌(7级)'},	
  },

  ['侠客牌7'] = {
    ['get'] = {
      {'侠客牌7', 1},
      {'侠客宝石', 80},
      {'侠客功勋', 800},
      {'金元', 8},			
	},
    ['set'] = {'侠客牌8', 1, '侠客牌(8级)'},	
  },

  ['侠客牌8'] = {
    ['get'] = {
      {'侠客牌8', 1},
      {'侠客宝石', 90},
      {'侠客功勋', 900},	
      {'金元', 9},		
	},
    ['set'] = {'侠客牌9', 1, '侠客牌(9级)'},	
  },

  ['侠客牌9'] = {
    ['get'] = {
      {'侠客牌9', 1},
      {'侠客宝石', 100},
      {'侠客功勋', 1000},	
      {'金元', 10},		
	},
    ['set'] = {'侠客牌10', 1, '侠客牌(10级)'},	
  }

}

local Npc_Name = '侠客使者';

local MainMenu =
[[美丽的侠客岛已经被怪物占领^
谁能帮我解救侠客岛危难并且找回侠客宝石我有厚礼相赠。^^
<『$00FFFF00| 10个侠客宝石 交换 侠客装备』/@dhzb>^
<『$00FFFF00| 交换 侠客牌（1级）』/@dhxkp>^
<『$00FFFF00| 升级 侠客牌』/@sjxkp>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'dhzb' then
    --检测玩家道具
    if P_getitemcount(uSource, _dh['get'][1]) < _dh['get'][2] then 
      P_MenuSay(uSource, string.format('你没有%d个%s', _dh['get'][2], _dh['get'][1]));
     return;
    end
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--随机获取东西table
	local AwardItem = _dh['set'][math.random(#_dh['set'])];
	if AwardItem == nil then
	  return;
	end;
	--删除道具
	P_deleteitem(uSource, _dh['get'][1], _dh['get'][2], '侠客使者');
	--给予物品
	P_additem(uSource, AwardItem[1], AwardItem[2], '侠客使者');
	--说话
	P_MenuSay(uSource, string.format('恭喜你兑换到了%d个%s', AwardItem[2], AwardItem[1]));
	--公告
	M_topmsg(string.format('侠客使者:[%s]兑换到了[%s]', B_GetRealName(uSource), AwardItem[1]), 16043646);
    return;
  end;

  if aStr == 'dhxkp' then
    --检测玩家道具
    if P_getitemcount(uSource, '侠客宝石') < 10 then 
      P_MenuSay(uSource, '你没有10个侠客宝石');
     return;
    end;
    if P_getitemcount(uSource, '侠客功勋') < 100 then 
      P_MenuSay(uSource, '你没有100个侠客功勋');
     return;
    end;
    if P_getitemcount(uSource, '金元') < 1 then 
      P_MenuSay(uSource, '你没有1个金元');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--删除道具
	P_deleteitem(uSource, '侠客宝石', 10, '侠客使者');
	P_deleteitem(uSource, '侠客功勋', 100, '侠客使者');
	P_deleteitem(uSource, '金元', 1, '侠客使者');
	--给予物品
	P_additem(uSource, '侠客牌1', 1, '侠客使者');
	--说话
	P_MenuSay(uSource, '恭喜你获得了侠客牌(1级)');
	--公告
	M_topmsg(string.format('侠客使者:[%s]获得了侠客牌(1级)', B_GetRealName(uSource)), 33023);
    return;
  end;

  if aStr == 'sjxkp' then
    local Text =
[[请将你需要升级的侠客牌放置物品栏第一个格子。^^
<『$00FFFF00| 已放置好 确认升级』/@qrxkp>
]];
	P_MenuSay(uSource, Text);
    return;
  end;

  if aStr == 'qrxkp' then
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, 0);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请将你需要升级的侠客牌放置物品栏第一个格子!');
      return;
	end;  
	--判断是否顶级牌子
	if ItemData.Name == '侠客牌10' then
      P_MenuSay(uSource, '你的侠客牌已经到达顶级,无法升级了!');
      return;
	end;  
	--判断是否可升级
	local t = _xkp[ItemData.Name];
	if t == nil then 
      P_MenuSay(uSource, '第一个物品无法升级!');
      return;
	end;  
	--判断材料
    for i, v in pairs(t.get) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('缺少升级材料:%d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--判断物品栏
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--删除材料
    for i, v in pairs(t.get) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '侠客使者');
      end
    end;
	--给予物品
	P_additem(uSource, t.set[1], t.set[2], '侠客使者');
	--说话
	P_MenuSay(uSource, '恭喜你,侠客牌升级成功');
	--公告
	M_topmsg(string.format('侠客使者:[%s]的%s升级到%s', B_GetRealName(uSource), ItemData.ViewName, t.set[3]), 33023);
    return;
  end;
 return;
end