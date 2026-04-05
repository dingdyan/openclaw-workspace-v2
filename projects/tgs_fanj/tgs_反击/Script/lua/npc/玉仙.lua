package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '玉仙';

local Teach = {
   ['噬魂枪下卷'] = {
      ['Set'] = {
         {'噬魂枪下卷', 1}, 
      },
      ['Get'] = {
         {'冥石', 10}, 
      },
   },
   ['血轮回'] = {
      ['Set'] = {
         {'血轮回', 1}, 
      },
      ['Get'] = {
         {'空白秘籍', 1}, 
         {'飞刀', 1000}, 
      },
   },
   ['天地人拳'] = {
      ['Set'] = {
         {'天地人拳', 1}, 
      },
      ['Get'] = {
         {'空白秘籍', 1}, 
         {'犀牛角', 100}, 
         {'老虎指甲', 100},
      },
   },
};

local DelItem = {
  ['尖钩'] = 1,
  ['雪参'] = 1,
  ['装雪参的筐'] = 1,
  ['竹筐'] = 1,
  ['葫芦1'] = 1,
  ['葫芦2'] = 1,
  ['收了魂的葫芦1'] = 1,
  ['收了魂的葫芦2'] = 1,
  ['北霸王魂'] = 1,
  ['东天王魂'] = 1,
  ['帝王守护灵'] = 1,
  ['西域牌'] = 1,
  ['戒指'] = 1,
  ['小佛'] = 1,
  ['白桦树桩'] = 1,
  ['抽屉钥匙'] = 1,
  ['石谷钥匙'] = 1,
  ['召唤符'] = 1,
  ['降魔符'] = 1,
  ['书函'] = 1,
  ['牌王'] = 1,
  ['侠客指环'] = 1,
  ['不灭'] = 1,
};

local MainMenu =
[[
需要绝版武功吗?
<「游标.bmp」『$00FFFF00| 兑换 噬魂枪下卷』/@dh_噬魂枪下卷>^
<「游标.bmp」『$00FFFF00| 兑换 血回轮』/@dh_血轮回>^
<「游标.bmp」『$00FFFF00| 兑换 天地人拳』/@dh_天地人拳>^
]];

local MainMenu_1 =
[[
确认初始化帝王石谷任务吗?不灭戒指等物品也会消失.^
^
<「游标.bmp」『$00FFFF00| 确认初始化』/@qrinitial>^
<「游标.bmp」『$00FFFF00| 取消初始化』/@exit>
]];

function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  if aStr == 'initial' then
    P_MenuSay(uSource, MainMenu_1);
    return;
  end;
  
  if aStr == 'qrinitial' then
    for aKey = 0, 29, 1 do
	  local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	  if aItemData ~= nil and aItemData.Name ~= '' and DelItem[aItemData.Name] ~= nil then
	    P_DelHaveItemInfo(uSource, aKey, -1);
	  end;		
	end
	P_SetQuestNo(uSource, 100);
	P_SetQuestCurrentNo(uSource, 100);	
	P_MenuSay(uSource, '任务已经初始化');
    return;
  end;	
  
  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'dh' then
    local t = Teach[Right]
	if t == nil then return end;
	--检测道具
	for i, v in pairs(t.Get) do
      if type(v) == 'table' then 
        if P_getitemcount(uSource, v[1]) < v[2] then 
           P_MenuSay(uSource, string.format('缺少%d个%s……', v[2], v[1]));
          return;
        end;
      end
    end;
    --检测包裹	
    if P_getitemspace(uSource) < #t.Set then
      P_MenuSay(uSource, string.format('请保留%d个包裹位置……', #t.Set));
     return;
    end;
    --删除道具
    for i, v in pairs(t.Get) do
      if type(v) == 'table' then 
	    P_deleteitem(uSource, v[1], v[2], '玉仙');
      end
    end;
    --给道具
    for i, v in pairs(t.Set) do
      if type(v) == 'table' then 
        P_additem(uSource, v[1], v[2], '玉仙');
      end
    end;
    P_MenuSay(uSource, string.format('请拿好你的%s……', Right));
	--发送全服公告
	M_topmsg(string.format('玉仙:恭喜[%s]获得了[%s]', B_GetRealName(uSource), Right), 9223924);
    return;
  end;
 return;
end