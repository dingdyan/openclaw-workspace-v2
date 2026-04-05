package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local Npc_Name = '老板娘';

--奖励
Reward = {
  --数据保存路径
  File = "Tgsplus\\奖励记录.sdb",
  --数据
  data = {
    Energy = {},
  },
  --元气奖励
  Energy = {
    [1] = {
      ['Name'] = '至尊无上',
      ['Num'] = 3,
      ['Level'] = 10,
      ['Item'] = {
	    {'武神牌', 1},
		{'圆梦宝匣', 3},
		{'不灭体', 1},
	  },
	},
  },
}

--读取数据库
Reward.Load = function()
  if file_exists(Reward.File) then
    Reward.data = table.load(Reward.File)
  end
end

--保存数据库
Reward.Save = function()
  table.save(Reward.data, Reward.File)
end

--读取数据
Reward.Load();

local MainMenu =
[[廉价出售物品.高价收购物品,童叟无欺··^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^^
<「游标.bmp」『$FF00FF00| 卖 物品』/@sell>^^
<「游标.bmp」『$FF00FF00| 领取境界奖励』/@yqjl>^^
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
  
  --冲级奖励
  if aStr == 'yqjl' then
     --返回提示字符
     local str = '请选择要领取的境界奖励:{1}^^';
     for k = 1, #(Reward.Energy) do
       local n = 0;
	   if Reward.data.Energy[k] ~= nil then 
	     n = Reward.data.Energy[k].Num;
	   end;
	   str = string.format('%s<「游标.bmp」 『$FF00FF00|领取 %s 奖励 (剩余:%d个)』/@lqyq_%d>^', str, Reward.Energy[k]['Name'], Reward.Energy[k]['Num'] - n, k);	
     end;
	 P_MenuSay(uSource, str);
    return;
  end;
    
   --分割字符
  local Left, Right = lua_GetToken(aStr, "_");
  --领取元气
  if Left == 'lqyq' then
    local Index = tonumber(Right);
	if Index == nil then return end;
	--获取table数据
	local t = Reward.Energy[Index];
	if t == nil then return end;
	--获取玩家元气等级
	local PlayEnergy = P_GetEnergyLevel(uSource);
	--判断元气等级
	if PlayEnergy < t['Level'] then 
	  P_MenuSay(uSource, '您的境界等级不够');
     return;
	end
	--判断奖励数据
	if Reward.data.Energy[Index] == nil then 
      Reward.data.Energy[Index] = {
        ['Num'] = 0,
        ['Play'] = {},		
	  };
	end
	--判断领取数量
	if Reward.data.Energy[Index]['Num'] >= t['Num'] then 
	  P_MenuSay(uSource, '很抱歉,这个奖励被领取完了');
     return;
	end
	--判断自己是否领取
	local PlayName = B_GetRealName(uSource);
	if Reward.data.Energy[Index]['Play'][PlayName] ~= nil then 
	  P_MenuSay(uSource, '很抱歉,您不能重复领取这个奖励');
     return;
	end
    --检测背包空位
    if P_getitemspace(uSource) < #(t['Item']) then
      P_MenuSay(uSource, string.format('请保留%d个物品栏空位', table.getn(t['Item'])));
     return;
    end; 
    --给予道具
    for i, v in pairs(t['Item']) do
      if type(v) == 'table' then
        if v[1] == '天赋经验' then 
          P_SetnewTalentExp(uSource, P_GetnewTalentExp(uSource) + v[2]);
          P_LeftText(uSource, string.format('天赋经验 获得 %d 个', v[2]), 55769, 3);
        elseif v[1] == '钱币1' then 
          P_AddBindMoney(uSource, v[2]);
          P_LeftText(uSource, string.format('绑定钱币 获得 %d 个', v[2]), 55769, 3);
        else
          P_additem(uSource, v[1], v[2], '元气奖励');
        end
      end
    end;
    --改变数据
	Reward.data.Energy[Index]['Num'] = Reward.data.Energy[Index]['Num'] + 1;
	Reward.data.Energy[Index]['Play'][PlayName] = 1;
	--保存数据
	Reward.Save();
	--返回提示
	P_MenuSay(uSource, string.format('恭喜,您成功领取了%s奖励', t['Name']));
	--全服公告
	M_topmsg(string.format('恭喜[%s]以[第%d名]身份领取了[%s]奖励', PlayName, Reward.data.Energy[Index]['Num'], t['Name']), 33023, 3355443);
    return;
  end;
  return;
 end;