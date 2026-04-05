{******************************************************************************
创建人:田莉
创建时间:2009.09.24
修改时间:
实现功能:
  使用后可以打开宝箱


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
var
  randomcount, itemcount :integer;
  itemname :string;
begin
   //检查背包里是否有宝箱
  if getitemcount(uSource, '宝箱') < 1 then
  begin
    LeftText2(uSource, '对不起，你的背包里没有宝箱，不能使用此钥匙。', $001188FF);
    exit;
  end;
  //检查背包空位
  if getitemspace(uSource) < 1 then
  begin
    LeftText2(uSource, '背包空位不足，请留出1个空位。', $001188FF);
    exit;
  end;
  randomcount := 0;
  itemcount := 1;
  randomcount := random(10000);
  //每次随机必发放一种物品 最差的随机获得白酒
  case randomcount of
    9990..9999 :itemname := '灵动八方'; //随机发放 灵动八方
    9500..9989 : //随机发放 五种三级宝石中的一种
      begin
        case random(1000) of
          900..999 :itemname := '三级青玉之石';
          700..899 :itemname := '三级蓝玉之石';
          500..699 :itemname := '三级黄玉之石';
          300..499 :itemname := '三级白玉之石';
          0..299 :itemname := '三级黑玉之石';
        else itemname := '白酒';
        end;
      end;
    9000..9499 : //随机发放 天罡、地煞、乾坤石中的一种
      begin
        itemcount := 10;
        case random(300) of
          200..299 :itemname := '乾坤石';
          100..199 :itemname := '地煞石';
          0..99 :itemname := '天罡石';
        else itemname := '白酒';
        end;
      end;
    8000..8999 :itemname := '风灵旋'; //随机发放 风灵旋
    7000..7999 : //随机发放 幻魔身法、血轮回、金钟罩、血手印、噬魂枪中的一种
      begin
        case random(1000) of
          900..999 :itemname := '幻魔身法';
          700..899 :itemname := '血轮回';
          500..699 :itemname := '金钟罩';
          300..499 :itemname := '血手印';
          0..299 :itemname := '噬魂枪';
        else itemname := '白酒';
        end;
      end;
    6000..6999 : //随机发放 反击卷
      begin
        itemname := '反击卷';
        itemcount := 5;
      end;
    5000..5999 : //随机发放 精炼石
      begin
        itemname := '精炼石';
        itemcount := 20;
      end;
  else itemname := '白酒';
  end;

  if itemname = '白酒' then itemcount := 50;
  //删除精武钥匙
  if deleteitem(uSource, '精武钥匙', 1) = false then
  begin
    LeftText2(uSource, '对不起，回收物品失败。', $001188FF);
    exit;
  end;
  //删除宝箱
  if deleteitem(uSource, '宝箱', 1) = false then
  begin
    LeftText2(uSource, '对不起，回收物品失败。', $001188FF);
    exit;
  end;
  //发放随机物品
  if additem(uSource, itemname, itemcount) = false then
  begin
    LeftText2(uSource, '对不起，发放物品失败。', $001188FF);
    exit;
  end;
end;

