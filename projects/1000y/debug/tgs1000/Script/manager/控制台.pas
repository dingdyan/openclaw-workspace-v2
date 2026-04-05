{******************************************************************************
创建人:李小利
创建时间:2009.09.18
修改时间:2009.09.24
实现功能:
******************************************************************************}
var
  CXYN_StartTime: integer;              //攻城开始时间
  CXYN_AttackStep: integer;             // 攻城阶段
  CXYN_AttackStepSub: integer;
  CXYN_UpdateTick: integer;
  CXYN_MonsterAttTick: integer;
const
  cxyn_log = false;
  CXYN_C_MonsterAttTick = 6000;         //刷新时间
  CXYN_C_AttackStepSub = 3;             //每波怪刷新几次
  CXYN_C_AllTime = 1440000;             //120分钟 攻城总时间

procedure OnUpdate(uManager, curTcik: integer); //地图更新
begin
  if cxyn_log then worldnoticemsg('OnUpdate' + IntToStr(curTcik), $00FF80FF, $00000000);

//攻城状态  1.准备开始攻城 2.攻城中 3.准备结束攻城 4.已经结束
  case getServerTempVar(0) of
    1:
       //记录攻城开始时间
      begin
        CXYN_Clear;
        CXYN_StartTime := curTcik;
        CXYN_UpdateTick := -65535;
        CXYN_AttackStep := 0;
        if getUserListCount >= 100 then
        begin
          CXYN_MonsterAttTick := CXYN_C_MonsterAttTick; //60000;
        end else
        begin
          CXYN_MonsterAttTick := 2 * CXYN_C_MonsterAttTick;
        end;

        SetArcher();
        setServerTempVar(0, 2);
        BoothAllClose();
      end;
    2:
        //攻击城市中
      begin
        Update(curTcik);
      end;
    3:
        //结束攻城
      begin
        setServerTempVar(0, 0);
        DelMonster();
        CXYN_Clear;
      end;
    4:
        //公主死亡
      begin
        worldnoticemsg('公主死亡，守城失败', $00FF80FF, $00000000);
        setServerTempVar(0, 3);
      end;
    5:
      begin
        //worldnoticemsg('杀死东方不败，守城胜利', $00FF80FF, $00000000);
        //setServerTempVar(0, 3);
      end;
  end;

end;

procedure CXYN_Clear();
begin
  CXYN_StartTime := 0;                  //攻城开始时间
  CXYN_AttackStep := 0;                 // 攻城阶段
  CXYN_UpdateTick := 0;
  CXYN_MonsterAttTick := 0;
  CXYN_AttackStepSub := 0;
end;

procedure OnInitial(uManager, curTcik: integer); //初始化
begin
  CXYN_Clear;
end;
//增加弓箭手

procedure SetArcher();
var
  i: integer;
  astr: string;
begin
  if cxyn_log then worldnoticemsg(' 公主\守城弓箭手增加!', $00FF80FF, $00000000);

  MapAddnpc('长城以南', 'S公主', 524, 473, 1, 2, '', 1, 0,TRUE);

  MapAddmonster('长城以南', 'SG1弓箭手', 526, 469, 1, 2, '', 1, 21,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 529, 472, 1, 2, '', 1, 22,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 529, 476, 1, 2, '', 1, 23,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 526, 479, 1, 2, '', 1, 24,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 522, 479, 1, 2, '', 1, 25,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 519, 475, 1, 5, '', 1, 26,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 519, 472, 1, 2, '', 1, 27,TRUE);
  MapAddmonster('长城以南', 'SG1弓箭手', 522, 469, 1, 2, '', 1, 28,TRUE);

  MapAddmonster('长城以南', 'SG4弓箭手', 532, 462, 1, 2, '', 1, 29,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 536, 466, 1, 2, '', 1, 30,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 540, 455, 1, 2, '', 1, 31,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 543, 458, 1, 2, '', 1, 32,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 548, 447, 1, 2, '', 1, 33,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 551, 452, 1, 2, '', 1, 34,TRUE);

  MapAddmonster('长城以南', 'SG4弓箭手', 515, 486, 1, 2, '', 1, 35,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 512, 483, 1, 2, '', 1, 36,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 507, 494, 1, 2, '', 1, 37,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 504, 491, 1, 2, '', 1, 38,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 497, 498, 1, 2, '', 1, 39,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 500, 501, 1, 2, '', 1, 40,TRUE);

  MapAddmonster('长城以南', 'SG4弓箭手', 549, 496, 1, 2, '', 1, 41,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 546, 499, 1, 2, '', 1, 42,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 543, 489, 1, 2, '', 1, 43,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 539, 493, 1, 2, '', 1, 44,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 535, 481, 1, 2, '', 1, 45,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 531, 485, 1, 2, '', 1, 46,TRUE);

  MapAddmonster('长城以南', 'SG4弓箭手', 511, 464, 1, 2, '', 1, 47,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 514, 461, 1, 2, '', 1, 48,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 504, 457, 1, 2, '', 1, 49,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 507, 454, 1, 2, '', 1, 50,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 496, 449, 1, 2, '', 1, 51,TRUE);
  MapAddmonster('长城以南', 'SG4弓箭手', 599, 446, 1, 2, '', 1, 52,TRUE);

 ///////////////
  MapAddmonster('长城以南', 'S1小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S3小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S5小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S7小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S9小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S12小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S14小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S16小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S18小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
  MapAddmonster('长城以南', 'S20小兵', 531, 467, 1, 3, '', 1, 14,TRUE);
/////////

  MapAddmonster('长城以南', 'S2小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S4小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S6小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S8小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S10小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S11小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S13小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S15小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S17小兵', 515, 466, 1, 3, '', 1, 15,TRUE);
  MapAddmonster('长城以南', 'S19小兵', 515, 466, 1, 3, '', 1, 15,TRUE);

  ///////////
  MapAddmonster('长城以南', 'S1小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S3小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S5小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S7小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S9小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S12小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S14小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S16小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S18小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  MapAddmonster('长城以南', 'S20小兵', 517, 482, 1, 3, '', 1, 16,TRUE);
  /////////////
  MapAddmonster('长城以南', 'S2小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S4小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S6小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S8小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S10小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S11小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S13小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S15小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S17小兵', 534, 481, 1, 3, '', 1, 17,TRUE);
  MapAddmonster('长城以南', 'S19小兵', 534, 481, 1, 3, '', 1, 17,TRUE);

  for i := 1 to 20 do
  begin
    astr := 'GJ' + inttostr(i) + '小怪';

    MapAddmonster('长城以南', astr, 591, 357, 5, 15, '', 0, 0,TRUE); //武学
    MapAddmonster('长城以南', astr, 449, 415, 5, 15, '', 0, 0,TRUE); //药王
    MapAddmonster('长城以南', astr, 435, 545, 5, 15, '', 0, 0,TRUE); //奖励
    MapAddmonster('长城以南', astr, 605, 557, 5, 15, '', 0, 0,TRUE); //老板娘
  end;
  //取消GJ20小头目 头目可视范围改为10
//武学
  MapAddmonster('长城以南', 'GJ1小头目', 591, 357, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ3小头目', 591, 357, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ5小头目', 591, 357, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ17小头目', 591, 357, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ19小头目', 591, 357, 1, 10, '', 0, 0,TRUE);
//药王
  MapAddmonster('长城以南', 'GJ2小头目', 449, 415, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ4小头目', 449, 415, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ6小头目', 449, 415, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ16小头目', 449, 415, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ18小头目', 449, 415, 1, 10, '', 0, 0,TRUE);
//奖励
  MapAddmonster('长城以南', 'GJ7小头目', 435, 545, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ8小头目', 435, 545, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ10小头目', 435, 545, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ14小头目', 435, 545, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ15小头目', 435, 545, 1, 10, '', 0, 0,TRUE);
//老板娘
  MapAddmonster('长城以南', 'GJ9小头目', 605, 557, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ10小头目', 605, 557, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ11小头目', 605, 557, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ12小头目', 605, 557, 1, 10, '', 0, 0,TRUE);
  MapAddmonster('长城以南', 'GJ13小头目', 605, 557, 1, 10, '', 0, 0,TRUE);

end;
//删除怪物

procedure DelMonster();
var
  i: integer;
begin
  if cxyn_log then worldnoticemsg(' 公主\守城弓箭手清除!', $00FF80FF, $00000000);
  for i := 1 to 20 do
  begin
    Mapdelmonster('长城以南', 'S' + inttostr(i) + '小兵');
    Mapdelmonster('长城以南', 'G' + inttostr(i) + '小怪');
    MapDelMonster('长城以南', 'G' + inttostr(i) + '小头目');
    MapDelMonster('长城以南', 'GJ' + inttostr(i) + '小怪');
  end;
  for i := 1 to 19 do
  begin
    MapDelMonster('长城以南', 'GJ' + inttostr(i) + '小头目');
  end;

  Mapdelmonster('长城以南', 'SG4弓箭手');
  Mapdelmonster('长城以南', 'SG1弓箭手');
  Mapdelnpc('长城以南', 'S公主');
end;

procedure Update(curTick: integer);
var
  i, tmpid: integer;
  astr: string;
begin

  ///////////////////////////////////////////////////////////
  //总共时间
  if curTick > CXYN_StartTime + CXYN_C_AllTime then
  begin
    setServerTempVar(0, 3);
    worldnoticemsg('攻城战已经结束!', $00FF80FF, $00000000);
    if cxyn_log then worldnoticemsg('攻城战时间超时', $00FF80FF, $00000000);
    exit;
  end;
  ///////////////////////////////////////////////////////////
  if CXYN_AttackStep >= 20 then exit;
  //每次时间
  if curTick < CXYN_UpdateTick + CXYN_MonsterAttTick then
  begin
    i := ((CXYN_UpdateTick + CXYN_MonsterAttTick) - curTick) div 100;
    if cxyn_log then worldnoticemsg('距离下一次怪进攻还剩!' + IntToStr(i) + '秒', $00FF80FF, $00000000);
    exit;
  end;
  CXYN_UpdateTick := curTick;
  if CXYN_MonsterAttTick < 1000 then CXYN_MonsterAttTick := 1000;
  ///////////////////////////////////////////////////////////


   //主怪物
  astr := 'G' + IntToStr(CXYN_AttackStep + 1) + '小怪';
  MapAddmonster('长城以南', astr, 588, 378, 4, 3, '', 0, 10,TRUE); //武学
  MapAddmonster('长城以南', astr, 469, 407, 4, 3, '', 0, 11,TRUE); //药王
  MapAddmonster('长城以南', astr, 443, 529, 4, 3, '', 0, 12,TRUE); //奖励
  MapAddmonster('长城以南', astr, 595, 549, 4, 3, '', 0, 13,TRUE); //老板娘
  //附加怪物
  tmpid := CXYN_AttackStepSub * 4;
  for i := 1 to 4 do
  begin
    astr := 'G' + IntToStr(tmpid + i) + '小怪';
    MapAddmonster('长城以南', astr, 588, 378, 1, 3, '', 0, 10,TRUE);
    MapAddmonster('长城以南', astr, 469, 407, 1, 3, '', 0, 11,TRUE);
    MapAddmonster('长城以南', astr, 443, 529, 1, 3, '', 0, 12,TRUE);
    MapAddmonster('长城以南', astr, 595, 549, 1, 3, '', 0, 13,TRUE);
  end;
  if cxyn_log then worldnoticemsg('第' + IntToStr(CXYN_AttackStep + 1) + '波攻击怪物增加' + astr, $00FF80FF, $00000000);

  //boss
  if CXYN_AttackStepSub >= CXYN_C_AttackStepSub then
  begin
    astr := 'G' + IntToStr(CXYN_AttackStep + 1) + '小头目';
    if cxyn_log then worldnoticemsg('第' + IntToStr(CXYN_AttackStep + 1) + '波小头目 ' + astr + ' 增加', $00FF80FF, $00000000);
    MapAddmonster('长城以南', astr, 588, 378, 1, 3, '', 0, 10,TRUE);
    MapAddmonster('长城以南', astr, 469, 407, 1, 3, '', 0, 11,TRUE);
    MapAddmonster('长城以南', astr, 443, 529, 1, 3, '', 0, 12,TRUE);
    MapAddmonster('长城以南', astr, 595, 549, 1, 3, '', 0, 13,TRUE);
    CXYN_AttackStep := CXYN_AttackStep + 1;
    CXYN_AttackStepSub := 0;
  end else CXYN_AttackStepSub := CXYN_AttackStepSub + 1;

end;

