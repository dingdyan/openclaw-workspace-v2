{**************************************************
创建人：何永安
创建时间：2009.11.18
创建功能：比武结束后可以传送回石棺洞
***************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    menusay(uSource, '比武获胜后，我可以帮你传送回石棺洞太极老^'
        + '人处。不过，要有证明实力的公子的令牌！^^'
        + '<〖去见太极老人〗/@Move>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure Move(uSource, uDest:integer);
begin
    if getItemQuestCount(uSource, '令牌q5004s2') < 1 then
    begin
        menusay(uSource, '没有公子的令牌，免谈！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    mapmove(uSource, 31, 35, 35, 0);
end;

