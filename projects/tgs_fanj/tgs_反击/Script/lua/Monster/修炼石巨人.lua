package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');
dofile('Script\\lua\\plug\\table.lua')

--变量记录
Var = {
  --数据保存路径
  File = "Tgsplus\\石头人.sdb",
  --数据
  data = {
  },
}

--读取数据库
Var.Load = function()
  if file_exists(Var.File) then
    Var.data = table.load(Var.File)
  end
end

--保存数据库
Var.Save = function()
  table.save(Var.data, Var.File)
end

--读取数据
Var.Load();

--刷新触发
function OnRegen(uDest)
  Var.data[uDest] = os.time() + 180;
  Var.Save();
end;


--定时触发
function OnUpdate(uDest, CurTick)
  if Var.data[uDest] ~= nil and Var.data[uDest] < os.time() then 
	local Max = B_GetMaxLife(uDest) + 1;
	B_ChangeLife(uDest, 0 - Max);
    --B_ReToturnDamage(uDest, uDest, 100, 100);
  end;
end	