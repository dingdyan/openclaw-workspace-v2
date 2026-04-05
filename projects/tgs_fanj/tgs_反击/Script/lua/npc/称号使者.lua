package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '称号使者';

--安全副本次数
local _data = {
  [1] = {
    ['Exp'] = 100,
    ['Get'] = {
	  {'宝石', 100},
	  {'钱币', 1},
	},
  },
  [2] = {
    ['Exp'] = 200,
    ['Get'] = {
	  {'宝石', 100},
	  {'钱币', 1},
	},
  },
  [3] = {
    ['Exp'] = 500,
    ['Get'] = {
	  {'宝石', 200},
	  {'钱币', 1},
	},
  },
  [4] = {
    ['Exp'] = 800,
    ['Get'] = {
	  {'宝石', 200},
	  {'钱币', 1},
	},
  },
  [5] = {
    ['Exp'] = 1500,
    ['Get'] = {
	  {'宝石', 400},
	  {'钱币', 1},
	},
  },
  [6] = {
    ['Exp'] = 2000,
    ['Get'] = {
	  {'宝石', 400},
	  {'钱币', 1},
	},
  },
  [7] = {
    ['Exp'] = 2500,
    ['Get'] = {
	  {'宝石', 600},
	  {'钱币', 1},
	},
  },
  [8] = {
    ['Exp'] = 3000,
    ['Get'] = {
	  {'宝石', 600},
	  {'钱币', 1},
	},
  },
  [9] = {
    ['Exp'] = 4000,
    ['Get'] = {
	  {'宝石', 800},
	  {'钱币', 1},
	},
  },
  [10] = {
    ['Exp'] = 5000,
    ['Get'] = {
	  {'宝石', 800},
	  {'钱币', 1},
	},
  },
  [11] = {
    ['Exp'] = 6000,
    ['Get'] = {
	  {'宝石', 1500},
	  {'钱币', 1},
	},
  },
  [12] = {
    ['Exp'] = 7000,
    ['Get'] = {
	  {'宝石', 1500},
	  {'钱币', 1},
	},
  },
  [13] = {
    ['Exp'] = 8000,
    ['Get'] = {
	  {'宝石', 2000},
	  {'钱币', 1},
	},
  },
  [14] = {
    ['Exp'] = 9000,
    ['Get'] = {
	  {'宝石', 2000},
	  {'钱币', 1},
	},
  },
  [15] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 3000},
	  {'钱币', 1},
	},
  },
  [16] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 3000},
	  {'钱币', 1},
	},
  },
  [17] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 4000},
	  {'钱币', 1},
	},
  },
  [18] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 4000},
	  {'钱币', 1},
	},
  },
  [19] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 5000},
	  {'钱币', 1},
	},
  },
  [20] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 5000},
	  {'钱币', 1},
	},
  },
  [21] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 6000},
	  {'钱币', 1},
	},
  },
  [22] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 6000},
	  {'钱币', 1},
	},
  },
  [23] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 7000},
	  {'钱币', 1},
	},
  },
  [24] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 7000},
	  {'钱币', 1},
	},
  },
  [25] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 8000},
	  {'钱币', 1},
	},
  },
  [26] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 8000},
	  {'钱币', 10},
	},
  },
  [27] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 9000},
	  {'钱币', 10},
	},
  },
  [28] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 9000},
	  {'钱币', 1},
	},
  },
  [29] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 10000},
	  {'钱币', 1},
	},
  },
  [30] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 10000},
	  {'钱币', 1},
	},
  },
  [31] = {
    ['Exp'] = 10000,
    ['Get'] = {
	  {'宝石', 15000},
	  {'钱币', 1},
	},
  },
  [32] = {
    ['Exp'] = 30000,
    ['Get'] = {
	  {'宝石', 30000},
	  {'钱币', 1},
	},
  },
}

local MainMenu =
[[
升级称号以及查询自己称号经验值^
^
<『$00FFFF00| 升级 称号』/@sj>^

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
  
  if aStr == 'cx' then
    P_MenuSay(uSource, string.format('当前称号经验: %d', P_GetTempArr(uSource, 16)));
    return;
  end;
  
  if aStr == 'sj' then
    --获取等级
	local id = P_GetRcurid(uSource);
	--获取升级经验
	local t = _data[id + 1];
	if t == nil then 
	  P_MenuSay(uSource, '已无法继续升级');
      return;
	end;
	--判断经验
	--local PlayExp = P_GetTempArr(uSource, 16);
	--if PlayExp < t['Exp'] then 
	  --P_MenuSay(uSource, '经验不足,升级需要经验: ' .. t['Exp']);
      --return;
	--end;
	--判断材料
    for i, v in pairs(t['Get']) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('缺少 %d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(t['Get']) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '称号使者');
      end
    end;
	--写入经验
    --屏蔽了经验P_SetTempArr(uSource, 16, PlayExp - t['Exp']);
	--写入等级
	P_SetRcurid(uSource, id + 1);
	--说话
	P_MenuSay(uSource, string.format('恭喜你称号升级到了[%d级]', id + 1));
	--发送全服公告
	M_topmsg(string.format('称号使者:恭喜[%s]称号升级到了[%d级]', B_GetRealName(uSource), id + 1), 33023);
    return;
  end;

 return;
end