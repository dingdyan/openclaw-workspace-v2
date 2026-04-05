BornItem = {
  --出生给道具记录ID
  QuestArr = 19,
  --给的装备栏物品
   WearItem = {
   --男子
     [1] = { 
       {Name = '男子长发', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
       {Name = '男子上衣', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
       {Name = '男子短裤', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
     },
     --女子
     [2] = {
       {Name = '女子长发', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
       {Name = '女子上衣', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
       {Name = '女子短裙', Count =1, Color = 11, Grade = 0, Id = 0, SettingCount = 0, StarLevel = 0, Upgrade = 0, Attach = 0, createname = '', Durability = 0}, 
     },
   },
  --给的物品栏物品
  HaveItem = {
    --男子
    [1] = {
      {'新手汤药', 2000},
	  {'新手生药', 2000},
	  {'碧螺戒', 1}, 
      {'云纹金珠佩', 1}, 
      {'玉龙腰带', 1}, 
	  {'男子浪人道袍', 1}, 
      {'男子浪人斗笠', 1}, 
      {'男子浪人护腕', 1}, 
	  {'男子浪人鞋', 1},
    },
    --女子
    [2] = {
      {'新手汤药', 2000},
	  {'新手生药', 2000},
	  {'碧螺戒', 1}, 
      {'云纹金珠佩', 1}, 
      {'玉龙腰带', 1}, 
	  {'女子浪人道袍', 1}, 
      {'女子浪人斗笠', 1}, 
      {'女子浪人护腕', 1}, 
	  {'女子浪人鞋', 1},
    },
  }
}

--出生配置
BornItem.Start = function(uSource)
	--获取玩家配置状态
	local Value = P_GetTempArr(uSource, BornItem.QuestArr);
	if Value ~= 0 then return end;
	--获取玩家性别
	local sex = P_getsex(uSource);
	--给物品栏物品
	if BornItem.HaveItem[sex] ~= nil then
	  for i, v in pairs(BornItem.HaveItem[sex]) do
         if type(v) == 'table' then
           P_additem(uSource, v[1], v[2], '新人配置');
         end;
	  end;	
	end;
	--给装备栏物品
	 if BornItem.WearItem[sex] ~= nil then
	   for i, v in pairs(BornItem.WearItem[sex]) do
          if type(v) == 'table' then
            P_AddItemTabsToWear(uSource, v);
          end;
	   end;
	 end;
	--记录领取
	P_SetTempArr(uSource, BornItem.QuestArr, 1);
	--全服公告
    --M_topmsg(string.format('【系统公告】欢迎 %s 加入了武侠传', B_GetRealName(uSource)), 704508); 
    P_saysystem(uSource, '点击[向导]领取新手任务', 25);
  return;
end;