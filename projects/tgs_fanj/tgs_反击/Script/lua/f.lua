--分割字符
function lua_GetToken(astr, split_char)
  local zstr = astr;
  i, n = string.find(zstr, split_char);
  if i == nil then
    return astr, '';
  end
  Left = string.sub(zstr, 1, i - 1);
  right = string.sub(zstr, n + 1, -1);
  return Left, right;
end;

--分割字符,转为tab
function lua_Strtotable( str,reps )
  local StrList = {}
  if str ~= nil then 
    string.gsub(str,'[^'..reps..']+', function(w)
		local n = tonumber(w);
		if n then
          table.insert(StrList, n)
		else
          table.insert(StrList, w)
		end
    end)
  end
  return StrList
end

--转SDB为table
function lua_SdbValidStr(sdb, Valid)
  local file = io.open(sdb, "r");
  if file == nil then return end;
  local data = {};
  local key = {};
  local i = 0;
  for line in file:lines() do
    if #line < 1 then 
	  return data;
	end;
    if i == 0 then 
      key = lua_Strtotable(line, ',');
    else
      local t = lua_Strtotable(line, ',');
	  data[t[1]] = {};
      for k = 1, #key do
        if Valid[key[k]] == 2 then 
	      data[t[1]][key[k]] = {};
          local _t = lua_Strtotable(t[k], ';');
		  for m = 1, #_t do
	        data[t[1]][key[k]][m] = lua_Strtotable(_t[m], ':');
		  end
        elseif Valid[key[k]] == 1 then 
	     data[t[1]][key[k]] = lua_Strtotable(t[k], ':');
	    else 
          data[t[1]][key[k]] = t[k];	
	    end;
      end;
    end;
    i = i + 1;
  end
  file:close();
  return data;
end

--[[
function lua_Strtotable(str, pat)
  local t = {};
  if str ~= nil then
   local fpat = "(.-)" .. pat;
   local last_end = 1;
   local s, e, cap = str:find(fpat, 1);
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t, cap);
      end;
      last_end = e+1;
      s, e, cap = str:find(fpat, last_end);
   end;
   if last_end <= #str then
      cap = str:sub(last_end);
      table.insert(t, cap);
   end;
  end;
 return t;
end;--]]

--对比时间
function lua_ContrastDate(timea, timeb)
  t1 = timea;
  t2 = timeb;
  day1 = {};
  day2 = {};
  day1.year,day1.month,day1.day = string.match(t1,"(%d%d%d%d)-(%d%d)-(%d%d)");
  day2.year,day2.month,day2.day = string.match(t2,"(%d%d%d%d)-(%d%d)-(%d%d)");
  numDay1 = os.time(day1);
  numDay2 = os.time(day2);
  return (numDay1-numDay2)/(3600*24);
end;

--检查文件是否存在
function file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

--秒到时间文本转换
function timestostring(s)
  if type(s) ~= 'number' then 
    s = tonumber(s) or 0;
  end;
  return string.format('%d时%d分%d秒', s // 3600, s % 3600 // 60, s % 60)
end;

--去除table重复
function TableDieRepeat(arr)
  local newarr = {};
  local length, isExist = 1, false;
  -- 循环数组
  for i=1, #arr do
	--循环新数组
	for j=1, #newarr do  
	  if newarr[j] == arr[i] then 
		isExist = true
	  end
	end 
	--如果没有重复改变数组值
	if not isExist then
      newarr[length] = arr[i];  
	  length = length + 1;
	  isExist = false;
	end;
  end
  --  table.setn(arr, length)
  return newarr;  
end

--时间格式化
function time_format(time, format) 
	if tonumber(time) == nil then 
		time = os.time();
	end
	if format == nil then 
		format = "%Y-%m-%d %H:%M:%S";
	end
    return os.date(format, time)
end

--文本转时间戳
function strtostamp(str) 
  if type(str) ~= 'string' or str == '1899-12-30' then return 0 end
  local fun = string.gmatch(str, "%d+")
  local y = fun() or 0;
  local m = fun() or 0;
  local d = fun() or 0;
  local H = fun() or 0;
  local M = fun() or 0;
  local S = fun() or 0;
  local r = os.time({year=y, month=m, day=d, hour=H, min=M, sec=S});
  if r == nil or r <= 0 then r = 0 end;
  return r;
end

--[[function strtostamp(str) 
  local t = lua_Strtotable(str, ' ');
  local tDate = lua_Strtotable(t[1], '-');
  local tTime = lua_Strtotable(t[2], ':');
  local d = {year = tDate[1], month = tDate[2], day = tDate[3], hour = tTime[1], min = tTime[2], sec = tTime[3]};
  local f = os.time(d);
  if f == nil then f = 0 end;
 return f;
end--]]

--获取任务奖励字符
function GetQuestAwardStr(Award)
	local Str = '';
	for i, v in pairs(Award) do
		if type(v) == 'table' then
			Str = string.format('%s%s#%d#%d', Str, v[1], v[3], v[4])
			if i ~= #Award then Str = Str .. ';' end;
		end
	end;
	return Str;
end;

function isTable(value)
  if type(value) ~= "table" then
    value = {}
  end
  return value
end

function countNums(value)
  local count = 0
  local value = isTable(value)
  for k, v in pairs(value) do
    count = count + 1
  end
  return count
end

--lua table 拷贝
function table_copy_table(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil
    end
    local new_tab = {}
    for i,v in pairs(ori_tab) do
        local vtyp = type(v)
        if (vtyp == "table") then
            new_tab[i] = table_copy_table(v)
        elseif (vtyp == "thread") then
            new_tab[i] = v
        elseif (vtyp == "userdata") then
            new_tab[i] = v
        else
            new_tab[i] = v
        end
    end
    return new_tab
end

--用于属性表的索引信息
AttribIndex = {
  ['damageBody'] = '攻击',  ['damageHead'] = '头攻',   ['damageArm'] = '手攻',   ['damageLeg']    = '脚攻',
  ['armorBody']  = '防御',  ['armorHead']  = '头防',   ['armorArm']  = '手防',   ['armorLeg']     = '脚防',
  ['AttackSpeed']= '速度',  ['accuracy']   = '命中',   ['avoid']     = '闪躲',   ['KeepRecovery'] = '维持',  ['recovery'] = '恢复',
  ['Life'] = '活力', ['HitAdd'] = '加伤', ['HitDel'] = '减伤', ['ZDL'] = '战力', ['BowBodyArmor'] = '远程防御',
};

--取属性table字符信息
function _GetAttribInfo(LifeData)
  local t ='';
  for key, value in pairs(LifeData) do 
    if value ~= 0 and AttribIndex[key] ~= nil then 
	  if key == 'ZDL' then 
	    t = string.format('%s[%s:%0.2f]', t, AttribIndex[key], value // 100);
	  else
	    t = string.format('%s[%s:%d]', t, AttribIndex[key], value);
	  end; 
	end
  end;
  if t == '' then 
    t = '无属性';
  end
 return t
end;

math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
math.random();