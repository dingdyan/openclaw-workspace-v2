local ids = 1;
local max = 10000;

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '经验果') < 1 then 
	 P_saysystem(uSource, '没有经验果', 2);
     return;
   end
   --获取玩家名称
   local PlayName = B_GetRealName(uSource);
   --获取当前日期
   local CurrentDate = os.date("%Y-%m-%d");
   local PlayDate = '';
   local PlayNum = 0;
   --读取MYSQL数据
   local SQL = string.format('SELECT dates, num FROM mqn_itemnum_1 WHERE playname="%s" and ids=%d', PlayName, ids);
   local Data = M_GetMySqlDataSet(SQL);
   --判断读取MYSQL状态
   if Data == -1 then return end;
   if Data ~= nil and Data[1] ~= nil then
     PlayDate = Data[1]['dates'];
     PlayNum = tonumber(Data[1]['num']);
   else
     --没有数据写入数据
     local SQL = string.format('INSERT mqn_itemnum_1 (playname, ids, dates, num) values (\'%s\', %d, \'%s\', %d)', PlayName, ids, CurrentDate, 0);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '使用失败,请稍后尝试!', 2);
      return;		
     end;
     --新写入数据日期设为相同以及次数为0
     PlayDate = CurrentDate;	
     PlayNum = 0;
   end;
   --日期不同重置日期和次数
   if PlayDate ~= CurrentDate then 
     local SQL = string.format('UPDATE mqn_itemnum_1 SET dates="%s", num=0 WHERE playname="%s" and ids=%d', CurrentDate, PlayName, ids);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '使用失败,请稍后尝试!', 2);
      return;		
     end;	
     --重置次数后设定进入次数为0
     PlayNum = 0;
   end	
   --判断日期相同以及次数
   if PlayDate == CurrentDate and PlayNum >= max then 
     P_saysystem(uSource, string.format('抱歉,今日你已使用了%d次,无法使用了！', PlayNum), 2);
    return;
   end
   --更新今日进入次数SQL	
   local SQL =  string.format('UPDATE mqn_itemnum_1 SET num = %d WHERE playname="%s" and ids=%d', PlayNum + 1, PlayName, ids);
   if M_DoMySql(SQL) <= 0 then 
     P_saysystem(uSource, '使用失败,请稍后尝试!', 2);
    return;		
   end;	
   --增加翻倍经验
   if not P_AddMagicExpMul(uSource, 2, 60*60*1) then 
	 P_saysystem(uSource, '道具使用失败,请联系管理员！', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '经验果', 1, '双倍卷轴');
   P_saysystem(uSource, '增加2小时双倍经验,使用口令[@双倍经验情报]可查询剩余时间.', 2);
 return;
end