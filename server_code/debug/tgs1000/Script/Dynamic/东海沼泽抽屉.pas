{******************************************************************************
创建人:杨李
创建时间:2009.10.22
修改时间:
实现功能:
用“抽屉钥匙”打开则发放物品：“侠客指环”

******************************************************************************}

var
    IsOn            :boolean;      //火炉状态

procedure OnRegen(uSource:integer);
begin
    // IsOn := false;
end;

//打开时候触发

procedure OnTurnOn(uSource, uDest:integer);
var
    itemkey         :integer;
begin
    itemkey := FindItemName(uSource, '书函'); //如果有书函
    if itemkey >= 0 then
    begin
        if deleteItemKey(uSource, itemkey, 1) = false then exit;
        saysystem(uSource, '完成了西域魔人任务');
        if additem(uSource, '侠客指环', 1) = false then
        begin
            additem(uSource, '书函', 1);
            exit;
        end;
    end else                       //没有书函就发一个侠客指环 不提示任务完成
    begin
        if additem(uSource, '侠客指环', 1) = false then
        begin
            saysystem(uSource, '发放物品失败！');
            exit;
        end;
    end;

end;
//关闭时候触发

procedure OnTurnOff(uSource:integer);
begin

end;

