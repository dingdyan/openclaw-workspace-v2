{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
//将玩家传出村
   //已验证
        ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '少侠，你要出村吗？^^'
        + '  <〖是的〗/@Quest>^^ '
        + '  <〖放弃〗/@exit> ');
end;

procedure Quest(uSource, uDest:integer);
begin
    Menusay(uSource, '新手村是个很美的地方，如果你的新手任务没^有完成，你会错失很多惊喜。^^'
        + '  <〖我要出村〗/@Quest_1>^^ '
        + '  <〖还是村子好〗/@exit> ');
end;

procedure Quest_1(uSource, uDest:integer);
var
    name            :string;
begin
    name := getname(uSource);
    saysystem(uSource, '提示：玩家【' + Name + '】，进入长城以南');
   // movespace(uSource, 1, 524, 474);
    MapMove(uSource, 1, 524, 474, 100);
end;

