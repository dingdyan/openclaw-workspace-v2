package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local _List = {
  [1] = '日月神功',
  [2] = '北冥神功',
  [3] = '紫霞神功',
  [4] = '血天魔功',
};

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 15);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name ~= '神功卷轴' then
     return;
   end;
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --循环判断学习武功
   for k = 1, #_List do
     --检测武功是否重复
     if P_GetMagicLevel(uSource, _List[k]) > 0 then 
       P_saysystem(uSource, '已经学习了[' .. _List[k] ..'] 卷轴无效', 15);
      return;
     end
   end
   --随机给本武功
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();
   local AddMagic = _List[math.random(#_List)];
   --学习武功
   if not P_AddMagicAndLevel(uSource, AddMagic, 100) then 
     P_saysystem(uSource, '学习[' .. AddMagic ..']失败!', 15);
    return;
   end
   --返回消息
   P_saysystem(uSource, string.format('开启 %s 学习到了:%s', ItemData.Name, AddMagic), 15);
 return;
end