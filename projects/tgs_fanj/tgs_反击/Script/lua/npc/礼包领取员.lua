package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '礼包领取员';

local MainMenu =
[[
注意:每个角色只可以领取一次礼包^^
<『$00FFFF00| 输入卡号领取礼包』/@srkh>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'srkh' then
    --弹出输入框
    P_MsgConfirmDialog(uSource, uDest, 110, '请输入开区礼包卡号');
    return;
  end;
 return;
end


function OnConfirmDialog(uSource, uDest, key, aStr)
  --判断KEY
  if key == 110 then 
    --检测卡号
	local n = string.len(aStr);
    if n < 1 or n > 12 then 
      P_MenuSay(uSource, '礼包卡号输入错误');
      return;
    end
    --获取用户名
    local PlayName = B_GetRealName(uSource);    
	--判断礼包是否存在
	local SQL = string.format('SELECT id, items, name, type, max, torece, JSON_EXTRACT(data, \'$."%s"\') as num FROM card_read LEFT JOIN card ON card_read.cardid = card.id WHERE card_read.cardno = \'%s\' and card.state = 0 and card.endtime > UNIX_TIMESTAMP();', PlayName, aStr);
    --_Log(SQL);
	local Data = M_GetMySqlDataSet(SQL);
    --判断读取MYSQL状态
    if Data == -1 or Data == nil or Data[1] == nil then
      P_MenuSay(uSource, '礼包码错误');
      return 'true';
    end;
	--如果0类型 判断卡号是否使用过
	local atype = tonumber(Data[1]['type']) or 0;
	local torece = Data[1]['torece'];
	if atype == 0 then 
	  if torece == 'True' then 
        P_MenuSay(uSource, '礼包码已经使用');
        return 'true';
	  end;
	end;
	--判断玩家使用次数
	local anum = tonumber(Data[1]['num']) or 0;
	local amax = tonumber(Data[1]['max']) or 0;
	if anum >= amax then 
	  P_MenuSay(uSource, string.format('此礼包限制使用%d次', amax));
	  return 'true';
	end;
	--给与道具
    local items = lua_Strtotable(Data[1]['items'], ';');
    local name = Data[1]['name'];
    if #items < 1 or name == '' then
      return 'true';
    end;
	--判断物品栏空位
	if P_getitemspace(uSource) < #items then
      P_MenuSay(uSource, string.format('需要%d个物品栏位置', #items));
      return;
	end;
	--写入数据
	--分类0 修改卡号已使用
	if atype == 0 then 
      M_DoMySql(string.format('UPDATE card_read SET torece = 1, playname =\'%s\', atime = %d WHERE cardno = \'%s\';', PlayName, os.time(), aStr));
	end;
	--修改玩家丹使用次数
	M_DoMySql(string.format('UPDATE card SET data = JSON_SET(IFNULL(JSON_EXTRACT(data, \'$\'), \'{}\'), \'$."%s"\', %d) WHERE id = %d;', PlayName, anum + 1, Data[1]['id']));
	--给予道具
    for i, v in pairs(items) do
      local t = lua_Strtotable(v, ':'); 
      if type(t) == 'table' then
        P_additem(uSource, t[1], t[2], name);
      end
    end;
    P_MenuSay(uSource, string.format('兑换了%s', name));
    return;    
  end;
 return;
end