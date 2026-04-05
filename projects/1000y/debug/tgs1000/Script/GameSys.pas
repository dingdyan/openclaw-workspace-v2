//角色上线

procedure OnCharOnline(uSource: integer);
var
  curQuest: integer;
  curSubQuest: integer;
begin
  curQuest := getQuestCurrentNo(uSource);
//当前主线任务ID
  if (curQuest < 4950) and (curQuest > 0) then
  begin
    setQuestCurrentNo(uSource, 0);
    setQuestNo(uSource, 0);
    setQueststep(uSource, 0);
  end;

  //当前支线任务ID
  curSubQuest := getSubQuestCurrentNo(uSource);
  if (curSubQuest < 8001) and (curSubQuest > 0) then
  begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
  end;

end;
//角色下线

procedure OnCharExitGame(uSource: integer);
begin

end;
//发布寄售通知

procedure OnAuctionSell(uSource: integer; aItemName: string);
begin
  topmsg('寄售员大声喊到：有人寄售了『' + aItemName + '』在我这，如有需要，赶快前来购买。', $00FF80FF);
end;

