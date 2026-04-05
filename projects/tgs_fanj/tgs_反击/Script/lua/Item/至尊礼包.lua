package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--特殊奖励记录
local _wx = {
  --数据保存路径
  File = "Tgsplus\\至尊礼包.sdb",
  --数据
  data = {},
  --分配
  num = {
    [1] = 5,
    [2] = 10,
    [3] = 25,
    [4] = 60,
  },

  --奖品
  item = {
    -- 5%
    [1] = {
	  {'无极战拳', 1, 1},
	  {'霸王剑', 1, 1},
	  {'天王刀', 1, 1},
	  {'战天戟', 1, 1},
	  {'帝王斧', 1, 1},
	  {'至尊斗甲', 1, 1},
	  {'至尊弓', 1, 1},
	  {'男子至尊斗笠', 1, 1},
	  {'女子至尊斗笠', 1, 1},
	  {'男子至尊战靴', 1, 1},
	  {'女子至尊战靴', 1, 1},
	  {'男子至尊道袍', 1, 1},
	  {'女子至尊道袍', 1, 1},
	  {'男子至尊护腕', 1, 1},
	  {'女子至尊护腕', 1, 1},
	},
    -- 10%
    [2] = {
	  {'太极明珠', 1, 1},
	},
	--25%
    [3] = {
	  {'九法手套', 1, 1},
	  {'三飞剑', 1, 1},
	  {'半月刀', 1, 1},
	  {'罗汉竹枪', 1, 1},
	  {'军神槌', 1, 1},
	  {'男子白龙战甲', 1, 1},
	  {'女子白龙战甲', 1, 1},
	  {'男子黑龙战甲', 1, 1},
	  {'女子黑龙战甲', 1, 1},
	  {'男子黑龙护腕', 1, 1},
	  {'女子黑龙护腕', 1, 1},
	  {'男子黑龙战靴', 1, 1},
	  {'女子黑龙战靴', 1, 1},
	  {'男子黑龙帽', 1, 1},
	  {'女子黑龙帽', 1, 1},
	},
	--60%
    [4] = {
	  {'草芥丹', 1, 1},
	  {'生死梦幻丹', 1, 1},
	  {'溶华素', 1, 1},
	  {'逐龙丹', 1, 1},
	  {'太极液', 1, 1},
	  {'桂圆丹', 1, 1},
	},
  },
};

--读取数据库
_wx.Load = function()
  if file_exists(_wx.File) then
    _wx.data = table.load(_wx.File)
  end
end

--保存数据库
_wx.Save = function()
  table.save(_wx.data, _wx.File)
end

--获取随机道具
_wx.Get = function()
  --为空随机记录
  if _wx.data == nil or #_wx.data < 1 then 
    local t = {};
    for _key, _value in pairs(_wx.num) do
      for i=1,_value,1 do
        table.insert(t, _key);
      end	
    end
    for i = 1,#t do                                    --用for循环遍历这个表
	  a = math.random(#t + 1 - i);                 --取这个表的长度加1减i来随机
	  t[a], t[#t + 1 - i] = t[#t + 1 - i], t[a];	--然后再将取出的a的值与 #t+1-i的值交换位置
    end
	_wx.data = t;
  end;
  local t = _wx.data[#_wx.data];
  --删除保存
  table.remove(_wx.data);
  _wx.Save();
  --返回
 return t;
end

--读取数据
_wx.Load();
	

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name ~= '至尊礼包' then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, string.format('缺少道具:%s', ItemData.Name), 2);
     return;
   end
   --检测背包空位
   if P_getitemspace(uSource) < 4 then
     P_saysystem(uSource, '物品栏已满,请保留4个空位', 2);
    return;
   end;  
   --获取随机道具
   local Index = _wx.Get();
   local ItemTab = _wx.item[Index];
   if ItemTab == nil then 
     P_saysystem(uSource, '礼包开启失败,请联系管理员', 2);
	 return;		
   end;
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();
   --随机道具 + 数量
   local ItemTab = ItemTab[math.random(#ItemTab)];
   local _num = math.random(ItemTab[2], ItemTab[3]);
   --给予道具	
   P_additem(uSource, ItemTab[1], _num, '至尊礼包');
   --删除道具
   P_deleteitem(uSource, '至尊礼包', 1, '至尊礼包');
   --返回消息
   P_saysystem(uSource, string.format('开启[%s]获得了[%d个%s]', ItemData.Name, _num, ItemTab[1]), 14);
   --公告
   M_worldnoticemsg(string.format('%s 开启[%s]获得了[%d个%s]', B_GetRealName(uSource), ItemData.Name, _num, ItemTab[1]), 55512, 0);
 return;
end