procedure OnGuildImpartMagic(uSource, uUser, uDest:integer); //门派NPC 传授武功 事件
var
    s1, s2          :string;
begin

    if getMagicspace(uUser, 'Magic') < 1 then
    begin
        say(uDest, '你的武功栏已满，请留出1个空位。');
        exit;
    end;

    if addGuildMagic(uUser) = false then
    begin
        say(uDest, ' 门派武功传授失败。');
        exit;
    end;
    s1 := GuildGetName(uuser);
    s2 := getName(uuser);
    say(uDest, '已将 『' + s1 + '』门派的门派武功传授给【' + s2 + '】');
    saysystem(uuser, '恭喜你，获得了 『' + s1 + '』门派的门派武功,请将门派武功发扬光大！');
end;

