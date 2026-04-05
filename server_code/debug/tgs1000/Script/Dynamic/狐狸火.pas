{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.05
实现功能:
修炼洞内点火
   点2个火时候 刷出怪物'死狼女实像'
   点4个火时候 刷出怪物'妖华'
修炼洞内熄火
   剩余3个火的时候 删除怪物'妖华'
   剩余1个火的时候 删除怪物'死狼女实像'

   //已验证
******************************************************************************}

var
  LightCount :integer; //火的数量

//地图复活时候触发 火的数量清0

procedure OnRegen(uSource :integer);
begin
  LightCount := 0;
end;

//点火时候触发

procedure OnTurnOn(uSource, uDest :integer);
begin
  Inc(LightCount);
  case LightCount of
    2 :
      begin
        if MapFindMonster('修炼洞', '死狼女实像','all') > 0 then exit; //查找地图中怪物是否存在
        MapAddmonster('修炼洞', '死狼女实像', 24, 34, 1, 4, '', 0, 0,TRUE); //增加怪物
      end;
    4 :
      begin
        if MapFindDynamicobject('修炼洞', '妖华','all') > 0 then exit;
        MapAdddynamicobject('修炼洞', '妖华', '', '', '', '', '', '', '37', '50', 0, 37, 50);
      end;
  else
    exit;
  end;
end;
//熄火时候触发

procedure OnTurnOff(uSource :integer);
begin
  Dec(LightCount);
  case LightCount of
    3 :
      begin
        if MapFinddynamicobject('修炼洞', '妖华','all') <= 0 then exit;
        MapDeldynamicobject('修炼洞', '妖华');
      end;
    1 :
      begin
        if MapFindMonster('修炼洞', '死狼女实像','all') <= 0 then exit;
        MapDelmonster('修炼洞', '死狼女实像'); //删除怪物
      end;
  else
    exit;
  end;
end;

