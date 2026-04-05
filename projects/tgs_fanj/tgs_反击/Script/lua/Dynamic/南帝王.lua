package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local MainMenu_1 =
[[
 我可只剩半条命，到底我与你有何过节，要置于我死地？^
 西域魔人？老兄，从面相上看你可不像助纣为虐的西域魔人的手下。^
 我已经是快不行的人了，你不动手也维持不了多久了。^
 做事之前要先分辨是非，我要是你就到黄金沙漠调查清楚西域魔人，^
 再动手。^
^
 <『$00FFFF00|[请和我说说看]』/@qhelp_q8_1>
]];

local MainMenu_2 =
[[
 你都打听到什么了,让我来慢慢得告诉你.^
^
 初识西域魔人已经是很久以前的事儿了.长年被捆绑着已经^
 不知道过了多少年了.当年她简直就是美人胚子，让我神魂^
 颠倒.她的一颦一笑都牵动着我的心.为了她我可以赴汤蹈火^
 .我可以舍弃我的生命.这样看来我可算是自作自受了...当^
 时我们三人被誉为三天王，分别管辖东海，北海和南方各地^
 .并互敬互畏，统霸武林.但后来被爱蒙蔽了双眼，忌妒和愤^
 怒达到了极点.我们只看到她的美貌，没看到背后邪恶的阴谋,^
 把我们拥有的一切都给了她.直到后来我们才恍然大悟，她正^
 修炼一种魔功，汲取对方的元气，来增进自己的功力.她趁我^
 们还未恢复功力，想将元气也抽尽.我们就将所剩的武功集中^
 起来一齐攻向她的脉门.然后布阵阻挡她用阴功来攻击我们，^
 并长年隐居了起来.^
 ^
 你所见到的西域魔人很可能不是她的实体.据我所知她的^
 实体藏在石谷的隐秘处.差点儿忘了,东天北霸二王还好吗?^
^
 <『$00FFFF00|[告知东天、北霸的死讯]』/@senddeath>
]];

local MainMenu_3 =
[[
 什么?两个人已经不在了?是谁...是谁杀了他们.^
 啊?你将他们的灵收入葫芦里的?原来是你.那^
 你是如何打算的?^
^
 <『$00FFFF00|[发誓为二王报仇]』/@sayreven>
]];

local MainMenu_4 =
[[
 太好了,有你这样一等一的高手相助,我们就更有胜算了.^
 东天、北霸二王其实还没有死,只是被西域魔人操纵着,^
 杀了西域魔人他们就得救了.拜托你,救出他们吧,让西^
 域魔人血债血偿,^
^
 <『$00FFFF00|[打听怎样进石谷]』/@howtogoin>
]];

local MainMenu_5 =
[[
 石谷钥匙,帮你进入西域魔人石谷;降魔符,帮你突破机^
 关进入魔头所在的屋里.^
^
 拿上帝王守护灵,它是你的护身符.^
^
 <『$00FFFF00|[询问制得石谷钥的方法]』/@howtogetkey>^
 <『$00FFFF00|[询问制得降魔符的方法]』/@howtogetticket>
]];

local MainMenu_6 =
[[
 石谷钥匙用蝎子尾巴和金毛狮甲做成.^
 详细部分要向铁匠请教.^
^
 <『$00FFFF00|[返回]』/@howtogoin>^
 <『$00FFFF00|[关闭]』/@exit>
]];

local MainMenu_7 =
[[
 降魔符帮你突破西域魔人设的机关,^
 通向她所在的空间.具体做法要请教阴阳师.^
^
 <『$00FFFF00|[返回]』/@howtogoin>^
 <『$00FFFF00|[关闭]』/@exit>
]];

local MainMenu_8 =
[[
 她真的不在啦?希望她忘掉发生的一切...老兄你^
 可知你手上戴的是什么吗?这个戒指叫"牌王",谁带^
 上它都会有股野心涌上来,要用本人的意志克制住.^
 我想告诉你真正的侠客是行侠仗义,除恶扬善,不为^
 私欲拔剑的人.最后预祝你将侠客之道发扬光大.^
^
 <『$00FFFF00|[完成南帝王任务]』/@openring>
]];

--说明HELP
local _qhelp = {
  ['q8_1'] =[[
你到底是谁。哦。。。你身上有西域牌，原来你是西域魔^
人派的杀手。^
^
 <『$00FFFF00|[打听真相]』/@qhelp_q8_2>
]],

  ['q8_2'] =[[
真相？你不是西域魔人的同党，来刺杀我的吗？^
既然想听，就让我来告诉你吧。^
那是很久以前了。西域魔人貌如天仙，她的一颦一笑都牵^
动着我的心。简直让我神魂颠倒。^
当时我们三人被誉为三天王，分别管辖东海，^
北海和南方各地。并互敬互畏，统霸武林。^
但后来被爱蒙蔽了双眼，忌妒和愤怒达到了极点。^
我们只看到她的美貌，没看到背后邪恶的阴谋，^
把我们拥有的一切都给了她。直到后来我们才恍然大悟，^
她正修炼一种魔功，汲取对方的元气，来增进自己的功力。^
我们三人都将自己毕生的功力毫无保留的注入给她，她却^
在我们的功力恢复之前试图要将所有元气抽尽。我们三人^
聚集身上所剩的功力向她的脉门猛击。然后迅速布阵防止^
她使用阴功。后来就各自长期隐居。^
你所见到的西域魔人可能不是她的实像据说她的实体藏在石^
谷内的隐秘处。^
对了，东天、北霸二王可好？^
^
 <『$00FFFF00|[东天、北霸二王都已不在人世了]』/@qhelp_q8_3>
]],

  ['q8_3'] =[[
他们两个已经不在了？是谁，是谁干的？什么？^
你将他们的灵魂收入葫芦里了。^
原来如此，这样一来就差解决我了？^
^
 <『$00FFFF00|[发誓要找西域魔人算帐]』/@qhelp_q8_4>
]],

  ['q8_4'] =[[
有你这样的一等一高手相助，就胜利在望了.其实^
东天、北霸二王还没有死，只是灵魂被那魔女操^
纵着，解决了魔头就自然得救。英雄，拜托^
你一定要救出二王，让西域魔人血债血偿。^
^
 <『$00FFFF00|[询问进石窟必备的东西]』/@qhelp_q8_5>
]],

  ['q8_5'] =[[
进入西域魔人所在石谷，必须要带石谷钥匙和降魔符。^
带上这个，此乃帝王守护灵，是护身符。^
^
 <『$00FFFF00|[询问有关降魔符的详细讯息]』/@qhelp_q8_6>
]],

  ['q8_6'] =[[
降魔符是突破西域魔人禁制的符。具体制法要问阴阳师。^
^
^
 <『$00FFFF00|[询问有关石谷钥匙的详细讯息]』/@qhelp_q8_7>
]],

  ['q8_7'] =[[
石谷钥匙由蝎子的尾巴和金毛狮甲制成。详情要问铁匠。
]],

};

function OnMenu(uSource, uDest)
  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);
  --初始化任务
  if CurrentQuest < 1300 then
	B_SAY(uDest, '有何贵干?');
    return;
  end;

  if CurrentQuest == 1300 then
    P_MenuSay(uSource, MainMenu_1);
	
    P_SetQuestNo(uSource, 1300);
    P_SetQuestCurrentNo(uSource, 1350);	
   return;
  end;

  if CurrentQuest == 1350 then
	B_SAY(uDest, '为何还不去调查?');
   return;
  end;

  if CurrentQuest == 1400 then
    P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if CurrentQuest == 1450 then
	B_SAY(uDest, '所有希望都寄托在你身上了?');
   return;
  end;

  if CurrentQuest == 1500 then
    if P_getitemcount(uSource, '戒指') < 1 then
	  B_SAY(uDest, '有杀死西域魔人的凭证吗?');
     return;
    end;
	
    P_MenuSay(uSource, MainMenu_8);
   return;
  end;

  if CurrentQuest == 1550 then
	B_SAY(uDest, '谢谢你～如今我就算死也能瞑目了。?');
   return;
  end;

end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'senddeath' then
     P_MenuSay(uSource, MainMenu_3);
   return;
  end;

  if aStr == 'sayreven' then
     P_MenuSay(uSource, MainMenu_4);
   return;
  end;

  if aStr == 'howtogoin' then
    if P_GetQuestCurrentNo(uSource) ~= 1400 then 
     return;
    end;
	
    P_SetQuestNo(uSource, 1400);
    P_SetQuestCurrentNo(uSource, 1450);	
	
    if P_getitemcount(uSource, '西域牌') >= 1 then
      P_deleteitem(uSource, '西域牌', 1, '南帝王');
    end;
	
    if P_getitemcount(uSource, '帝王守护灵') < 1 then
	  P_additem(uSource, '帝王守护灵', 1, '南帝王');
    end;
	
    P_MenuSay(uSource, MainMenu_5);
   return;
  end;

  if aStr == 'howtogetkey' then
    P_MenuSay(uSource, MainMenu_6);
   return;
  end;

  if aStr == 'howtogetticket' then
    P_MenuSay(uSource, MainMenu_7);
   return;
  end;

  if aStr == 'openring' then
    -- if P_GetQuestCurrentNo(uSource) ~= 1500 then 
     -- return;
    -- end;
    if P_getitemcount(uSource, '书函') < 1 then
       P_MenuSay(uSource, '没有 书函 ?');
     return;
    end;
    if P_getitemcount(uSource, '戒指') < 1 then
       P_MenuSay(uSource, '没有 戒指 ?');
     return;
    end;
    if P_getitemcount(uSource, '降魔符') < 1 then
       P_MenuSay(uSource, '没有 降魔符 ?');
     return;
    end;
    if P_getitemcount(uSource, '帝王守护灵') < 1 then
       P_MenuSay(uSource, '没有 帝王守护灵 ?');
     return;
    end;
	
    P_SetQuestNo(uSource, 1500);
    P_SetQuestCurrentNo(uSource, 1550);	
	
    P_deleteitem(uSource, '书函', 1, '南帝王');
    P_deleteitem(uSource, '戒指', 1, '南帝王');
    P_deleteitem(uSource, '降魔符', 1, '南帝王');
    P_deleteitem(uSource, '帝王守护灵', 1, '南帝王');

    if P_getitemcount(uSource, '牌王') < 1 then
	  P_additem(uSource, '牌王', 1, '南帝王');
    end;
	
	M_topmsg(string.format('%s 祝贺您,南帝王 任务结束', B_GetRealName(uSource)), 16754943);
	
    P_MenuSay(uSource, '南帝王任务结束了');
    return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  --任务HELP
  if Left == 'qhelp' then
    if _qhelp[Right] ~= nil then 
      P_MenuSay(uSource, _qhelp[Right]);
	end;
    return;
  end;
end