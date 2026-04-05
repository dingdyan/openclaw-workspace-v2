{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
//对宝石进行淬炼
   //已验证
      ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnNpcMenu(uSource, uDest: integer);
begin
  menusay(uSource, '本店提供各种宝石的淬炼服务，侠士若有需要^可随时来找我。^^'
    + '    <〖淬炼白玉之石〗/@baiyu>^^'
    + '    <〖淬炼青玉之石〗/@qingyu>^^'
    + '    <〖淬炼黑玉之石〗/@heiyu>^^'
    + '    <〖淬炼蓝玉之石〗/@lvyu>^^'
    + '    <〖淬炼黄玉之石〗/@huangyu>');
end;

procedure baiyu(uSource, uDest: integer);
begin
  menusay(uSource, '淬炼白玉之石需要准备好足够的材料和手续费用。^^'
    + '    <〖淬炼一级白玉之石 手续费2000〗/@yijibaiyu>^^'
    + '    <〖淬炼二级白玉之石 手续费5000〗/@erjibaiyu>^^'
    + '    <〖淬炼三级白玉之石 手续费20000〗/@sanjibaiyu>^^'
    + '    <〖淬炼四级白玉之石 手续费50000〗/@sijibaiyu>');
end;

procedure _cuilian_check(uSource, uDest: integer; aOldItemName,
  aNewItemName: string; aOldCount, amoney: integer);
begin
  //物品数量检查
  if getitemcount(uSource, aOldItemName) < aOldCount then
  begin
    say(uDest, '淬炼成' + aNewItemName + '需要' + inttostr(aOldCount) + '个' + aOldItemName + '。');
    exit;
  end;

  if getitemcount(uSource, '钱币') < amoney then
  begin
    say(uDest, '淬炼成' + aNewItemName + '需要' + IntToStr(amoney) + '钱币。');
    exit;
  end;
  //背包检查
  if getitemspace(uSource) < 1 then
  begin
    menusay(uSource, '背包已满，请留出1个空位。');
    exit;
  end;

  if deleteitem(uSource, aOldItemName, aOldCount) = false then
  begin
    menusay(uSource, '回收物品失败');
    exit;
  end;
  if deleteitem(uSource, '钱币', amoney) = false then
  begin
    menusay(uSource, '回收物品失败');
    exit;
  end;
  if additem(uSource, aNewItemName, 1) = false then
  begin
    menusay(uSource, '发放物品失败');
    exit;
  end;
  saysystem(uSource, '获得物品：' + aNewItemName); //任务提示
end;

//淬炼一级白玉之石

procedure yijibaiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '一级白玉之石', '二级白玉之石', 10, 2000);
end;
 //淬炼二级白玉之石

procedure erjibaiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '二级白玉之石', '三级白玉之石', 10, 5000);
end;
 //淬炼三级白玉之石

procedure sanjibaiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '三级白玉之石', '四级白玉之石', 10, 20000);

end;
//淬炼四级白玉之石

procedure sijibaiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '四级白玉之石', '五级白玉之石', 10, 50000);
end;

procedure qingyu(uSource, uDest: integer);
begin
  menusay(uSource, '淬炼青玉之石需要准备好足够的材料和手续费用。^^'
    + '    <〖淬炼一级青玉之石 手续费2000〗/@yijiqingyu>^^'
    + '    <〖淬炼二级青玉之石 手续费5000〗/@erjiqingyu>^^'
    + '    <〖淬炼三级青玉之石 手续费20000〗/@sanjiqingyu>^^'
    + '    <〖淬炼四级青玉之石 手续费50000〗/@sijiqingyu>');
end;
//淬炼一级青玉之石

procedure yijiqingyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '一级青玉之石', '二级青玉之石', 10, 2000);
end;
//淬炼二级青玉之石

procedure erjiqingyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '二级青玉之石', '三级青玉之石', 10, 5000);
end;
 //淬炼三级青玉之石

procedure sanjiqingyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '三级青玉之石', '四级青玉之石', 10, 20000);
end;
//淬炼四级青玉之石

procedure sijiqingyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '四级青玉之石', '五级青玉之石', 10, 50000);
end;

procedure heiyu(uSource, uDest: integer);
begin
  menusay(uSource, '淬炼黑玉之石需要准备好足够的材料和手续费用。^^'
    + '    <〖淬炼一级黑玉之石 手续费2000〗/@yijiheiyu>^^'
    + '    <〖淬炼二级黑玉之石 手续费5000〗/@erjiheiyu>^^'
    + '    <〖淬炼三级黑玉之石 手续费20000〗/@sanjiheiyu>^^'
    + '    <〖淬炼四级黑玉之石 手续费50000〗/@sijiheiyu>');
end;
 //淬炼一级黑玉之石

procedure yijiheiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '一级黑玉之石', '二级黑玉之石', 10, 2000);
end;
//淬炼二级黑玉之石

procedure erjiheiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '二级黑玉之石', '三级黑玉之石', 10, 5000);
end;
//淬炼三级黑玉之石

procedure sanjiheiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '三级黑玉之石', '四级黑玉之石', 10, 20000);
end;
 //淬炼四级黑玉之石

procedure sijiheiyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '四级黑玉之石', '五级黑玉之石', 10, 50000);
end;


procedure lvyu(uSource, uDest: integer);
begin
  menusay(uSource, '淬炼绿玉之石需要准备好足够的材料和手续费用。^^'
    + '    <〖淬炼一级蓝玉之石 手续费2000〗/@yijilvyu>^^'
    + '    <〖淬炼二级蓝玉之石 手续费5000〗/@erjilvyu>^^'
    + '    <〖淬炼三级蓝玉之石 手续费20000〗/@sanjilvyu>^^'
    + '    <〖淬炼四级蓝玉之石 手续费50000〗/@sijilvyu>');
end;
 //淬炼一级蓝玉之石

procedure yijilvyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '一级蓝玉之石', '二级蓝玉之石', 10, 2000);
end;
 //淬炼二级蓝玉之石

procedure erjilvyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '二级蓝玉之石', '三级蓝玉之石', 10, 5000);
end;
 //淬炼三级蓝玉之石

procedure sanjilvyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '三级蓝玉之石', '四级蓝玉之石', 10, 20000);
end;
 //淬炼四级蓝玉之石

procedure sijilvyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '四级蓝玉之石', '五级蓝玉之石', 10, 50000);
end;


procedure huangyu(uSource, uDest: integer);
begin
  menusay(uSource, '淬炼黄玉之石需要准备好足够的材料和手续费用。^^'
    + '    <〖淬炼一级黄玉之石 手续费2000〗/@yijihuangyu>^^'
    + '    <〖淬炼二级黄玉之石 手续费5000〗/@erjihuangyu>^^'
    + '    <〖淬炼三级黄玉之石 手续费20000〗/@sanjihuangyu>^^'
    + '    <〖淬炼四级黄玉之石 手续费50000〗/@sijihuangyu>');
end;

 //淬炼一级黄玉之石

procedure yijihuangyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '一级黄玉之石', '二级黄玉之石', 10, 2000);
end;
  //淬炼二级黄玉之石

procedure erjihuangyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '二级黄玉之石', '三级黄玉之石', 10, 5000);
end;
  //淬炼三级黄玉之石

procedure sanjihuangyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '三级黄玉之石', '四级黄玉之石', 10, 20000);
end;
  //淬炼四级黄玉之石

procedure sijihuangyu(uSource, uDest: integer);
begin
  _cuilian_check(uSource, uDest, '四级黄玉之石', '五级黄玉之石', 10, 50000);
end;

