package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');


function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 15);
     return;
   end

   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name ~= '雁翎飞天刀' then
     return;
   end;
    --检测是否修炼
    MagicLevel1 = P_GetMagicLevel(uSource, '无极玄功拳');
      if MagicLevel1 > 0 then 
         P_saysystem(uSource, '自创武学最多只能修炼一本', 15);
      return; 
    end;
	--检测是否修炼
    MagicLevel1 = P_GetMagicLevel(uSource, '韦陀伏魔剑');
      if MagicLevel1 > 0 then 
         P_saysystem(uSource, '自创武学最多只能修炼一本', 15);
      return; 
    end;
	--检测是否修炼
    MagicLevel1 = P_GetMagicLevel(uSource, '雁翎飞天刀');
      if MagicLevel1 > 0 then 
         P_saysystem(uSource, '自创武学最多只能修炼一本', 15);
      return; 
    end;
	--检测是否修炼
    MagicLevel1 = P_GetMagicLevel(uSource, '紧罗那王枪');
      if MagicLevel1 > 0 then 
         P_saysystem(uSource, '自创武学最多只能修炼一本', 15);
      return; 
    end;
	--检测是否修炼
    MagicLevel1 = P_GetMagicLevel(uSource, '回风落雁槌');
      if MagicLevel1 > 0 then 
         P_saysystem(uSource, '自创武学最多只能修炼一本', 15);
      return; 
    end;

    if P_AddMagicAndLevel(uSource, '雁翎飞天刀', 100) then
       P_deleteitem(uSource ,ItemData.Name ,1,'雁翎飞天刀');
       P_saysystem(uSource, '学习[雁翎飞天刀]成功!', 15);
	 return;
      end
       return;
      end