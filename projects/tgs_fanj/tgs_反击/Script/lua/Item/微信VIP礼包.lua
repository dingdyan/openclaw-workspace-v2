package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--特殊奖励记录
local _wx = {
  --数据保存路径
  File = "Tgsplus\\微信VIP礼包.sdb",
  --数据
  data = {},
  --分配
  num = {
    [1] = 1,
    [2] = 4,
    [3] = 10,
    [4] = 25,
    [5] = 60,
  },
  --奖品
  item = {
    [1] = {
	  {'黄金VIP(月卡)', 1, 1},
	},
    [2] = {
	  {'至尊礼包', 1, 1},
	},
    [3] = {
	  {'神器礼包', 1, 1},
	},
    [4] = {
	  {'24小时双倍卷轴', 1, 1},
	},
    [5] = {
      {'白酒(绑定)', 500, 500},
	},
  },
  --公告
  info = {
    [1] = '恭喜[%s]开启[微信VIP礼包]获得了[黄金VIP(月卡)]',
    [2] = '恭喜[%s]开启[微信VIP礼包]获得了[至尊礼包1个]',
    [3] = '恭喜[%s]开启[微信VIP礼包]获得了[神器礼包1个]',
    [4] = '恭喜[%s]开启[微信VIP礼包]获得了[24小时双倍卷轴1个]',
    [5] = '恭喜[%s]开启[微信VIP礼包]获得了[白酒(绑定)500个]',
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
	--循环总数量
    for _key, _value in pairs(_wx.num) do
      for i=1,_value,1 do
        table.insert(t, _key);
      end	
    end
	--随机tab
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
   if ItemData == nil or ItemData.Name ~= '微信VIP礼包' then
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
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();
   local Index = _wx.Get();
   local ItemTab = _wx.item[Index];
   if ItemTab == nil then 
     P_saysystem(uSource, '礼包开启失败,请联系管理员', 2);
	 return;		
   end;
   --循环给道具
   for i, v in pairs(ItemTab) do
     if type(v) == 'table' then
	   local _num = math.random(v[2], v[3]);
       P_additem(uSource, v[1], _num, '微信VIP礼包');
     end;
   end;
   --给予道具	
   P_additem(uSource, ItemTab[1], _num, '微信VIP礼包');
   --删除道具
   P_deleteitem(uSource, '微信VIP礼包', 1, '微信VIP礼包');
   --返回消息
   P_saysystem(uSource, string.format('开启[%s]', ItemData.Name), 14);
   --公告
   if _wx.info[Index] ~= nil then 
     M_worldnoticemsg(string.format(_wx.info[Index], B_GetRealName(uSource)), 55512, 0);
   end;
 return;
end