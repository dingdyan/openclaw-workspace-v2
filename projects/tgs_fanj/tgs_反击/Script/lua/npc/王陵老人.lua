package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '王陵老人';

local MainMenu =
[[进入王陵3层境界需要到底[神话镜]^^
<「游标.bmp」『$00FFFF00| 进入 王陵3层』/@cs>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	

  --传送
  if aStr == 'cs' then
  --判断境界
    if P_GetAttrib(uSource).Energy < 48000 then
	   P_MenuSay(uSource, '境界到[神话镜]才能进入');
        return;
      end
  --传送
   P_MapMove(uSource, 70, 103 + math.random(-5, 5), 253 + math.random(-5, 5), 0);
    return;
  end;
 return;
end

