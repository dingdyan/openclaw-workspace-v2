package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '装备打造师';
local _qdzz = {
  ['Item'] = {
    --武器
    ['雕火龙套'] = 1,
    ['银狼破皇剑'] = 1,
    ['烈爪'] = 1,
    ['龙恨'] = 1,
    ['黄龙斧'] = 1,
    ['黄龙弓'] = 1,
    ['黄龙斗甲'] = 1,
    ['黑龙手套'] = 1,
    ['黑龙剑'] = 1,
    ['黑龙刀'] = 1,
    ['黑龙枪'] = 1,
    ['黑龙斧'] = 1,
    ['白龙手套'] = 1,
    ['白龙剑'] = 1,
    ['白龙刀'] = 1,
    ['白龙枪'] = 1,
    ['白龙斧'] = 1,
    ['黄金手套'] = 1,
    ['忍者剑'] = 1,
    ['日本刀'] = 1,
    ['三叉剑'] = 1,
    ['三叉戟'] = 1,
    ['桂林竹枪'] = 1,
    ['磐龙斧'] = 1,
    ['新罗宝剑'] = 1,
    ['狐狸手套'] = 1,
    ['龙光剑'] = 1,
    ['月光刀'] = 1,
    ['狼牙戟'] = 1,
    ['炎帝火灵斧'] = 1,
    ['驱魔烈火弓'] = 1,
    ['四季甲胄'] = 1,
    ['九法手套'] = 1,
    ['三飞剑'] = 1,
    ['半月刀'] = 1,
    ['背星棍'] = 1,
    ['罗汉竹枪'] = 1,
    ['军神槌'] = 1,
    ['青龙手套'] = 1,
    ['太极手套'] = 1,
    ['太极日剑'] = 1,
    ['太极月刀'] = 1,
    ['太极神枪'] = 1,
    ['太极斧'] = 1,
    ['轰岩手套'] = 1,
    ['九魔密剑'] = 1,
    ['九龙宝刀'] = 1,
    ['凤翅镗'] = 1,
    ['锯齿大斧'] = 1,
    ['断铠手套'] = 1,
    ['霸王剑'] = 1,
    ['天王刀'] = 1,
    ['西域魔人枪'] = 1,
    ['帝王槌'] = 1,
    ['金丝斗甲'] = 1,
    ['北海连环弓'] = 1,
    ['百炼黄金手套'] = 1,
    ['百炼忍者剑'] = 1,
    ['百炼日本刀'] = 1,
    ['百炼三叉戟'] = 1,
    ['护国神剑'] = 1,
    ['百炼桂林竹枪'] = 1,
    ['桂林大斧'] = 1,
    ['血狂手'] = 1,
    ['血魔剑'] = 1,
    ['血风刃'] = 1,
    ['血化戟'] = 1,
    ['血皇斧'] = 1,
    ['血雨弓'] = 1,
    ['血魔斗甲'] = 1,
    ['大苍手'] = 1,
    ['阴阳剑'] = 1,
    ['无极刀'] = 1,
    ['幽冥枪'] = 1,
    ['混沌斧'] = 1,
    ['战神弓'] = 1,
    ['战神斗甲'] = 1,
    --衣服	
    ['男子黄龙弓服'] = 2,
    ['女子黄龙弓服'] = 2,
    ['男子黄金铠甲'] = 2,
    ['女子黄金铠甲'] = 2,
    ['男子妖华袍'] = 2,
    ['女子妖华袍'] = 2,
    ['男子黑龙战甲'] = 2,
    ['女子黑龙战甲'] = 2,
    ['男子白龙战甲'] = 2,
    ['女子白龙战甲'] = 2,
    ['男子青龙战甲'] = 2,
    ['女子青龙战甲'] = 2,
    ['男子太极道袍'] = 2,
    ['女子太极道袍'] = 2,
    ['男子血魔道袍'] = 2,
    ['女子血魔道袍'] = 2,
    ['男子帝王甲'] = 2,
    ['女子帝王甲'] = 2,
    ['男子将军铠甲'] = 2,
    ['女子将军铠甲'] = 2,
    ['男子魔人道袍'] = 2,
    ['女子魔人道袍'] = 2,
    ['男子天蚕纱'] = 2,
    ['女子天蚕纱'] = 2,
    ['男子百炼雨中客道袍'] = 2,
    ['女子百炼雨中客道袍'] = 2,
    ['男子战神甲'] = 2,
    ['女子战神甲'] = 2,
    --帽子
    ['男子黄金头盔'] = 3,
    ['女子黄金头盔'] = 3,
    ['男子斗笠'] = 3,
    ['女子斗笠'] = 3,
    ['男子将军帽'] = 3,
    ['女子将军帽'] = 3,
    ['男子太极道冠'] = 3,
    ['女子太极道冠'] = 3,
    ['男子魔人帽'] = 3,
    ['女子魔人帽'] = 3,
    ['男子血魔头盔'] = 3,
    ['女子血魔头盔'] = 3,
    ['男子战神头盔'] = 3,
    ['女子战神头盔'] = 3,
    ['男子百炼雨中客斗笠'] = 3,
    ['女子百炼雨中客斗笠'] = 3,
    --护腕
    ['男子黄金护腕'] = 4,
    ['女子黄金护腕'] = 4,	
    ['男子黄龙手套'] = 4,
    ['女子黄龙手套'] = 4,
    ['男子青龙护腕'] = 4,
    ['女子青龙护腕'] = 4,
    ['男子太极护腕'] = 4,
    ['女子太极护腕'] = 4,
    ['男子将军护腕'] = 4,
    ['女子将军护腕'] = 4,
    ['男子帝王护腕'] = 4,
    ['女子帝王护腕'] = 4,
    ['男子天蚕护腕'] = 4,
    ['女子天蚕护腕'] = 4,
    ['男子魔人护腕'] = 4,
    ['女子魔人护腕'] = 4,
    ['男子血魔护腕'] = 4,
    ['女子血魔护腕'] = 4,
    ['男子战神护腕'] = 4,
    ['女子战神护腕'] = 4,
    --鞋子
    ['男子黄金战靴'] = 5,
    ['女子黄金战靴'] = 5,
    ['男子利齿靴'] = 5,
    ['女子利齿靴'] = 5,
    ['男子黄龙鞋'] = 5,
    ['女子黄龙鞋'] = 5,
    ['男子太极鞋'] = 5,
    ['女子太极鞋'] = 5,
    ['男子将军战靴'] = 5,
    ['女子将军战靴'] = 5,
    ['男子魔人战靴'] = 5,
    ['女子魔人战靴'] = 5,
    ['男子血魔战靴'] = 5,
    ['女子血魔战靴'] = 5,
    ['男子战神靴'] = 5,
    ['女子战神靴'] = 5,
    --披风
    ['男子赤红袍'] = 6,
    ['女子赤红袍'] = 6,
    ['男子金蚕披风'] = 6,
    ['女子金蚕披风'] = 6,
    ['男子鸾羽九凤衣'] = 6,
    ['女子鸾羽九凤衣'] = 6,
    ['男子太极披风'] = 6,
    ['女子太极披风'] = 6,
    --腰带
    ['男子黄金腰带'] = 7,
    ['女子黄金腰带'] = 7,
    ['男子妖狐缎'] = 7,
    ['女子妖狐缎'] = 7,
    ['男子黑龙缎'] = 7,
    ['女子黑龙缎'] = 7,
    ['男子太极腰带'] = 7,
    ['女子太极腰带'] = 7,
  },
  ['Mate'] = {
    --武器
    [1] = {
      {'钱币', 50000},
    },
    --衣服
    [2] = {
      {'钱币', 50000},
    },
    --帽子
    [3] = {
      {'钱币', 30000},
    },
    --护腕
    [4] = {
      {'钱币', 30000},
    },
    --鞋子
    [5] = {
      {'钱币', 30000},
    },
    --披风
    [6] = {
      {'钱币', 30000},
    },
    --腰带
    [7] = {
      {'钱币', 30000},
    },
  },
  ['Data'] = {
    --武器
    [1] = {
      [1] = {
        {'AttackSpeed', 0, 3},
        {'damageBody',0, 150},
        {'damageArm', 0, 50},
        {'damageLeg', 0, 50},
      },
      [2] = {
        {'AttackSpeed', 0, 3},
      },
      [3] = {
        {'damageBody', 0, 150},
      },
      [4] = {
        {'damageArm', 0, 50},
      },
      [5] = {
        {'damageLeg', 0, 50},
      },
      [6] = {
        {'AttackSpeed', 0, 3},
        {'damageBody', 0, 150},
      },
      [7] = {
        {'AttackSpeed', 0, 3},
        {'damageArm', 0, 50},
      },
      [8] = {
        {'AttackSpeed', 0, 3},
        {'damageLeg', 0, 50},
      },
      [9] = {
        {'damageBody', 0, 150},
        {'damageArm', 0, 50},
      },
      [10] = {
        {'damageBody', 0, 150},
        {'damageLeg', 0, 50},
      },
      [11] = {
        {'AttackSpeed', 0, 3},
        {'damageBody', 0, 150},
        {'damageArm', 0, 50},
      },
      [12] = {
        {'AttackSpeed', 0, 3},
        {'damageArm', 0, 50},
        {'damageLeg', 0, 50},
      },
    },
    --衣服
    [2] = {
      [1] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [2] = {
        {'armorBody', 0, 100},
      },
      [3] = {
        {'armorHead', 0, 50},
      },
      [4] = {
        {'armorArm', 0, 50},
      },
      [5] = {
        {'armorLeg', 0, 50},
      },
      [6] = {
        {'KeepRecovery', 0, 80},
      },
      [7] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
      },
      [8] = {
        {'armorBody', 0, 100},
        {'armorArm', 0, 50},
      },
      [9] = {
        {'armorBody', 0, 100},
        {'armorLeg', 0, 50},
      },
      [10] = {
        {'armorBody', 0, 100},
        {'KeepRecovery', 0, 80},
      },
      [11] = {
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
      },
      [12] = {
        {'armorHead', 0, 50},
        {'armorLeg', 0, 50},
      },
      [13] = {
        {'armorHead', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [14] = {
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
      },
      [15] = {
        {'armorArm', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [16] = {
        {'armorBody', 0, 100},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [17] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [18] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
      },
      [19] = {
        {'armorBody', 0, 100},
        {'armorArm', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [20] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorLeg', 0, 50},
      },
      [21] = {
        {'armorHead', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [22] = {
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [23] = {
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
      },
      [24] = {
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [25] = {
        {'armorBody', 0, 100},
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [26] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [27] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'KeepRecovery', 0, 80},
      },
      [28] = {
        {'armorBody', 0, 100},
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
      },
      [29] = {
        {'armorHead', 0, 50},
        {'armorArm', 0, 50},
        {'armorLeg', 0, 50},
        {'KeepRecovery', 0, 80},
      },		
    },
    --帽子
    [3] = {
      [1] = {
        {'accuracy', 0, 20},
        {'KeepRecovery', 0, 50},
      },
      [2] = {
        {'KeepRecovery', 0, 50},
      },
      [3] = {
        {'accuracy', 0, 20},
      },		
    },
    --护腕
    [4] = {
      [1] = {
        {'recovery', 0, 10},
        {'KeepRecovery', 0, 50},
      },
      [2] = {
        {'KeepRecovery', 0, 50},
      },
      [3] = {
        {'recovery', 0, 10},
      },	
    },
    --鞋子
    [5] = {
      [1] = {
        {'avoid', 0, 20},
        {'KeepRecovery', 0, 30},
      },
      [2] = {
        {'KeepRecovery', 0, 30},
      },
      [3] = {
        {'avoid', 0, 20},
      },	
    },
    --披风
    [6] = {
      [1] = {
        {'avoid', 0, 8},
        {'KeepRecovery', 0, 30},
      },
      [2] = {
        {'KeepRecovery', 0, 30},
      },
      [3] = {
        {'avoid', 0, 8},
      },	
    },
    --腰带
    [7] = {
      [1] = {
        {'accuracy', 0, 8},
        {'KeepRecovery', 0, 30},
      },
      [2] = {
        {'KeepRecovery', 0, 30},
      },
      [3] = {
        {'accuracy', 0, 8},
      },	
    },
  },
};


--饰品升级
--2 二维  1 一维
local Valid = {
  ['get'] = 2,
  ['set'] = 1,
  ['reditem'] = 1,
};
local _sp = lua_SdbValidStr('Script\\lua\\sdb\\饰品.sdb', Valid);

local _yp_list = {
  '侠客玉佩(1级)',
  '侠客玉佩(2级)',
  '侠客玉佩(3级)',
  '侠客玉佩(4级)',
  '侠客玉佩(5级)',
  '侠客玉佩(6级)',
  '侠客玉佩(7级)',
  '侠客玉佩(8级)',
  '侠客玉佩(9级)',
  '侠客玉佩(10级)',
  '侠客玉佩(11级)',
  '侠客玉佩(12级)',
  '侠客玉佩(13级)',
  '侠客玉佩(14级)',
  '侠客玉佩(15级)',
  '侠客玉佩(16级)',
  '侠客玉佩(17级)',
  '侠客玉佩(18级)',
  '侠客玉佩(19级)',
  '侠客玉佩(20级)',
};

local _hsf_list = {
  '护身符(1级)',
  '护身符(2级)',
  '护身符(3级)',
  '护身符(4级)',
  '护身符(5级)',
  '护身符(6级)',
  '护身符(7级)',
  '护身符(8级)',
  '护身符(9级)',
  '护身符(10级)',
};

local _jz_list = {
  '黄龙指环',
  '帝王指环',
  '火狐指环',
  '霸王指环',
  '隐者指环',
  '新罗指环',
  '太极指环',
  '至尊指环',
  '魔人指环',
  '血魔指环',
};

--升级内甲属性
local _sjnj = {
  ['男子内甲'] = {
    {'armorBody', 1, 10}, -- 防御
  },
  ['男子护腿'] = {
    {'damageBody', 1, 20}, --攻击
  },
  ['女子内甲'] = {
    {'armorBody', 1, 10}, -- 防御
  },
  ['女子护腿'] = {
    {'damageBody', 1, 20}, --攻击
  },
};

--用于修改时表的索引信息
local AttribIndex = {
  ['damageBody'] = '攻击',  ['damageHead'] = '打头',   ['damageArm'] = '打手',   ['damageLeg']    = '打脚',
  ['armorBody']  = '防御',  ['armorHead']  = '头防',   ['armorArm']  = '手防',   ['armorLeg']     = '脚防',
  ['AttackSpeed']= '速度',  ['accuracy']   = '命中',   ['avoid']     = '闪躲',   ['KeepRecovery'] = '维持',  ['recovery'] = '恢复'
};

--时装升级配置
local _sjsz = {
  --可升级道具
  ['List'] = {
    ['男子道服(时装)'] = 1,
    ['女子道服(时装)'] = 1,
    ['男子弓服(时装)'] = 1,
    ['女子弓服(时装)'] = 1,
    ['男子黄金铠甲(时装)'] = 1,
    ['女子黄金铠甲(时装)'] = 1,
    ['男子黑龙战甲(时装)'] = 1,
    ['女子黑龙战甲(时装)'] = 1,
    ['男子太极道袍(时装)'] = 1,
    ['女子太极道袍(时装)'] = 1,
    ['男子魔人道袍(时装)'] = 1,
    ['女子魔人道袍(时装)'] = 1,
    ['男子雨中客道袍(时装)'] = 1,
    ['女子雨中客道袍(时装)'] = 1,
    ['男子昆仑袍(时装)'] = 1,
    ['女子昆仑袍(时装)'] = 1,
    ['男子忍者弓服(时装)'] = 1,
    ['女子忍者弓服(时装)'] = 1,
    ['男子金鳞裟(时装)'] = 1,
    ['女子金鳞裟(时装)'] = 1,
    ['男子桂林道袍(时装)'] = 1,
    ['女子桂林道袍(时装)'] = 1,
    ['男子梅花战袍(时装)'] = 1,
    ['女子梅花战袍(时装)'] = 1,
    ['男子花郎道袍(时装)'] = 1,
    ['女子花郎道袍(时装)'] = 1,
    ['男子桂林弓服(时装)'] = 1,
    ['女子桂林弓服(时装)'] = 1,
    ['男子长弓服(时装)'] = 1,
    ['女子长弓服(时装)'] = 1,
    ['男子翡翠袍(时装)'] = 1,
    ['女子翡翠袍(时装)'] = 1,
    ['男子烈火袍(时装)'] = 1,
    ['女子烈火袍(时装)'] = 1,
    ['男子清风袍(时装)'] = 1,
    ['女子清风袍(时装)'] = 1,
    ['男子武林袍(时装)'] = 1,
    ['女子武林袍(时装)'] = 1,
    ['男子西装(时装)'] = 1,
    ['女子婚纱(时装)'] = 1,
    ['男子侠客袍(时装)'] = 1,
    ['女子侠客袍(时装)'] = 1,
    ['男子隐士袍(时装)'] = 1,
    ['女子隐士袍(时装)'] = 1,
    ['男子月神服(时装)'] = 1,
    ['女子月神服(时装)'] = 1,
    ['男子游侠道袍(时装)'] = 1,
    ['女子游侠道袍(时装)'] = 1,
    ['男子红棉衫(时装)'] = 1,
    ['女子红棉衫(时装)'] = 1,
    ['男子蓝棉衫(时装)'] = 1,
    ['女子蓝棉衫(时装)'] = 1,
    ['男子青鸳服(时装)'] = 1,
    ['女子青鸳服(时装)'] = 1,
    ['男子赤月服(时装)'] = 1,
    ['女子赤月服(时装)'] = 1,
    ['男子唐装(时装)'] = 1,
    ['女子仙后衫(时装)'] = 1,
  },
  --升级材料
  ['UpItem'] = {
    [1] = {
	  {'武魂', 1},
	  {'钱币', 10000},
	},
    [2] = {
	  {'忍王配饰', 2},
	  {'钱币', 20000},
	},
    [3] = {
	  {'白玫瑰', 3},
	  {'钱币', 30000},
	},
    [4] = {
	  {'佛珠', 4},
	  {'钱币', 40000},
	},
  },
  --升级机率
  ['UpRam'] = {
    [1] = 80,
    [2] = 50,
    [3] = 15,
    [4] = 5,
  },
};

local MainMenu =
[[
需要打造装备吗?^

<「游标.bmp」『$00FFFF00| 打造 内甲』/@dznj>^
<「游标.bmp」『$00FFFF00| 打造 护腿』/@dzht>^
<「游标.bmp」『$00FFFF00| 升级 内甲、护腿』/@sjnj>^


]];

local SJSPMenu =
[[请放入需要升级的 玉佩^
注意:升级有一定失败机率!!!^^
<『$00FFFF00| 已放置好 确认升级』/@qrsjsp>^^
<『$00FFFF00| 返 回』/@fanhui>
]];

local QianDingMenu =
[[请放入鉴定的装备^
注意:每次鉴定需要一定的材料!!!^^
<『$00FFFF00| 已放入, 开始鉴定』/@ksqd>
]];

local NJMenu =
[[请放入升级的内甲或者护腿^
注意:每次升级需要一定的材料,最高可升级20次!!!^^
<『$00FFFF00| 已放入, 开始升级』/@kssjnj>
]];

local SZMenu =
[[
请放入升段的时装^
注意:每次升段需要相对应的材料和钱币,最高可升4段!^^
<『$00FFFF00| 已放入, 开始升段』/@kssjsz>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  --返回
  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
    return;
  end;
  
  --时装 提示
  if aStr == 'sjsz' then
	P_MenuSay(uSource, SZMenu, true);
     P_ItemInputWindowsOpen(uSource, 0, '升段时装', '');
     P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  --时装 升段
  if aStr == 'kssjsz' then
    --检查框是否为空
    local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey >= 59 then 
      P_MenuSay(uSource, '请放入需要升级的道具');
      return;
    end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil then return end;
	if ItemData.Name == '' or _sjsz['List'][ItemData.Name] == nil then
      P_MenuSay(uSource, '放入道具不可升段');
      return;
	end;
	local UpLevel = ItemData.Upgrade + 1;
	if _sjsz['UpItem'][UpLevel] == nil then 
      P_MenuSay(uSource, '段数已满');
      return;
	end;
	--判断材料
    for i, v in pairs(_sjsz['UpItem'][UpLevel]) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要%d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_sjsz['UpItem'][UpLevel]) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '装备打造师');
      end
    end;
	--判断机率
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	--失败处理
	if math.random(100) > _sjsz['UpRam'][UpLevel] then 
	  --组成输出字符
	  local Str = '很可惜,本次升段失败了^^';
	  Str = string.format('%s<『$00FFFF00| 继续升级』/@kssjsz>^^', Str);
	  Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
      P_MenuSay(uSource, Str);	
	 return;
	end;
	--成功处理
	if not P_SetHaveItemSmithingLevel(uSource, aKey, UpLevel) then 
      P_MenuSay(uSource, '升段失败,请联系GM');
      return;
	end;
	--说话
	P_MenuSay(uSource, '恭喜你,升段成功^^<「游标.bmp」<『$00FFFF00| 继续升段』/@kssjsz>');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]的%s升到%d段!', B_GetRealName(uSource), ItemData.ViewName, UpLevel), 33023, 3355443);
    return;
  end;
  
  --升级 内甲 提示
  if aStr == 'sjnj' then
	P_MenuSay(uSource, NJMenu, true);
     P_ItemInputWindowsOpen(uSource, 0, '升级道具', '');
     P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  --开始 升级 内甲
  if aStr == 'kssjnj' then
    --检查框是否为空
    local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey >= 59 then 
      P_MenuSay(uSource, '请放入需要升级的道具');
      return;
    end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil then return end;
	if ItemData.Name == '' or _sjnj[ItemData.Name] == nil then
      P_MenuSay(uSource, '请放入[内甲]或[护腿]');
      return;
	end;
    --检测玩家道具
    if P_getitemcount(uSource, '绝世残页') < 1 then 
      P_MenuSay(uSource, '你没有绝世残页1个');
     return;
    end;
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '你没有50000个钱币');
     return;
    end;	
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, aKey);
	--判断鉴定次数
	if DiyTable['DiyNum'] >= 20 then 
	  P_MenuSay(uSource, '升级次数已满,无法升级');
	 return;
	end;
	--删除道具
	P_deleteitem(uSource, '绝世残页', 1, '装备打造师');
	P_deleteitem(uSource, '钱币', 50000, '装备打造师');
	--失败处理
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	if math.random(100) < 50 then 
	  --组成输出字符
	  local Str = '很可惜,本次升级失败了^^';
	  Str = string.format('%s<『$00FFFF00| 继续升级』/@kssjnj>^^', Str);
	  Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
      P_MenuSay(uSource, Str);	
	 return;
	end;
	--获取随机属性
	local _tmp = _sjnj[ItemData.Name][math.random(#_sjnj[ItemData.Name])];
	--保存属性
    DiyTable[_tmp[1]] = DiyTable[_tmp[1]] + math.random(_tmp[2], _tmp[3]);
	--速度恢复取反
	if _tmp[1] == 'AttackSpeed' or _tmp[1] == 'recovery' then 
	  DiyTable[_tmp[1]] = 0 - DiyTable[_tmp[1]];
	end;
	--次数+1
	DiyTable['DiyNum'] = DiyTable['DiyNum'] + 1;	
	--保存属性
	P_SetHaveItemDiyLifeData(uSource, aKey, DiyTable);
	--组成输出字符
	local Str = string.format('升级成功 当前属性:%s^^', _GetAttribInfo(DiyTable));
	Str = string.format('%s<『$00FFFF00| 继续升级』/@kssjnj>^^', Str);
	Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);		
    return;
  end;
  
  --打造 护腿
  if aStr == 'dzht' then
    --检测玩家道具
    if P_getitemcount(uSource, '步法残页') < 10 then 
      P_MenuSay(uSource, '你没有步法残页10个');
     return;
    end;
    if P_getitemcount(uSource, '护体残页') < 10 then 
      P_MenuSay(uSource, '你没有护体残页10个');
     return;
    end;
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '你没有50000个钱币');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end; 
	--删除道具
	P_deleteitem(uSource, '步法残页', 10, '装备打造师');
	P_deleteitem(uSource, '武学残页', 10, '装备打造师');
	P_deleteitem(uSource, '钱币', 50000, '装备打造师');
	--给予物品
    if P_getsex(uSource) == 1 then 
	  P_additem(uSource, '男子护腿', 1, '装备打造师');
	else
	  P_additem(uSource, '女子护腿', 1, '装备打造师');
	end;
	P_additem(uSource, '护腿', 1, '装备打造师');
	--说话
	P_MenuSay(uSource, '恭喜你获得了护腿');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]打造了护腿', B_GetRealName(uSource)), 33023, 3355443);
    return;
  end;
  
  --打造 内甲
  if aStr == 'dznj' then
    --检测玩家道具
    if P_getitemcount(uSource, '护体残页') < 10 then 
      P_MenuSay(uSource, '你没有护体残页10个');
     return;
    end;
    if P_getitemcount(uSource, '心法残页') < 10 then 
      P_MenuSay(uSource, '你没有心法残页10个');
     return;
    end;
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '你没有50000个钱币');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end; 
	--删除道具
	P_deleteitem(uSource, '护体残页', 10, '装备打造师');
	P_deleteitem(uSource, '心法残页', 10, '装备打造师');
	P_deleteitem(uSource, '钱币', 50000, '装备打造师');
	--给予物品
    if P_getsex(uSource) == 1 then 
	  P_additem(uSource, '男子内甲', 1, '装备打造师');
	else
	  P_additem(uSource, '女子内甲', 1, '装备打造师');
	end;
	--说话
	P_MenuSay(uSource, '恭喜你获得了内甲');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]打造了内甲', B_GetRealName(uSource)), 33023, 3355443);
    return;
  end;

  --打造戒指
  if aStr == 'dzjz' then
    --检测玩家道具
    if P_getitemcount(uSource, '武魂') < 20 then 
      P_MenuSay(uSource, '你没有武魂20个');
     return;
    end;
    if P_getitemcount(uSource, '金元') < 3 then 
      P_MenuSay(uSource, '你没有3个金元');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--循环检测戒指是否有
	local In = false;
	for k, v in ipairs(_jz_list) do
	  --判断物品栏
	  if P_getitemcount(uSource, v) >= 1 then 
	    In = true;
		break;
	  end;
	  --判断身上装备
	  local ItemData = P_GetWearItemInfoTabs(uSource, 10);
	  if ItemData.Name == v then 
	    In = true;
		break;
	  end;		
	end
	if In then 
      P_MenuSay(uSource, '你已拥有侠客戒指,不能重复打造!');
      return;
	end; 
	--删除道具
	P_deleteitem(uSource, '武魂', 20, '装备打造师');
	P_deleteitem(uSource, '金元', 3, '装备打造师');
	--给予物品
	P_additem(uSource, '侠客戒指', 1, '装备打造师');
	--说话
	P_MenuSay(uSource, '恭喜你获得了侠客戒指');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]打造了侠客戒指', B_GetRealName(uSource)), 33023, 3355443);
    return;
  end;
  
  --打造玉佩
  if aStr == 'dzyp' then
    --检测玩家道具
    if P_getitemcount(uSource, '武魂') < 20 then 
      P_MenuSay(uSource, '你没有武魂20个');
     return;
    end;
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '你没有50000个钱币');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--循环检测玉佩是否有
	local In = false;
	for k, v in ipairs(_yp_list) do
	  --判断物品栏
	  if P_getitemcount(uSource, v) >= 1 then 
	    In = true;
		break;
	  end;
	  --判断身上装备
	  local ItemData = P_GetWearItemInfoTabs(uSource, 13);
	  if ItemData.Name == v then 
	    In = true;
		break;
	  end;		
	end
	if In then 
      P_MenuSay(uSource, '你已拥有侠客玉佩,不能重复打造!');
      return;
	end; 
	--删除道具
	P_deleteitem(uSource, '武魂', 20, '装备打造师');
	P_deleteitem(uSource, '钱币', 50000, '装备打造师');
	--给予物品
	P_additem(uSource, '侠客玉佩(1级)', 1, '装备打造师');
	--说话
	P_MenuSay(uSource, '恭喜你获得了侠客玉佩(1级)');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]打造了侠客玉佩(1级)', B_GetRealName(uSource)), 33023, 3355443);
    return;
  end;

  
  --打造 护身符
  if aStr == 'dzhsf' then
    --检测玩家道具
    if P_getitemcount(uSource, '武魂') < 20 then 
      P_MenuSay(uSource, '你没有20个武魂');
     return;
    end;
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '你没有50000个钱币');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--循环检测玉佩是否有
	local In = false;
	for k, v in ipairs(_hsf_list) do
	  --判断物品栏
	  if P_getitemcount(uSource, v) >= 1 then 
	    In = true;
		break;
	  end;
	  --判断身上装备
	  local ItemData = P_GetWearItemInfoTabs(uSource, 12);
	  if ItemData.Name == v then 
	    In = true;
		break;
	  end;		
	end
	if In then 
      P_MenuSay(uSource, '你已拥有护身符,不能重复打造!');
      return;
	end; 
	--删除道具
	P_deleteitem(uSource, '武魂', 20, '装备打造师');
	P_deleteitem(uSource, '钱币', 50000, '装备打造师');
	--给予物品
	P_additem(uSource, '护身符(1级)', 1, '装备打造师');
	--说话
	P_MenuSay(uSource, '恭喜你获得了护身符(1级)');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]打造了护身符(1级)', B_GetRealName(uSource)), 33023, 3355443);
    return;
  end;
 
  --升级饰品
  if aStr == 'sjsp' then
	P_MenuSay(uSource, SJSPMenu, true);
     P_ItemInputWindowsOpen(uSource, 0, '升级道具', '');
     P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  --确认 升级饰品
  if aStr == 'qrsjsp' then
    --检查框是否为空
    local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey >= 59 then 
      P_MenuSay(uSource, '请放入需要升级的道具');
      return;
    end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入升级的道具');
      return;
	end;  
	--判断是否顶级牌子
	if ItemData.Name == '侠客玉佩(20级)' or ItemData.Name == '护身符(20级)' or ItemData.Name == '侠客戒指' then
      P_MenuSay(uSource, '你的道具已经顶级!');
      return;
	end;  
	--判断是否可升级
	local t = _sp[ItemData.Name];
	if t == nil then 
      P_MenuSay(uSource, '放入的道具无法升级!');
      return;
	end;  
	--判断材料
    for i, v in pairs(t.get) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要%d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--判断物品栏
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	--删除材料
    for i, v in pairs(t.get) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '装备打造师');
      end
    end;
	--随机是否升级
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();math.random();math.random();
	local r = math.random(0, 100);	
	--检测作弊值
	if P_GetCheatings(uSource) == 102 then 
	   r = 0;	
	   P_SetCheatings(uSource, 0);
	end;
	if r > t.uplevl then --升级失败
	  --随机是否降级
	  if math.random(0, 100) < t.rednum then --降级处理
	    --删除原始道具
		P_deleteitem(uSource, ItemData.Name, 1, '装备打造师');
	    --给予降级道具
		P_additem(uSource, t.reditem[1], t.reditem[2], '装备打造师');
		--说话
		P_MenuSay(uSource, '很抱歉,您的侠客玉佩升级失败,并且降级了!^^<『$00FFFF00|继续升级』/@qrsjsp>');
		--公告
		M_worldnoticemsg(string.format('老铁匠:很可惜[%s]升级%s失败!并且降级了!', B_GetRealName(uSource), ItemData.ViewName), 33023, 3355443);
	  else
		--说话
		P_MenuSay(uSource, '很抱歉,升级失败了!^^<『$00FFFF00|继续升级』/@qrsjsp>');
		--公告
		M_worldnoticemsg(string.format('老铁匠:很可惜[%s]升级%s失败了!', B_GetRealName(uSource), ItemData.ViewName), 33023, 3355443);
	  end
      return;		
	end	
	--删除原始道具
	P_deleteitem(uSource, ItemData.Name, 1, '装备打造师');
	--给予物品
	P_additem(uSource, t.set[1], t.set[2], '装备打造师');
	--说话
	P_MenuSay(uSource, '恭喜你,升级成功^^<『$00FFFF00|继续升级』/@qrsjsp>');
	--公告
	M_worldnoticemsg(string.format('老铁匠:恭喜[%s]的%s升级到%s!', B_GetRealName(uSource), ItemData.ViewName, t.set[1]), 33023, 3355443);
    return;
  end;
  
  --鉴定装备
  if aStr == 'jdzb' then
     P_MenuSay(uSource, QianDingMenu, true);
     P_ItemInputWindowsOpen(uSource, 0, '鉴定装备', '');
     P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  --开始鉴定
  if aStr == 'ksqd' then
    --检查框是否为空
    local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey >= 59 then 
      P_MenuSay(uSource, '请放入需要打孔的装备');
      return;
    end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请将你需要鉴定的装备放置物品栏第一个格子!');
      return;
	end;
	--判断是否可以鉴定
	local Index = _qdzz['Item'][ItemData.Name];
	if Index == nil then
      P_MenuSay(uSource, string.format('【%s】无法鉴定', ItemData.Name));
      return;
	end;
	--判断道具
	for i, v in pairs(_qdzz['Mate'][Index]) do	
	  if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then 
          P_MenuSay(uSource, string.format('需要%d个%s', v[2], v[1]));
         return;
        end;
	  end
	end;
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, aKey);
	--判断鉴定次数
--[[	if DiyTable['DiyNum'] >= 3 then 
	  P_MenuSay(uSource, '鉴定次数已满,无法鉴定');
	 return;
	end;--]]
	--获取随机属性
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local _tmp = _qdzz['Data'][Index][math.random(#_qdzz['Data'][Index])];
	--初始化属性
	local LifeData =  {
      damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0,
      armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0,
      AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery= 0,
	  DiyNum = 0,
    };
	for k, v in pairs(_tmp) do
      LifeData[v[1]] = math.random(v[2], v[3]);
	  --鉴定次数> 70 鉴定属性< 90% 默认为90% (衣服武器处理)
	  if DiyTable['DiyNum'] > 70 and LifeData[v[1]] < math.floor(v[3] * 0.9) then
	    LifeData[v[1]] = math.random(math.floor(v[3] * 0.9), v[3])
	  --鉴定次数> 50 鉴定属性< 80% 默认为80% (衣服武器处理)
	  elseif DiyTable['DiyNum'] > 50 and LifeData[v[1]] < math.floor(v[3] * 0.8) then
	    LifeData[v[1]] = math.floor(v[3] * 0.8);
	  --鉴定次数> 30 鉴定属性< 70% 默认为70% (衣服武器处理)
	  elseif DiyTable['DiyNum'] > 30 and LifeData[v[1]] < math.floor(v[3] * 0.7) then
	    LifeData[v[1]] = math.floor(v[3] * 0.7);
	  --鉴定次数> 20 鉴定属性< 50% 默认为50%
	  elseif DiyTable['DiyNum'] > 20 and LifeData[v[1]] < math.floor(v[3] * 0.5) then
	    LifeData[v[1]] = math.floor(v[3] * 0.5);
	  --鉴定次数<= 5 随机值>0 属性减半
	  elseif DiyTable['DiyNum'] <= 5 and math.random(100) > 0 then 	
	    LifeData[v[1]] = math.floor(LifeData[v[1]] * 0.5);
	  end;
	  --速度恢复取反
	  if v[1] == 'AttackSpeed' or v[1] == 'recovery' then 
	    LifeData[v[1]] = 0 - LifeData[v[1]];
	  end;
	end	
	LifeData['DiyNum'] = DiyTable['DiyNum'] + 1;	
	--保存属性
	P_SetHaveItemDiyLifeData(uSource, aKey, LifeData);
	--删除材料
	for i, v in pairs(_qdzz['Mate'][Index]) do	
	  if type(v) == 'table' then
	    P_deleteitem(uSource, v[1], v[2], '欧冶子');
	  end
	end;	
	--组成输出字符
	local Str = string.format('鉴定成功 鉴定属性:%s^^', _GetAttribInfo(LifeData));
	Str = string.format('%s<『$00FFFF00| 继续鉴定』/@ksqd>^^', Str);
	Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);		
    return;
  end;
  
 return;
end