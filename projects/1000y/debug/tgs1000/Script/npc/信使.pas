{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
    //游戏中收发信件NPC
   //已验证
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest :integer);
var
  int1 :integer;
begin
  int1 := getQuestNo(uSource);
  if int1 < 100 then
  begin
    MenuSay(uSource, '你的新手任务还未完成就出来瞎混，赶快去找^'
      + '传送师，回新手村去锻炼一下再来找我。^^'
      + '   <〖知道了〗/@exit>');
    exit;
  end;
  MenuSay(uSource, '收发信件都可以找我，但是信件只能保存七天！^^'
    + '<〖邮件系统〗/@email>^^'
    + '<〖任务〗/@quest>');
end;

procedure quest(uSource, uDest :integer);
var
  int1, int2 :integer;
begin
  int1 := getQuestCurrentNo(uSource);
  case int1 of
      //长城以南任务
    101 :
      begin
        int2 := getQueststep(uSource);
        case int2 of
          11 :
            begin
              MenuSay(uSource, '少侠来得真及时，我正等着这批宣纸呢。^^'
                + '    <〖是〗/@Quest_101_12>');
            end;
          12 :
            begin
              MenuSay(uSource, '不能让你白帮我，我帮你引见一位高人，他喜^'
                + '欢给新来的人一些指点^^'
                + '    <〖是〗/@Quest_101_13>');
            end;
        else MenuSay(uSource, '没见我正在忙吗?我可没有什么告诉你的了！');
        end;
      end;
  else MenuSay(uSource, '现在，我没有什么可以帮助你的。');
  end;
end;

procedure Quest_101_12(uSource, uDest :integer);
var
  int1 :integer;
begin
  int1 := getitemcount(uSource, '宣纸');
  if int1 < 200 then
  begin
    MenuSay(uSource, '我的宣纸呢？');
    exit;
  end;
  if deleteitem(uSource, '宣纸', 200) = false then
  begin
    MenuSay(uSource, '回收物品失败');
    exit;
  end;

  setQueststep(uSource, 12);
  saysystem(uSource, '任务提示：' + getQuestSubRequest(101, 12));

  quest(uSource, uDest);
end;

procedure Quest_101_13(uSource, uDest :integer);
begin
  setQueststep(uSource, 13);
  saysystem(uSource, '任务提示：' + getQuestSubRequest(101, 13));
end;

