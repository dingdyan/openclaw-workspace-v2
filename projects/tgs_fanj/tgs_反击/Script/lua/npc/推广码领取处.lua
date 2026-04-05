package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local WxItem = {
  {'新手生药', 500},
  {'新手汤药', 500},
};

local Npc_Name = '一级向导';

local MainMenu =
[[
输入序列号领取^
<『$00FFFF00| 领取微信礼包』/@wxlb>^
]];

local WXMenu =
[[
微信礼包领取请添加微信[xxxx]^
添加微信后发送[领取礼包]进行领取^
注意:每个角色只可以领取一次礼包,包含各类新手药品500个^
『$0080FF80|防止输入错误建议使用复制粘贴输入礼包卡号』^^
<『$00FFFF00| 输入卡号领取礼包』/@srwxkh>
]];


function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  --微信礼包
  if aStr == 'wxlb' then
    --获取VIP信息
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
      P_MenuSay(uSource, '未避免小号刷礼包,请充值成为VIP后领取!');
      return 'true';
    end;
    P_MenuSay(uSource, WXMenu);
    return;
  end;

  if aStr == 'srwxkh' then
    P_MsgConfirmDialog(uSource, uDest, 110, '请输入微信礼包卡号');
    return;
  end;

 return;
end

function OnConfirmDialog(uSource, uDest, key, aStr)
  --判断KEY
  if key == 110 then 
    --检测卡号
    if string.len(aStr) ~= 12 then 
      P_MenuSay(uSource, '礼包卡号输入错误');
      return;
    end
    --判断背包
    if P_getitemspace(uSource) < #WxItem then
      P_MenuSay(uSource, string.format('请保留%d个背包空位', #WxItem));
     return;
    end; 
    --获取用户名
    local PlayName = B_GetRealName(uSource);    
    --判断用户名是否已存在
    local Data = M_GetMySqlDataSet(string.format('SELECT card FROM mqn_kaiqn_card WHERE playname = "%s" LIMIT 0, 1;', PlayName));
    --判断读取MYSQL状态
    if Data ~= nil and Data[1] ~= nil then
      P_MenuSay(uSource, '每个角色只可领取一次');
      return;
    end;
    --读取礼包卡号是否存在
    local Data = M_GetMySqlDataSet(string.format('SELECT playname FROM mqn_kaiqn_card WHERE card = "%s" LIMIT 0, 1;', aStr));
    --判断读取MYSQL状态
    if Data == -1 or Data == nil or Data[1] == nil or string.len(Data[1]['playname']) ~= 0 then
      P_MenuSay(uSource, '输入礼包卡号不存在或者已被使用');
      return;
    end;
    --写入数据库
    local SQL = string.format('UPDATE mqn_kaiqn_card SET playname = \'%s\' WHERE card = \'%s\'', PlayName, aStr);
    if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '礼包领取失败,请联系管理员!', 2);
       return;        
    end;
    --给予道具
    for i, v in pairs(WxItem) do
      if type(v) == 'table' then
        P_additem(uSource, v[1], v[2], '微信礼包');
      end
    end;
    P_MenuSay(uSource, '恭喜,成功领取了微信礼包');
    return;  
  end;
 return;
end