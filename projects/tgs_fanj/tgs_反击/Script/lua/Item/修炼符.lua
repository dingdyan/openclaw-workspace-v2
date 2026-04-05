local ItemTab = {
  ['修炼符'] = {
    ['atime'] = 60 * 60 * 4,
	['Key'] = 3, --key
	['Max'] = 1, --最大数量
  },
};

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, '你没有这个道具', 18);
     return;
   end
   --获取道具table
   local t = ItemTab[ItemData.Name];
   if t == nil then
    return;
   end;		
   --获取玩家名称
   local PlayName = B_GetRealName(uSource);
   --获取当前日期
   local CurrentDate = os.date("%Y-%m-%d");
   local PlayDate = '';
   local PlayNum = 0;
   --读取MYSQL数据
   local SQL = string.format('SELECT dates, num FROM item_daynum WHERE playname=\'%s\' and ids=%d', PlayName, t.Key);
   local Data = M_GetMySqlDataSet(SQL);
   --判断读取MYSQL状态
   if Data == -1 then return end;
   if Data ~= nil and Data[1] ~= nil then
     PlayDate = Data[1]['dates'];
     PlayNum = tonumber(Data[1]['num']);
   else
     --没有数据写入数据
     local SQL = string.format('INSERT item_daynum (playname, ids, dates, num) values (\'%s\', %d, \'%s\', %d)', PlayName, t.Key, CurrentDate, 0);
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
     local SQL = string.format('UPDATE item_daynum SET dates=\'%s\', num=0 WHERE playname=\'%s\' and ids=%d', CurrentDate, PlayName, t.Key);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '使用失败,请稍后尝试!', 2);
      return;		
     end;	
     --重置次数后设定进入次数为0
     PlayNum = 0;
   end	
   --判断日期相同以及次数
   if PlayDate == CurrentDate and PlayNum >= t.Max then 
     P_saysystem(uSource, string.format('抱歉,今日你已使用了%d次,无法使用了！', PlayNum), 18);
    return;
   end
   --更新使用次数SQL	
   local SQL =  string.format('UPDATE item_daynum SET num = %d WHERE playname=\'%s\' and ids=%d', PlayNum + 1, PlayName, t.Key);
   if M_DoMySql(SQL) <= 0 then 
     P_saysystem(uSource, '使用失败,请稍后尝试!', 2);
    return;		
   end;	
   --修改修炼场时间
   P_SetTempArr(uSource, 10, P_GetTempArr(uSource, 10) + t.atime);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --返回消息
   P_saysystem(uSource, '修炼场时间已增加', 18);
 return;
end