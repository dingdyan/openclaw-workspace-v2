package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '传送符';

--传送表,后面是地图ID,坐标X,坐标y,钱币
local Convey = {
   [1] = {
      ['Name'] = '中央市场', 
      ['money'] = 500, 
      ['Map'] = {1, 500, 500}, 
   }, 
   [2] = {
      ['Name'] = '帝 王 陵', 
      ['money'] = 500, 
      ['Map'] = {1, 709, 680}, 
   }, 
   [3] = {
      ['Name'] = '狐 狸 洞', 
      ['money'] = 500, 
      ['Map'] = {1, 127, 272}, 
   }, 

   [4] = {
      ['Name'] = '太极剑门', 
      ['money'] = 350, 
      ['Map'] = {1, 142, 715}, 
   }, 
   [5] = {
      ['Name'] = '刺客神殿', 
      ['money'] = 500, 
      ['Map'] = {1, 797, 683}, 
   }, 
   [6] = {
      ['Name'] = '侠 客 村', 
      ['money'] = 500, 
      ['Map'] = {1, 570, 600}, 
   }, 
   [7] = {
      ['Name'] = '书 生 村', 
      ['money'] = 500, 
      ['Map'] = {1, 305, 404}, 
   }, 
   [8] = {
      ['Name'] = '极 乐 寺', 
      ['money'] = 500, 
      ['Map'] = {1, 532, 814}, 
   }, 
   [9] = {
      ['Name'] = '犀牛森林', 
      ['money'] = 500, 
      ['Map'] = {1, 783, 532}, 
   }, 
   [10] = {
      ['Name'] = '石 头 山', 
      ['money'] = 500, 
      ['Map'] = {1, 747, 207}, 
   }, 
   [11] = {
      ['Name'] = '千 年 村', 
      ['money'] = 500, 
      ['Map'] = {1, 223, 230}, 
   },
   [12] = {
      ['Name'] = '白老虎场', 
      ['money'] = 500, 
      ['Map'] = {1, 220, 520}, 
   },
   [13] = {
      ['Name'] = '地下墓地', 
      ['money'] = 500, 
      ['Map'] = {1, 398, 711}, 
   },
   [14] = {
      ['Name'] = '帝王石谷', 
      ['money'] = 500, 
      ['Map'] = {1, 120, 874}, 
   },
   [15] = {
      ['Name'] = '老虎森林', 
      ['money'] = 500, 
      ['Map'] = {1, 414, 300}, 
   },
   [16] = {
      ['Name'] = '梅花夫人处', 
      ['money'] = 500, 
      ['Map'] = {1, 600, 180}, 
   },
   [17] = {
      ['Name'] = '高丽剑士宅', 
      ['money'] = 500, 
      ['Map'] = {1, 439, 183}, 
   },
   [18] = {
      ['Name'] = '极乐洞一馆', 
      ['money'] = 1000, 
      ['Map'] = {27, 44, 30}, 
   },
   [19] = {
      ['Name'] = '极乐洞二馆', 
      ['money'] = 1000, 
      ['Map'] = {28, 49, 23}, 
   },
   [20] = {
      ['Name'] = '极乐洞本馆', 
      ['money'] = 1000, 
      ['Map'] = {29, 29, 33}, 
   },
};

function OnItemDblClick(uSource, uItemKey, astr)
    local Str = '注意:血量100%才可以进行传送^^';
    for i = 1, #Convey do
      if type(Convey[i]) == 'table' then
        Str = string.format('%s<『$00FFFF00| %s』 交易币:%d/@pcs_%d>^', Str, Convey[i].Name, Convey[i].money, i);
      end;
    end;
   P_MenuSayItem(uSource, Str, Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
  
  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'pcs' then
    local t = Convey[tonumber(Right)];
    if t == nil then return end;
   --获取玩家地图ID和坐标
   local MapId, X, Y =  B_GetPosition(uSource);
   --不是长城以南
   if MapId ~= 1 then 	
	 P_saysystem(uSource, '不是长城以南', 15);
     return;
   end;
    --获取血量最大
    local MaxLife = B_GetMaxLife(uSource);
    --获取当前血量
    local CurLife = B_GetCurLife(uSource);
	--获取血量当前百分比
	local per = math.floor(CurLife // MaxLife * 100);
	if per < 99 then 
       P_saysystem(uSource, '血量 >=99% 才可以进行传送', 15);
      return;
    end;
    --检测钱币
    if P_getitemcount(uSource, '钱币') < t.money then 
       P_saysystem(uSource, string.format('你没有%d个钱币！', t.money), 15);
      return;
    end;
    --删除钱币
	P_deleteitem(uSource, '钱币', t.money, '传送符');
    --删除道具
	P_deleteitem(uSource, '传送符', 1, '传送符');
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;

 return;
end