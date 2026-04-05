{******************************************************************************
创建人:何永安
创建时间:2009.10.17
修改时间:
实现功能:
  创建一个元神

******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey:integer; astr:string);
var
    i               :integer;
begin
    i := getEnergyLevel(uSource);
    case i of
        1:MonsterCreate(uSource, 'X计时元神1');
        2:MonsterCreate(uSource, 'X计时元神2');
        3:MonsterCreate(uSource, 'X计时元神3');
        4:MonsterCreate(uSource, 'X计时元神4');
        5:MonsterCreate(uSource, 'X计时元神5');
        6:MonsterCreate(uSource, 'X计时元神6');
        7:MonsterCreate(uSource, 'X计时元神7');
        8:MonsterCreate(uSource, 'X计时元神8');
        9:MonsterCreate(uSource, 'X计时元神9');
        10:MonsterCreate(uSource, 'X计时元神10');
        11:MonsterCreate(uSource, 'X计时元神10');
        12:MonsterCreate(uSource, 'X计时元神10');
        13:MonsterCreate(uSource, 'X计时元神10');
    else
        MonsterCreate(uSource, 'X计时元神1');
    end;
end;

