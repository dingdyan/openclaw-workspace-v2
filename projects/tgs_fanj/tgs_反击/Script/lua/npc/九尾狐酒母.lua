package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '九尾狐酒母';

--随机物品(物品名,数量)
Randomitem = {
  {'男子妖华袍', 1},
  {'女子妖华袍', 1},
  {'男子利齿靴', 1},
  {'女子利齿靴', 1},
  {'驱魔烈火弓', 1},
  {'四季甲胄', 1},
  {'炎帝火灵斧', 1},
  {'狼牙戟', 1},
  {'月光刀', 1},
  {'龙光剑', 1},
  {'狐狸手套', 1},
  {'男子妖华帽', 1},
  {'女子妖华帽', 1},
  {'男子月光护腕', 1},
  {'女子月光护腕', 1},
}

local MainMenu =
[[拿99朵白玫瑰可以换狐狸内丹^^
<「游标.bmp」『$FF00FF00| 用白玫瑰取狐狸内丹』/@make>^
]];

local RsMenu =
[[要脱色多少个红玫瑰呢?^^
<「游标.bmp」『$FF00FF00| 脱色1个红玫瑰』/@rs_1>^
<「游标.bmp」『$FF00FF00| 脱色5个红玫瑰』/@rs_5>^
<「游标.bmp」『$FF00FF00| 脱色10个红玫瑰』/@rs_10>^
<「游标.bmp」『$FF00FF00| 脱色身上所有红玫瑰』/@rs_all>^
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == "neidan" then
      --1,检测道具
      if P_getitemcount(uSource, '狐狸内丹') < 1 then 
         P_MenuSay(uSource, '弄来狐狸内丹?');
        return;
      end;
      --检测包裹
      if P_getitemspace(uSource) < 1 then
	     P_MenuSay(uSource, '物品栏已满....');
        return;
      end;
      --随机获取东西table
      local AwardItem = {};
      AwardItem = Randomitem[math.random(#Randomitem)];
      if AwardItem == nil then
       return;
      end;
      --删除物品
      P_deleteitem(uSource, '狐狸内丹', 1, '狐狸内丹');
      --给予物品
      P_additem(uSource, AwardItem[1], AwardItem[2], '狐狸内丹');
      --说话
	  P_MenuSay(uSource, '非常贵重....要妥善保管');
	  --公告
	  M_topmsg(string.format('九尾狐酒母:[%s]兑换到了[%s]', B_GetRealName(uSource), AwardItem[1]), 16754943);
    return;
  end;

  if aStr == 'rs' then
     P_MenuSay(uSource, RsMenu);
    return;
  end;

  if aStr == 'rs_1' then
    --检测道具
    if P_getitemcount(uSource, '玫瑰脱色药') < 1 then 
       P_MenuSay(uSource, '你没有1个玫瑰脱色药');
      return;
    end;
    if P_getitemcount(uSource, '红玫瑰') < 1 then 
       P_MenuSay(uSource, '缺少红玫瑰');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '玫瑰脱色药', 1, '九尾狐酒母');
    P_deleteitem(uSource, '红玫瑰', 1, '九尾狐酒母');
    --给道具
    P_additem(uSource, '白玫瑰', 1, '九尾狐酒母');
    --返回提示
	P_MenuSay(uSource, '成功脱色了1个红玫瑰');
    return;
  end;

  if aStr == 'rs_5' then
    --检测道具
    if P_getitemcount(uSource, '玫瑰脱色药') < 5 then 
       P_MenuSay(uSource, '你没有1个玫瑰脱色药');
      return;
    end;
    if P_getitemcount(uSource, '红玫瑰') < 5 then 
       P_MenuSay(uSource, '缺少红玫瑰');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '玫瑰脱色药', 5, '九尾狐酒母');
    P_deleteitem(uSource, '红玫瑰', 5, '九尾狐酒母');
    --给道具
    P_additem(uSource, '白玫瑰', 5, '九尾狐酒母');
    --返回提示
	P_MenuSay(uSource, '成功脱色了5个红玫瑰');
    return;
  end;

  if aStr == 'rs_10' then
    --检测道具
    if P_getitemcount(uSource, '玫瑰脱色药') < 10 then 
       P_MenuSay(uSource, '你没有1个玫瑰脱色药');
      return;
    end;
    if P_getitemcount(uSource, '红玫瑰') < 10 then 
       P_MenuSay(uSource, '缺少红玫瑰');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '玫瑰脱色药', 10, '九尾狐酒母');
    P_deleteitem(uSource, '红玫瑰', 10, '九尾狐酒母');
    --给道具
    P_additem(uSource, '白玫瑰', 10, '九尾狐酒母');
    --返回提示
	P_MenuSay(uSource, '成功脱色了5个红玫瑰');
    return;
  end;

  if aStr == 'rs_all' then
    --获取身上红玫瑰随量
	local num = P_getitemcount(uSource, '红玫瑰');
    if num <= 0 then 
       P_MenuSay(uSource, '没有红玫瑰');
      return;
    end;
	
    --检测玫瑰脱色药数量
    if P_getitemcount(uSource, '玫瑰脱色药') < num then 
       P_MenuSay(uSource, string.format('玫瑰脱色药不足%d个', num));
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '玫瑰脱色药', num, '九尾狐酒母');
    P_deleteitem(uSource, '红玫瑰', num, '九尾狐酒母');
    --给道具
    P_additem(uSource, '白玫瑰', num, '九尾狐酒母');
    --返回提示
	P_MenuSay(uSource, string.format('成功脱色了%d个红玫瑰', num));
    return;
  end;

  if aStr == 'make' then
    --检测道具
    if P_getitemcount(uSource, '白玫瑰') < 99 then 
       P_MenuSay(uSource, '白玫瑰不足99朵。');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '白玫瑰', 99, '九尾狐酒母');
    --给道具
    P_additem(uSource, '狐狸内丹', 1, '九尾狐酒母');
    --返回提示
	P_MenuSay(uSource, '换走狐狸内丹');
    return;
  end;

 return;
end