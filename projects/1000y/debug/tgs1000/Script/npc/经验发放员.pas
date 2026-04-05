{******************************************************************************
创建人:杨李
创建时间:2009.10.10
实现功能:
    发放经验:给攻击性武功加经验5亿
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气）2已被使用（领取国庆大礼包），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '新服开启，活动不断。武功经验领取，每天限^'
        + '领一次！^^'
        + '<〖领取经验〗/@getExp>^');
end;

procedure getExp(uSource, uDest:integer);
var
    Magicname       :string;
begin
    if getTempArr(uSource, 3) = 3 then //判断今天是否已经领取
    begin
        Menusay(uSource, '对不起，您已经领取了经验，不能重复领取！^^'
            + '<〖知道了〗/@exit>');
        exit;
    end;
    Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字
    if Magicname = '' then
    begin
        Menusay(uSource, '我可以增加你的武功经验，请使用武功。^^'
            + '        <〖好的〗/@exit> ');
        exit;
    end;
    //武功等级已满
    if getMagicLevel(usource, Magicname) >= 9999 then
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功： ' + Magicname + ' 武功等级已经满级，^^'
            + '我无法增加该武功经验。^^'
            + '        <〖好的〗/@exit> ');
        exit;
    end;

    if AddMagicExp(uSource, Magicname, 500000000) = 0 then
  begin
    Menusay(uSource, '武功经验增加失败');
    exit;
  end;
  if SETTempArr(uSource, 3, 3) = false then
  begin
    Menusay(uSource, '武功经验增加失败！');
    exit;
  end;
  saysystem(uSource, Magicname + '获得了经验');

end;

