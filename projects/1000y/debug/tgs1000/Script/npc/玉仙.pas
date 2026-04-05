//*******************************************************
//创建人：何永安
//时间：2009.10.26
//功能：初始化帝王石谷任务
//*******************************************************
{
procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '完成帝王石谷任务中,进行得不顺利，可以初始化.^^'
        + '一旦初始化,西域魔人的任务就要全部重新开始.^^'
        + '不灭戒指也会消失.^^');
    // + '    <〖帝王石谷任务初始化〗 /@initial>^^');
end;

procedure initial(uSource, uDest:integer);
begin
    Menusay(uSource, '要初始化帝王石谷任务吗?^^'
        + '    <〖初始化〗 /@remotequest>^^'
        + '    <〖稍作考虑〗 /@exit>^^');
end;

procedure remotequest(uSource, uDest:integer);
begin
    //删除任务相关所有物品（需要添加）
    setQuestNo(uSource, 100);
    setQuestCurrentNo(uSource, 100);
end;
       }
