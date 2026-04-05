ShenShou = {
  --系统介绍文本
  Text = '激活青龙后有几率触发龙息技能提高伤害^激活白虎后提高自身命中和闪躲，有几率触发虎啸技能提高伤害范围^【必须开启灵动八方辅助才能触发】^激活朱雀可以提高自身活力值^激活玄武后有几率触发冥甲技能抵挡攻击伤害',
  --开启的元气
  Energy = 8000,
  --数据配置
  Data = {
    --青龙
    [0] = lua_SdbValidStr('Script\\lua\\sdb\\圣兽0.sdb', {Get=2,attrib=2}),
    --白虎
    [1] = lua_SdbValidStr('Script\\lua\\sdb\\圣兽1.sdb', {Get=2,attrib=2}),
    --朱雀
    [2] = lua_SdbValidStr('Script\\lua\\sdb\\圣兽2.sdb', {Get=2,attrib=2}),
    --玄武
    [3] = lua_SdbValidStr('Script\\lua\\sdb\\圣兽3.sdb', {Get=2,attrib=2}),
  },
};

--转 Extra 为 table
ShenShou.ExtraTab = function()
  for i = 0, #ShenShou.Data do
    for n = 0, #ShenShou.Data[i] do
      if ShenShou.Data[i][n].ExtraTab == nil then
	    ShenShou.Data[i][n].ExtraTab = lua_StrValidTab(ShenShou.Data[i][n].Extra);
	  end;
    end;
  end;
end;

ShenShou.ExtraTab();

--上线属性触发
ShenShou.open = function(uSource)
  --获取等级
  local LvTab = lua_Strtotable(P_GetTempStr(uSource, 19), ';');
  if #LvTab ~= 4 then 
    return;
  end;
  --遍历叠加属性
  local LifeData = {};
  for i = 1, #LvTab do
    local Lv = LvTab[i];
    if Lv > 0 and ShenShou.Data[i - 1][Lv - 1] ~= nil then 
	  --增加属性
	  for _k,_v in pairs(ShenShou.Data[i - 1][Lv - 1].attrib) do
	    LifeData[_v[1]] = _v[2];		
	  end
	  LifeData.Extra = ShenShou.Data[i - 1][Lv - 1].Extra;
      P_SetAddLifeData(uSource, 10 + i, ShenShou.Data[i - 1][Lv - 1].Name, 3600*24*30, LifeData);
	end;
  end;
end;

--关闭属性
ShenShou.Del = function(uSource)
  --遍历叠加属性
  for i = 1, 4 do
    P_SetAddLifeData(uSource, 10 + i, '', 0, {});
  end;
  P_saysystem(uSource, '【系统提示】圣兽系统属性:已关闭', 25);
 return;
end;


--福利触发配置
ShenShou.UserSay = function(uSource, arg)
  --打开窗口
  if arg[2] == '0' then 
    -- --判断元气是否到达元气
    -- if P_GetAttrib(uSource).Energy < ShenShou.Energy then 
      -- P_saysystem(uSource, string.format('元气%0.2f开启', ShenShou.Energy / 100), 25);
      -- return;
    -- end;
	--发送各等级属性
	 for i = 0, #ShenShou.Data do
	   for n = 0, #ShenShou.Data[i] do
	    local str = string.format('&ss;1;%d;%d;%s;%s;%s;', i, n, ShenShou.Data[i][n].Name, ShenShou.GetItemStr(ShenShou.Data[i][n].Get, ShenShou.Data[i][n].Ran), ShenShou.GetAttribStr(ShenShou.Data[i][n].attrib, ShenShou.Data[i][n].ExtraTab));
        P_saysystem(uSource, str, 0);
	  end;
	end;
	--发送玩家等级
	ShenShou.SendLevel(uSource);
    --发送窗口打开数据
    P_saysystem(uSource, string.format('&ss;0;%s', ShenShou.Text), 0);
  --触发升级请求
  elseif arg[2] == '1' then 
	local atype = tonumber(arg[3]);
	local alevel = tonumber(arg[4]);
    if atype == nil or alevel == nil then 
      return;
    end;
	if atype < 0 or atype > 4 or alevel < 0 or alevel > 6 then 
      return;
    end;
	--获取等级
	local LvTab = lua_Strtotable(P_GetTempStr(uSource, 18), ';');
	if #LvTab ~= 4 then 
	  LvTab = {0, 0, 0, 0};
	end;
	if alevel ~= LvTab[atype + 1] then 
       P_saysystem(uSource, '不能跨等级突破', 25);
      return;
	end;
	--判断材料
    for i, v in pairs(ShenShou.Data[atype][alevel].Get) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_saysystem(uSource, string.format('需要%d个%s', v[2], v[1]), 25);
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(ShenShou.Data[atype][alevel].Get) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '圣兽');
      end
    end;
	--判断是否成功
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random(100);
	--判断是否失败
	if math.random(100) >= ShenShou.Data[atype][alevel].Ran then 
	  P_saysystem(uSource, '本可惜,本次突破失败了!!', 25);
	 return;
	end;
	--修改等级
	LvTab[atype + 1] = LvTab[atype + 1] + 1;
	--写入等级
	local str = '';
	for i = 1, #LvTab do
	  str = str .. LvTab[i] .. ';';
	end;
	P_SetTempStr(uSource, 18, str);
	--发送等级
	ShenShou.SendLevel(uSource);
	ShenShou.open(uSource);
    --提示
	P_saysystem(uSource, '突破成功', 25);
  end;
  
  return;
end;

ShenShou.SendLevel = function(uSource)
  P_saysystem(uSource, string.format('&ss;2;%s', P_GetTempStr(uSource, 19)), 0);
end;

ShenShou.GetItemStr = function(Award, Ran)
  local Str = '';
  for i, v in pairs(Award) do
    if type(v) == 'table' then
      Str = string.format('%s%s * %d^', Str, v[1], v[2]);
    end
  end;
  Str = string.format('%s解封机率%d%%^', Str, Ran);
  return Str;
end;


ShenShou.GetAttribStr = function(LifeData, ExtraTab)
  local t ='';
  for i = 1, #LifeData do
    if type(LifeData[i]) == 'table' then 
	  if LifeData[i][2] ~= 0 and AttribIndex[LifeData[i][1]] ~= nil then 
	    if LifeData[i][1] == 'ZDL' or LifeData[i][1] == 'Life' then 
	      t = string.format('%s%s:%0.2f^', t, AttribIndex[LifeData[i][1]], LifeData[i][2] // 100);
	    else
	      t = string.format('%s%s:%d^', t, AttribIndex[LifeData[i][1]], LifeData[i][2]);
	    end; 
	  end
	end;
  end;
  --特殊属性
  for i = 1, #ExtraTab do
    if type(ExtraTab[i]) == 'table' then 
	  if ExtraTab[i][2] ~= 0 and AttribIndex.Extra[ExtraTab[i][1]] ~= nil then 
	    local str = string.format(AttribIndex.Extra[ExtraTab[i][1]], ExtraTab[i][2], ExtraTab[i][3]);
	    t = string.format('%s%s^', t, str);
	  end
	end;
  end;
  if t == '' then 
    t = '无属性';
  end
 return t
end;
