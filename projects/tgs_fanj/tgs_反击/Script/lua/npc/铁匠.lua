package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '铁匠';

local steel = {
  --铁矿
  [1] = {
    ['Get'] = {
	  {'生铁', 10},
	  {'钱币', 100},
	},
    ['Set'] = {
	  {'钢铁', 1},
	},
  },
  [2] = {
    ['Get'] = {
	  {'钢铁', 10},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'墨铁', 1},
	},
  },
  [3] = {
    ['Get'] = {
	  {'墨铁', 10},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'玄铁', 1},
	},
  },
  [4] = {
    ['Get'] = {
	  {'玄铁', 10},
	  {'钱币', 100000},
	},
    ['Set'] = {
	  {'熔岩铁', 1},
	},
  },
  [5] = {
    ['Get'] = {
	  {'熔岩铁', 10},
	  {'钱币', 200000},
	},
    ['Set'] = {
	  {'千年衔铁', 1},
	},	
  },
  --原石
  [6] = {
    ['Get'] = {
	  {'青铜原石', 3},
	  {'钱币', 200},
	},
    ['Set'] = {
	  {'青铜', 1},
	},	
  },
  [7] = {
    ['Get'] = {
	  {'黄铜原石', 3},
	  {'钱币', 500},
	},
    ['Set'] = {
	  {'黄铜', 1},
	},	
  },
  [8] = {
    ['Get'] = {
	  {'砂金原石', 3},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'砂金', 1},
	},	
  },
  [9] = {
    ['Get'] = {
	  {'黄金原石', 3},
	  {'钱币', 5000},
	},
    ['Set'] = {
	  {'黄金', 1},
	},	
  },
  [10] = {
    ['Get'] = {
	  {'白金原石', 2},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'白金', 1},
	},	
  },
  [11] = {
    ['Get'] = {
	  {'千年纯金原石', 1},
	  {'钱币', 20000},
	},
    ['Set'] = {
	  {'千年纯金', 1},
	},	
  },
  --原石2
  [12] = {
    ['Get'] = {
	  {'硅石原石', 3},
	  {'钱币', 200},
	},
    ['Set'] = {
	  {'硅石', 1},
	},	
  },
  [13] = {
    ['Get'] = {
	  {'黑石原石', 3},
	  {'钱币', 500},
	},
    ['Set'] = {
	  {'黑石', 1},
	},	
  },
  [14] = {
    ['Get'] = {
	  {'月石原石', 3},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'月石', 1},
	},	
  },
  [15] = {
    ['Get'] = {
	  {'玄石原石', 3},
	  {'钱币', 5000},
	},
    ['Set'] = {
	  {'玄石', 1},
	},	
  },
  [16] = {
    ['Get'] = {
	  {'耀阳原石', 3},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'耀阳石', 1},
	},	
  },
  [17] = {
    ['Get'] = {
	  {'千年金刚石原石', 1},
	  {'钱币', 20000},
	},
    ['Set'] = {
	  {'千年金刚石', 1},
	},	
  },
  --玉石
  [18] = {
    ['Get'] = {
	  {'青玉原石', 3},
	  {'钱币', 200},
	},
    ['Set'] = {
	  {'青玉', 1},
	},	
  },
  [19] = {
    ['Get'] = {
	  {'绿玉原石', 3},
	  {'钱币', 500},
	},
    ['Set'] = {
	  {'绿玉', 1},
	},	
  },
  [20] = {
    ['Get'] = {
	  {'黄玉原石', 3},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'黄玉', 1},
	},	
  },
  [21] = {
    ['Get'] = {
	  {'白玉原石', 3},
	  {'钱币', 5000},
	},
    ['Set'] = {
	  {'白玉', 1},
	},	
  },
  [22] = {
    ['Get'] = {
	  {'黑珍珠原石', 2},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'黑珍珠', 1},
	},	
  },
  [23] = {
    ['Get'] = {
	  {'千年水晶原石', 1},
	  {'钱币', 20000},
	},
    ['Set'] = {
	  {'千年水晶', 1},
	},	
  },
  [24] = {
    ['Get'] = {
	  {'黄铜', 1},
	  {'钱币', 100},
	},
    ['Set'] = {
	  {'青铜', 10},
	},	
  },
  [25] = {
    ['Get'] = {
	  {'砂金', 1},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'黄铜', 10},
	},	
  },
  [26] = {
    ['Get'] = {
	  {'黄金', 1},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'砂金', 10},
	},	
  },
  [27] = {
    ['Get'] = {
	  {'白金', 1},
	  {'钱币', 100000},
	},
    ['Set'] = {
	  {'黄金', 10},
	},	
  },
  [28] = {
    ['Get'] = {
	  {'黑石', 1},
	  {'钱币', 100},
	},
    ['Set'] = {
	  {'硅石', 10},
	},	
  },
  [29] = {
    ['Get'] = {
	  {'月石', 1},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'黑石', 10},
	},	
  },
  [30] = {
    ['Get'] = {
	  {'玄石', 1},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'月石', 10},
	},	
  },
  [31] = {
    ['Get'] = {
	  {'耀阳石', 1},
	  {'钱币', 100000},
	},
    ['Set'] = {
	  {'玄石', 10},
	},	
  },
  [32] = {
    ['Get'] = {
	  {'绿玉', 1},
	  {'钱币', 100},
	},
    ['Set'] = {
	  {'青玉', 10},
	},	
  },
  [33] = {
    ['Get'] = {
	  {'黄玉', 1},
	  {'钱币', 1000},
	},
    ['Set'] = {
	  {'绿玉', 10},
	},	
  },
  [34] = {
    ['Get'] = {
	  {'白玉', 1},
	  {'钱币', 10000},
	},
    ['Set'] = {
	  {'黄玉', 10},
	},	
  },	
  [35] = {
    ['Get'] = {
	  {'黑珍珠', 1},
	  {'钱币', 100000},
	},
    ['Set'] = {
	  {'白玉', 10},
	},	
  },	
}

local MainMenu =
[[
 你需要帮助吗?^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^
]];

--<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^

local TLMenu =
[[
 开采到什么了,要提炼吗?^^
<「游标.bmp」『$00FFFF00| 提炼钢铁 (生铁10个) 100钱币』/@steel_1>^
<「游标.bmp」『$00FFFF00| 提炼墨铁 (钢铁10个) 1000钱币』/@steel_2>^
<「游标.bmp」『$00FFFF00| 提炼玄铁 (墨铁10个) 10000钱币』/@steel_3>^
<「游标.bmp」『$00FFFF00| 提炼熔岩铁 (玄铁10个) 100000钱币』/@steel_4>^
<「游标.bmp」『$00FFFF00| 提炼千年衔铁 (熔岩铁10个) 200000钱币』/@steel_5>^
<「游标.bmp」『$00FFFF00| 提炼青铜 (青铜原石3个) 200钱币』/@steel_6>^
<「游标.bmp」『$00FFFF00| 提炼黄铜 (黄铜原石3个) 500钱币』/@steel_7>^
<「游标.bmp」『$00FFFF00| 提炼砂金 (砂金原石3个) 1000钱币』/@steel_8>^
<「游标.bmp」『$00FFFF00| 提炼黄金 (黄金原石3个) 5000钱币』/@steel_9>^
<「游标.bmp」『$00FFFF00| 提炼白金 (白金原石2个) 10000钱币』/@steel_10>^
<「游标.bmp」『$00FFFF00| 提炼千年纯金 (千年纯金原石1个) 20000钱币』/@steel_11>^
<「游标.bmp」『$00FFFF00| 提炼硅石 (硅石原石3个) 200钱币』/@steel_12>^
<「游标.bmp」『$00FFFF00| 提炼黑石 (黑石原石3个) 500钱币』/@steel_13>^
<「游标.bmp」『$00FFFF00| 提炼月石 (月石原石3个) 1000钱币』/@steel_14>^
<「游标.bmp」『$00FFFF00| 提炼玄石 (玄石原石3个) 5000钱币』/@steel_15>^
<「游标.bmp」『$00FFFF00| 提炼耀阳石 (耀阳原石2个) 10000钱币』/@steel_16>^
<「游标.bmp」『$00FFFF00| 提炼千年金刚石 (千年金刚石原石1个) 20000钱币』/@steel_17>^
<「游标.bmp」『$00FFFF00| 提炼青玉 (青玉原石3个) 200钱币』/@steel_18>^
<「游标.bmp」『$00FFFF00| 提炼绿玉 (绿玉原石3个) 500钱币』/@steel_19>^
<「游标.bmp」『$00FFFF00| 提炼黄玉 (黄玉原石3个) 1000钱币』/@steel_20>^
<「游标.bmp」『$00FFFF00| 提炼白玉 (白玉原石3个) 5000钱币』/@steel_21>^
<「游标.bmp」『$00FFFF00| 提炼黑珍珠 (黑珍珠原石2个) 10000钱币』/@steel_22>^
<「游标.bmp」『$00FFFF00| 提炼千年水晶 (千年水晶原石1个) 20000钱币』/@steel_23>^
]];

local DHMenu =
[[
 囊中拥有矿物吗。想换走什么呢？^^
<「游标.bmp」『$00FFFF00| 黄铜交换 (青铜10个) 100钱币』/@steel_24>^
<「游标.bmp」『$00FFFF00| 砂金交换 (黄铜10个) 1000钱币』/@steel_25>^
<「游标.bmp」『$00FFFF00| 黄金交换 (沙金10个) 10000钱币』/@steel_26>^
<「游标.bmp」『$00FFFF00| 白金交换 (黄金10个) 100000钱币』/@steel_27>^
<「游标.bmp」『$00FFFF00| 黑石交换 (硅石10个) 100钱币』/@steel_28>^
<「游标.bmp」『$00FFFF00| 月石交换 (黑石10个) 1000钱币』/@steel_29>^
<「游标.bmp」『$00FFFF00| 玄石交换 (月石10个) 10000钱币』/@steel_30>^
<「游标.bmp」『$00FFFF00| 耀阳石交换 (玄石10个) 100000钱币』/@steel_31>^
<「游标.bmp」『$00FFFF00| 绿玉交换 (青玉10个) 100钱币』/@steel_32>^
<「游标.bmp」『$00FFFF00| 黄玉交换 (绿玉10个) 1000钱币』/@steel_33>^
<「游标.bmp」『$00FFFF00| 白玉交换 (黄玉10个) 10000钱币』/@steel_34>^
<「游标.bmp」『$00FFFF00| 黑珍珠交换 (白玉10个) 100000钱币』/@steel_35>^
]];

local DHMenu100 =
[[
 囊中拥有矿物吗。想换走什么呢？^^
<「游标.bmp」『$00FFFF00| 100个黄铜交换 (青铜1000个) 10000钱币』/@steel2_24>^
<「游标.bmp」『$00FFFF00| 100个砂金交换 (黄铜1000个) 100000钱币』/@steel2_25>^
<「游标.bmp」『$00FFFF00| 100个黄金交换 (沙金1000个) 1000000钱币』/@steel2_26>^
<「游标.bmp」『$00FFFF00| 100个白金交换 (黄金1000个) 10000000钱币』/@steel2_27>^
<「游标.bmp」『$00FFFF00| 100个黑石交换 (硅石1000个) 10000钱币』/@steel2_28>^
<「游标.bmp」『$00FFFF00| 100个月石交换 (黑石1000个) 100000钱币』/@steel2_29>^
<「游标.bmp」『$00FFFF00| 100个玄石交换 (月石1000个) 1000000钱币』/@steel2_30>^
<「游标.bmp」『$00FFFF00| 100个耀阳石交换 (玄石1000个) 10000000钱币』/@steel2_31>^
<「游标.bmp」『$00FFFF00| 100个绿玉交换 (青玉1000个) 10000钱币』/@steel2_32>^
<「游标.bmp」『$00FFFF00| 100个黄玉交换 (绿玉1000个) 100000钱币』/@steel2_33>^
<「游标.bmp」『$00FFFF00| 100个白玉交换 (黄玉1000个) 1000000钱币』/@steel2_34>^
<「游标.bmp」『$00FFFF00| 100个黑珍珠交换 (白玉1000个) 10000000钱币』/@steel2_35>^
]];

local delitem = {
--[[  ['青铜十字镐'] = 1,
  ['钢铁十字镐'] = 1,
  ['象牙十字镐'] = 1,
  ['高级象牙十字镐'] = 1,--]]
};

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  if aStr == 'smelting' then
    P_MenuSay(uSource, TLMenu);
    return;
  end;

  if aStr == 'exchange' then
    P_MenuSay(uSource, DHMenu);
    return;
  end;

  if aStr == 'exchange2' then
    P_MenuSay(uSource, DHMenu100);
    return;
  end;

  --修理道具
  if aStr == 'repair' then
    P_MenuSay(uSource, '请放入需要修理的十字镐^^<「游标.bmp」『$00FFFF00| 确认修理』/@qrfix>', true);
    P_ItemInputWindowsOpen(uSource, 0, '修理道具', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  if aStr == 'qrfix' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 35 then 
      P_MenuSay(uSource, '请放入需要修理的道具');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData == nil or aItemData.Name == '' or delitem[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入道具或道具无法修理!');
      return;
	end;
	--获取修理价格
	local RepairPrice = P_GetItemRepairPrice(uSource, aKey);
	if RepairPrice <= 0 then 
      P_MenuSay(uSource, '道具无需修理');
      return;
	end;		
    if P_getitemcount(uSource, '钱币') < RepairPrice then
      P_MenuSay(uSource, string.format('连%s个钱币都没有吗?', RepairPrice));
     return;
    end;
	--维修道具
	if P_RepairItem(uSource, aKey) ~= 4 then 
      P_MenuSay(uSource, '道具修理失败');
      return;
	end
	--删除钱币
    P_deleteitem(uSource, '钱币', RepairPrice, 'quest铁匠');
	P_MenuSay(uSource, '道具修理成功!');
    return;
  end;


  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'steel' then
    if tonumber(Right) == nil then return end;
    local t = steel[tonumber(Right)];
    if t == nil then return end;
    --检测背包空位
    if P_getitemspace(uSource) < #t['Set'] then
      P_MenuSay(uSource, string.format('请保留%d个物品栏空位', #t['Set']));
     return;
    end; 
	--判断材料
    for i, v in pairs(t['Get']) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('请拿来%d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(t['Get']) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '铁匠');
      end
    end;
	--给予物品
    for i, v in pairs(t['Set']) do	
      if type(v) == 'table' then
        P_additem(uSource, v[1], v[2], '铁匠');
      end
    end;	
    --提示
	P_MenuSay(uSource, '恭喜,兑换成功!');
    return;
  end;

  if Left == 'steel2' then
    if tonumber(Right) == nil then return end;
    local t = steel[tonumber(Right)];
    if t == nil then return end;
    --检测背包空位
    if P_getitemspace(uSource) < #t['Set'] then
      P_MenuSay(uSource, string.format('请保留%d个物品栏空位', #t['Set']));
     return;
    end; 
	--判断材料
    for i, v in pairs(t['Get']) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] * 100 then
           P_MenuSay(uSource, string.format('请拿来%d个%s', v[2] * 100, v[1]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(t['Get']) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2] * 100, '铁匠');
      end
    end;
	--给予物品
    for i, v in pairs(t['Set']) do	
      if type(v) == 'table' then
        P_additem(uSource, v[1], v[2] * 100, '铁匠');
      end
    end;	
    --提示
	P_MenuSay(uSource, '恭喜,兑换成功!');
    return;
  end;

 return;
end