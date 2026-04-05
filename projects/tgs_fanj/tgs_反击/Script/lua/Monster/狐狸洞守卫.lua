package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--ËÀÍö
function OnDie(uSource, uDest, race)
  if race == 1 then
    local aStr = M_MapFindMonster(112, 'ºüÀê¶´ÊØÎÀ', 2);
    if (aStr == 0)  then
	  --Ìí¼ÓBOSS
	  if M_MapFindMonster(112, 'ËÀÀÇÅ®ĞéÏñ', 0) <= 0 then
		M_MapAddMonster(112,'ËÀÀÇÅ®ĞéÏñ', 166, 69, 1, 4, '', 0, 0, true, 0);
	    M_worldnoticesysmsg('[ËÀÀÇÅ®ĞéÏñ]³öÏÖÔÚºüÀê¶´ [166:69]¸½½ü', 15); 
	  end
	else
	  M_MapObjSay(112, string.format('[ºüÀê¶´]:Ê£Óà%d¸ö[ºüÀê¶´ÊØÎÀ]Ã»ËÀ!', aStr), 1);
    end;
  end
end;