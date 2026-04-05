package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest老板娘';

local delitem = {
  ['八卦牌1'] = 1,
  ['八卦牌2'] = 1,
  ['八卦牌3'] = 1,
  ['八卦牌4'] = 1,
  ['八卦牌5'] = 1,
  ['八卦牌6'] = 1,
  ['八卦牌7'] = 1,
  ['八卦牌8'] = 1,
  ['八卦牌9'] = 1,
  ['八卦牌10'] = 1,
  ['八卦牌11'] = 1,
  ['八卦牌12'] = 1,
  ['八卦牌13'] = 1,
  ['八卦牌14'] = 1,
  ['八卦牌15'] = 1,
  ['不羁浪人手套1'] = 1,
  ['不羁浪人手套2'] = 1,
  ['不羁浪人手套3'] = 1,
  ['不羁浪人剑1'] = 1,
  ['不羁浪人剑2'] = 1,
  ['不羁浪人剑3'] = 1,
  ['不羁浪人刀1'] = 1,
  ['不羁浪人刀2'] = 1,
  ['不羁浪人刀3'] = 1,
  ['不羁浪人枪1'] = 1,
  ['不羁浪人枪2'] = 1,
  ['不羁浪人枪3'] = 1,
  ['不羁浪人槌1'] = 1,
  ['不羁浪人槌2'] = 1,
  ['不羁浪人槌'] = 1,
};

local MainMenu =
[[
老朽的孙女什么时候才能恢复笑容啊.^^
<「游标.bmp」『$00FFFF00| 取得书札』/@quest>^
<「游标.bmp」『$00FFFF00| 递上玩具』/@pendent>^
<「游标.bmp」『$00FFFF00| 销毁八卦牌以及不羁浪人武器』/@destroy>
]];

local MainMenu_1 =
[[
呵呵 ..是铁匠让你来的?来的正好.看见没有,^
站在那里的女孩儿?她是我的孙女.看她一脸的不高兴.^
我这孙女什么都好就是脾气太要强了,怎么都不肯说^
发生了什么事儿.好不容易才问出来.原来在去那儿的^
途中将老夫亲手做给她的玩具给弄丢了.^
^
<「游标.bmp」『$00FFFF00| 丢到哪儿了?』/@q1_next>
]];

local MainMenu_2 =
[[
玉仙说,就是因为在路上碰上浑身都是白毛的家伙,^
逃跑的时候掉的.^
我在想是不是丢到白老虎林了.^
我想亲自跑一趟,可这儿又离不开...唉^
^
<「游标.bmp」『$00FFFF00| 帮她找回』/@find>^
<「游标.bmp」『$00FFFF00| 离开』/@rejection>
]];

local MainMenu_3 =
[[
是真的吗?铁匠果真有眼力.玩具确实是白老虎林^
的白老虎叼着呢.找到之后马上拿给我.不会少了报酬的!!"^
^
<「游标.bmp」『$00FFFF00| 好的』/@close_1>
]];

local MainMenu_4 =
[[
对...正是此物,是我亲手做给她的.办事效率这么快.^
让老夫刮目相看啊.稍等...!!^
你看玉仙脸上又出现了笑容!!多亏了你.呵呵!!拿着,^
这是你应得的.这也是老夫承诺过的.虽然只是个玩具,^
但阁下绝对有资格拿它.!!
]];

local MainMenu_5 =
[[
还没找到? 看玉仙愁容满面的样子,老夫痛在心里啊!^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  --销毁道具
  if aStr == 'destroy' then
    P_MenuSay(uSource, '请放入需要销毁的八卦牌或不羁武器^^<「游标.bmp」『$00FFFF00| 确认销毁』/@qrdestroy>', true);
    P_ItemInputWindowsOpen(uSource, 0, '销毁道具', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  if aStr == 'qrdestroy' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 47 then 
      P_MenuSay(uSource, '请放入需要销毁的道具');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData == nil or aItemData.Name == '' or delitem[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入道具或道具无法销毁!');
      return;
	end;
    if P_getitemcount(uSource, '钱币') < 5000 then
      P_MenuSay(uSource, '连5000个钱币都没有吗?');
     return;
    end;
    P_deleteitem(uSource, '钱币', 5000, 'quest老侠客');
	P_DelHaveItemInfo(uSource, aKey, 1);
	P_MenuSay(uSource, '道具销毁成功!');
    return;
  end;

  if aStr == 'quest' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '铁匠书札') < 1 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '药材商书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '风兄书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '老侠客书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    P_MenuSay(uSource, MainMenu_1);
    return;
  end;
  if aStr == 'q1_next' then
    P_MenuSay(uSource, MainMenu_2);
    return;
  end;
  if aStr == 'find' then
    P_MenuSay(uSource, MainMenu_3);
    return;
  end;
  if aStr == 'rejection' then
    return;
  end;
  if aStr == 'close_1' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '铁匠书札') < 1 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '药材商书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '风兄书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '老侠客书札') > 0 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    P_deleteitem(uSource, '铁匠书札', 1, 'quest老侠客');
    P_additem(uSource, '老侠客书札', 1, 'quest老侠客');	
    return;
  end;

  if aStr == 'pendent' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '老侠客书札') < 1 then
      P_MenuSay(uSource, '呵呵._真无聊._再见.');
     return;
    end;
    if P_getitemcount(uSource, '玩具') < 1 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;
    P_deleteitem(uSource, '玩具', 1, 'quest老侠客');
    P_deleteitem(uSource, '老侠客书札', 1, 'quest老侠客');
	P_MenuSay(uSource, MainMenu_4);

     math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     math.random();
     local iRandom = math.random(3, 4);
     if iRandom == 0 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
	      return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
       return;
     end;
     if iRandom == 1 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(6), ':');
	    if #AwardItem ~= 2 then 
	      return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
       return;
     end;
     if iRandom == 2 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(7), ':');
	    if #AwardItem ~= 2 then 
	      return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
       return;
     end;
     if iRandom == 3 then
	    if P_getitemcount(uSource, '招式全集') > 0 then
	      --随机给物品
	      local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	      if #AwardItem ~= 2 then 
	        return;
	      end
	      P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
		  return;
	    end;
		P_additem(uSource, '招式全集', 1, 'quest老侠客');	
       return;
     end;
     if iRandom == 4 then
	    if P_getitemcount(uSource, '四大神功全集') > 0 then
	      --随机给物品
	      local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	      if #AwardItem ~= 2 then 
	        return;
	      end
	      P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
		  return;
	    end;
		P_additem(uSource, '四大神功全集', 1, 'quest老侠客');	
       return;
     end;
    return;
  end;
  if aStr == 'close_2' then
    return;
  end;
  if aStr == 'continue' then
    return;
  end;
  if aStr == 'giveup' then
    P_deleteitem(uSource, '老侠客书札', 1, 'quest老侠客');
    return;
  end;
 return;
end