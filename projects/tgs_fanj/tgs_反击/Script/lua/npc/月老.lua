package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '月老';

--临时记录求婚对象
local _user = {};

--升段药
local Teach = {
   ['求婚戒指'] = {
      ['Set'] = {
         {'求婚戒指', 1}, 
      },
      ['Get'] = {
         {'白玫瑰', 99}, 
         {'金元', 50}, 
      },
   },
};

local MainMenu = [[
想求婚吗?请带来“求婚戒指”!^
『$000000FF|注意:求婚时只需要男方携带求婚戒指』^
请求婚双方人员面对面站立后发起求婚请求^^
<「游标.bmp」『$FF00FF00| 我要 求婚』/@qh>^^
<「游标.bmp」『$FF00FF00| 我要 离婚』/@lh>^
]];
--<「游标.bmp」『$00FFFF00| 合成 求婚戒指』/@dh_求婚戒指>^

local LHMenu = [[
『$000000FF|确认离婚吗?离婚请求方需要缴纳钱币100000!』^
^
<「游标.bmp」『$FF00FF00| 确认离婚』/@qrlh>^^
<「游标.bmp」『$FF00FF00| 我在想想』/@exit>^
]];


function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  --离婚
  if aStr == 'lh' then
    P_MenuSay(uSource, LHMenu);
    return;
  end;

  if aStr == 'qrlh' then
    --获取当前配偶
    if P_GetConsortName(uSource) == '' then 
      P_MenuSay(uSource, '身为一条单身狗你好意思来离婚?!');    
     return;
    end;
    --检测玩家道具
    if P_getitemcount(uSource, '钱币') < 100000 then 
      P_MenuSay(uSource, '请带来100000钱币');    
     return;
    end;
    P_deleteitem(uSource, '钱币', 100000, '月老');
    P_DelConsortName(uSource);
    P_MenuSay(uSource, '好吧 你已离婚成功...');
    return;
  end;

  --求婚
  if aStr == 'qh' then
    --检查物品栏密码状态    
    if P_GetItemPassBo(uSource) then 
      P_MenuSay(uSource, '请先取消物品栏密码');
      return;
    end
    --获取玩家性别
    local sex = P_getsex(uSource);
    if sex ~= 1 then 
      P_MenuSay(uSource, '女侠请您矜持点.');
      return;
    end
    --检测玩家道具
    if P_getitemcount(uSource, '求婚戒指') < 1 then 
      P_MenuSay(uSource, '大侠您的求婚戒指呢?');    
     return;
    end;
    --获取当前配偶
    if P_GetConsortName(uSource) ~= '' then 
      P_MenuSay(uSource, '冷静!大侠您不能得重婚罪啊!');    
     return;
    end;
    --继承目标    
    P_MsgConfirmDialog(uSource, uDest, 101, '请输入要求婚的对象名称');
    return;
  end;
  
  local Left, Right = lua_GetToken(aStr, '_');
  --升段药
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
	    P_deleteitem(uSource, v[1], v[2], '一代宗师');
      end
    end;
    --给道具
    for i, v in pairs(t.Set) do
      if type(v) == 'table' then 
        P_additem(uSource, v[1], v[2], '一代宗师');
      end
    end;
    P_MenuSay(uSource, string.format('请拿好你的%s……', Right));
	M_topmsg(string.format('月老:恭喜[%s]兑换了:求婚戒指', B_GetRealName(uSource)), 16754943);
    return;
  end;

 return;
end


function OnConfirmDialog(uSource, uDest, key, aStr)
  --判断KEY
  if key == 101 then 
    --检测账号
    if aStr == '' or string.len(aStr) > 12 then 
      P_MenuSay(uSource, '请输入要求婚的对象名称');
      return;
    end
    --判断是否在屏幕内
    local uObject, BoFind = B_FindObjectByName(uSource, aStr, 1);
    if not BoFind then 
       P_MenuSay(uSource, string.format('对象[%s]不在您身边', aStr));
      return;
    end;
    --获取自己坐标
    local aMapId, aX, aY =  B_GetPosition(uSource);
    --获取对象坐标
    local bMapId, bX, bY =  B_GetPosition(uObject);
    --判断自己前方坐标
    local nX, nY = B_GetNextXY(uSource);
    if nX ~= bX or nY ~= bY then 
      P_MenuSay(uSource, string.format('对象[%s]不在您前方', aStr));
      return;
    end
    --判断对象前方坐标
    local nX, nY = B_GetNextXY(uObject);
    if nX ~= aX or nY ~= aY then 
      P_MenuSay(uSource, string.format('请让[%s]面对着您', aStr));
      return;
    end
    --获取玩家性别
    local sex = P_getsex(uSource);
    if sex ~= 1 then 
      P_MenuSay(uSource, '女侠请您矜持点.');
      return;
    end
    --获取玩家性别
    local sex = P_getsex(uObject);
    if sex ~= 2 then 
      P_MenuSay(uSource, '大侠,对面不是女性啊?');
      return;
    end
    --获取当前配偶
    if P_GetConsortName(uObject) ~= '' then 
      P_MenuSay(uSource, '大侠,对方可是有夫之妇!');    
     return;
    end;
    --记录账号
	local RealName = B_GetRealName(uSource);
    _user[aStr] = RealName;
    P_saysystem(uSource, '请求已发送,请等待对方应答!', 14);
    --发送提示框
    P_MsgPromptDialog(uObject, uDest, 102, string.format('[%s]发起了求婚,您愿意答应他吗?', RealName));
  elseif key == 102 then 
    local RealName = B_GetRealName(uSource);
    if _user[RealName] == nil then 
      return;
    end
    --获取玩家性别
    local sex = P_getsex(uSource);
    if sex ~= 2 then 
      P_MenuSay(uSource, '女方才可以答应求婚.');
      return;
    end
    --判断是否在屏幕内
    local uObject, BoFind = B_FindObjectByName(uSource, _user[RealName], 1);
    if not BoFind then 
       P_MenuSay(uSource, string.format('对象[%s]不在您身边', _user[RealName]));
      return;
    end;
    --获取自己坐标
    local aMapId, aX, aY =  B_GetPosition(uSource);
    --获取对象坐标
    local bMapId, bX, bY =  B_GetPosition(uObject);
    --判断自己前方坐标
    local nX, nY = B_GetNextXY(uSource);
    if nX ~= bX or nY ~= bY then 
      P_MenuSay(uSource, string.format('对象[%s]不在您前方', _user[RealName]));
      return;
    end
    --判断对象前方坐标
    local nX, nY = B_GetNextXY(uObject);
    if nX ~= aX or nY ~= aY then 
      P_MenuSay(uSource, string.format('请让[%s]面对着您', _user[RealName]));
      return;
    end
    --获取玩家性别
    local sex = P_getsex(uObject);
    if sex ~= 1 then 
      P_MenuSay(uSource, '求婚对象不能是同性');
      return;
    end
    --获取当前配偶
    if P_GetConsortName(uObject) ~= '' then 
      P_MenuSay(uSource, '求婚对象不能有配偶!');    
     return;
    end;
    --删除对方求婚戒指
    if not P_deleteitem(uObject, '求婚戒指', 1, '月老') then 
      P_MenuSay(uSource, '对方没有求婚戒指!');    
     return;
    end;
    --结婚
    if not P_SetConsortName(uObject, RealName) then 
      P_MenuSay(uSource, '系统错误,请联系管理员!');    
     return;
    end;
    M_worldnoticemsg(string.format('月老:恭喜[%s]与[%s]结为夫妻!', _user[RealName], RealName), 33023, 3355443);    
  end;
 return;
end

--获取验证码
function generate_code(length)
  local min = math.pow(10 , (length - 1));
  local max = math.pow(10, length) - 1;
  math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
  math.random();math.random();math.random();
  return math.random(min, max);
end;
