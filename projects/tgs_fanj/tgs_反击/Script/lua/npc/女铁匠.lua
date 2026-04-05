package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '女铁匠';

--用于属性表的索引信息
local AttribIndex = {
  ['damageBody'] = '攻击',  ['damageHead'] = '打头',   ['damageArm'] = '打手',   ['damageLeg']    = '打脚',
  ['armorBody']  = '防御',  ['armorHead']  = '头防',   ['armorArm']  = '手防',   ['armorLeg']     = '脚防',
  ['AttackSpeed']= '速度',  ['accuracy']   = '命中',   ['avoid']     = '闪躲',   ['HitArmor'] = '维持',  ['recovery'] = '恢复'
};

--鉴定装备
local _qdzz = {
  ['Item'] = {
    --武器
    ['雕火龙套'] = {1, 10},
    ['银狼破皇剑'] = {1, 10},
    ['烈爪'] = {1, 10},
    ['龙恨'] = {1, 10},
    ['黄龙斧'] = {1, 10},
    ['黄龙弓'] = {1, 10},
    ['黄龙斗甲'] = {1, 10},
    ['黄金手套'] = {1, 15},
    ['忍者剑'] = {1, 15},
    ['日本刀'] = {1, 15},
    ['三叉剑'] = {1, 15},
    ['三叉戟'] = {1, 15},
    ['桂林竹枪'] = {1, 15},
    ['磐龙斧'] = {1, 15},
    ['逐日弓'] = {1, 15},
    ['黄巾刺'] = {1, 15},
    ['狮吼剑'] = {1, 15},
    ['新罗宝剑'] = {1, 15},
    ['狐狸手套'] = {1, 15},
    ['月光刀'] = {1, 15},
    ['龙光剑'] = {1, 15},
    ['狼牙戟'] = {1, 15},
    ['炎帝火灵斧'] = {1, 15},
    ['驱魔烈火弓'] = {1, 15},
    ['四季甲胄'] = {1, 15},
    ['九法手套'] = {1, 15},
    ['三飞剑'] = {1, 15},
    ['半月刀'] = {1, 15},
    ['罗汉竹枪'] = {1, 15},
    ['军神槌'] = {1, 15},
    ['太极手套'] = {1, 15},
    ['太极日剑'] = {1, 15},
    ['太极月刀'] = {1, 15},
    ['太极神枪'] = {1, 15},
    ['太极斧'] = {1, 15},
    ['太极神弓'] = {1, 15},
    ['断铠手套'] = {1, 15},
    ['霸王剑'] = {1, 15},
    ['天王刀'] = {1, 15},
    ['西域魔人枪'] = {1, 15},
    ['帝王槌'] = {1, 15},
    ['金丝斗甲'] = {1, 15},
    ['北海连环弓'] = {1, 15},
    ['桂林大斧'] = {1, 15},
    ['护国神剑'] = {1, 15},

    --衣服	
    ['男子黄龙弓服'] = {2, 10},
    ['女子黄龙弓服'] = {2, 10},
    ['男子黄金铠甲'] = {2, 15},
    ['女子黄金铠甲'] = {2, 15},
    ['男子妖华袍'] = {2, 15},
    ['女子妖华袍'] = {2, 15},
    ['男子黑龙战甲'] = {2, 15},
    ['女子黑龙战甲'] = {2, 15},
    ['男子白龙战甲'] = {2, 15},
    ['女子白龙战甲'] = {2, 15},
    ['男子太极道袍'] = {2, 15},
    ['女子太极道袍'] = {2, 15},
    ['男子魔人道袍'] = {2, 15},
    ['女子魔人道袍'] = {2, 15},
    ['男子百炼雨中客道袍'] = {2, 20},
    ['女子百炼雨中客道袍'] = {2, 20},
    ['男子紫金磐龙甲'] = {2, 20},
    ['女子紫金磐龙甲'] = {2, 20},
    ['真.男子紫金磐龙甲'] = {2, 20},
    ['真.女子紫金磐龙甲'] = {2, 20},
    --帽子
    ['男子黄龙斗笠'] = {3, 10},
    ['女子黄龙斗笠'] = {3, 10},
    ['男子黄金斗笠'] = {3, 15},
    ['女子黄金斗笠'] = {3, 15},
    ['男子妖华帽'] = {3, 15},
    ['女子妖华帽'] = {3, 15},
    ['男子黑龙头盔'] = {3, 15},
    ['女子黑龙头盔'] = {3, 15},
    ['男子太极道冠'] = {3, 15},
    ['女子太极道冠'] = {3, 15},
    ['男子魔人帽'] = {3, 15},
    ['女子魔人帽'] = {3, 15},
    ['男子百炼雨中客斗笠'] = {3, 20},
    ['女子百炼雨中客斗笠'] = {3, 20},
    ['真.男子紫金磐龙冠'] = {3, 20},
    ['真.女子紫金磐龙冠'] = {3, 20},
    --护腕
    ['男子黄龙护腕'] = {4, 10},
    ['女子黄龙护腕'] = {4, 10},	
    ['男子黄金护腕'] = {4, 10},
    ['女子黄金护腕'] = {4, 10},	
    ['男子妖华护腕'] = {4, 10},
    ['女子妖华护腕'] = {4, 10},
    ['男子黑龙护腕'] = {4, 10},
    ['女子黑龙护腕'] = {4, 10},
    ['男子太极护腕'] = {4, 10},
    ['女子太极护腕'] = {4, 10},
    ['男子魔人护腕'] = {4, 10},
    ['女子魔人护腕'] = {4, 10},
    ['男子紫金护腕'] = {4, 10},
    ['女子紫金护腕'] = {4, 10},
    ['真.男子紫金护腕'] = {4, 10},
    ['真.女子紫金护腕'] = {4, 10},
    --鞋子
    ['男子黄龙鞋'] = {5, 10},
    ['女子黄龙鞋'] = {5, 10},
    ['男子木屐'] = {5, 15},
    ['女子木屐'] = {5, 15},
    ['男子黄金战靴'] = {5, 15},
    ['女子黄金战靴'] = {5, 15},
    ['男子利齿靴'] = {5, 15},
    ['女子利齿靴'] = {5, 15},
    ['男子黑龙战靴'] = {5, 15},
    ['女子黑龙战靴'] = {5, 15},
    ['男子太极鞋'] = {5, 15},
    ['女子太极鞋'] = {5, 15},
    ['男子魔人战靴'] = {5, 15},
    ['女子魔人战靴'] = {5, 15},
    ['真.男子紫金逐日靴'] = {5, 20},
    ['真.女子紫金逐日靴'] = {5, 20},
  },
  ['Mate'] = {
    --武器
    [1] = {
      {'鉴定石', 1},
    },
    --衣服
    [2] = {
      {'鉴定石', 1},
    },
    --帽子
    [3] = {
      {'鉴定石', 1},
    },
    --护腕
    [4] = {
      {'鉴定石', 1},
    },
    --鞋子
    [5] = {
      {'鉴定石', 1},
    },
  },
  ['Data'] = {
    --武器
    [1] = {
      {'damageBody',1, 20},
    },
    --衣服
    [2] = {
      {'armorBody', 1, 10},
    },
    --帽子
    [3] = {
      {'accuracy', 1, 3},
    },
    --护腕
    [4] = {
      {'recovery', 1, 2},
    },
    --鞋子
    [5] = {
      {'avoid', 1, 3},
    },
  },
};


--升段配置
local _sd = {
  --可升段道具(id,最高段数)
  item = {
    ['雕火龙套'] = {1, 4},
    ['银狼破皇剑'] = {1, 4},
    ['烈爪'] = {1, 4},
    ['龙恨'] = {1, 4},
    ['黄龙斧'] = {1, 4},
    ['男子黄龙斗笠'] = {1, 4},
    ['女子黄龙斗笠'] = {1, 4},
    ['男子黄龙弓服'] = {1, 4},
    ['女子黄龙弓服'] = {1, 4},
    ['男子黄龙护腕'] = {1, 4},
    ['女子黄龙护腕'] = {1, 4},
    ['男子黄龙鞋'] = {1, 4},
    ['女子黄龙鞋'] = {1, 4},
    ['黄龙弓'] = {1, 4},
    ['黄龙斗甲'] = {1, 4},
	
    ['黄金手套'] = {2, 4},
    ['忍者剑'] = {2, 4},
    ['三叉剑'] = {2, 4},
    ['新罗宝剑'] = {2, 4},
    ['日本刀'] = {2, 4},
    ['三叉戟'] = {2, 4},
    ['桂林竹枪'] = {2, 4},
    ['磐龙斧'] = {2, 4},
    ['男子黄金斗笠'] = {2, 4},
    ['女子黄金斗笠'] = {2, 4},
    ['男子黄金护腕'] = {2, 4},
    ['女子黄金护腕'] = {2, 4},
    ['男子木屐'] = {2, 4},
    ['女子木屐'] = {2, 4},
    ['男子黄金铠甲'] = {2, 4},
    ['女子黄金铠甲'] = {2, 4},

    ['狐狸手套'] = {3, 4},	
    ['龙光剑'] = {3, 4},
    ['月光刀'] = {3, 4},
    ['狼牙戟'] = {3, 4},
    ['炎帝火灵斧'] = {3, 4},
    ['四季甲胄'] = {3, 4},
    ['驱魔烈火弓'] = {3, 4},
    ['男子妖华帽'] = {3, 4},
    ['女子妖华帽'] = {3, 4},
    ['男子妖华护腕'] = {3, 4},
    ['女子妖华护腕'] = {3, 4},
    ['男子利齿靴'] = {3, 4},
    ['女子利齿靴'] = {3, 4},
    ['男子妖华袍'] = {3, 4},
    ['女子妖华袍'] = {3, 4},

    ['九法手套'] = {4, 4},
    ['三飞剑'] = {4, 4},
    ['半月刀'] = {4, 4},
    ['罗汉竹枪'] = {4, 4},
    ['背星棍'] = {4, 4},
    ['军神槌'] = {4, 4},
    ['男子黑龙斗笠'] = {4, 4},
    ['女子黑龙斗笠'] = {4, 4},
    ['男子黑龙护腕'] = {4, 4},
    ['女子黑龙护腕'] = {4, 4},
    ['男子黑龙战靴'] = {4, 4},
    ['女子黑龙战靴'] = {4, 4},
    ['男子黑龙战甲'] = {4, 4},
    ['女子黑龙战甲'] = {4, 4},

    ['太极手套'] = {5, 4},
    ['太极日剑'] = {5, 4},
    ['太极月刀'] = {5, 4},
    ['太极神枪'] = {5, 4},
    ['太极斧'] = {5, 4},
    ['男子太极道冠'] = {5, 4},
    ['女子太极道冠'] = {5, 4},
    ['男子太极护腕'] = {5, 4},
    ['女子太极护腕'] = {5, 4},
    ['男子太极鞋'] = {5, 4},
    ['女子太极鞋'] = {5, 4},
    ['男子太极道袍'] = {5, 4},
    ['女子太极道袍'] = {5, 4},

    ['断铠手套'] = {6, 4},
    ['霸王剑'] = {6, 4},
    ['天王刀'] = {6, 4},
    ['西域魔人枪'] = {6, 4},
    ['帝王槌'] = {6, 4},
    ['北海连环弓'] = {6, 4},
    ['金丝斗甲'] = {6, 4},
    ['男子魔人帽'] = {6, 4},
    ['女子魔人帽'] = {6, 4},
    ['男子魔人护腕'] = {6, 4},
    ['女子魔人护腕'] = {6, 4},
    ['男子魔人战靴'] = {6, 4},
    ['女子魔人战靴'] = {6, 4},
    ['男子魔人道袍'] = {6, 4},
    ['女子魔人道袍'] = {6, 4},

  },
  --材料,机率,失败处理（0不处理，1降级，2消失，几率）
  mate = { 
    --黄龙
	[1] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
    --王陵
	[2] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
    --狐狸
	[3] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
    --极乐
	[4] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
    --太极
	[5] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
    --魔人
	[5] = {
      [1] = {'溶华素:1', 90, 2, 100},
      [2] = {'逐龙丹:1', 60, 2, 100},
      [3] = {'太极液:1', 30, 2, 100},
      [4] = {'桂圆丹:1', 15, 2, 100},
	},
  },
  --附加成功率道具
  suss = {
    ['生死梦幻丹'] = 30,
    ['草芥丹'] = 15,
  },
};

--合成配置
--段数,材料,合成后装备,合成后段数
local _hc = {
  ['雕火龙套'] = {4, '合成石:100;钱币:500000', '黄金手套', 2},
  ['银狼破皇剑'] = {4, '合成石:100;钱币:500000', '新罗宝剑', 2},
  ['烈爪'] = {4, '合成石:100;钱币:500000', '三叉戟', 2},
  ['龙恨'] = {4, '合成石:100;钱币:500000', '桂林竹枪', 2},
  ['黄龙斧'] = {4, '合成石:100;钱币:500000', '磐龙斧', 2},
  ['女子黄龙斗笠'] = {4, '合成石:100;钱币:500000', '女子黄金头盔', 2},
  ['女子黄龙护腕'] = {4, '合成石:100;钱币:500000', '女子黄金护腕', 2},
  ['女子黄龙弓服'] = {4, '合成石:100;钱币:500000', '女子黄金铠甲', 2},
  ['女子黄龙鞋'] = {4, '合成石:100;钱币:500000', '女子黄金战靴', 2},
  ['男子黄龙斗笠'] = {4, '合成石:100;钱币:500000', '男子黄金头盔', 2},
  ['男子黄龙护腕'] = {4, '合成石:100;钱币:500000', '男子黄金护腕', 2},
  ['男子黄龙弓服'] = {4, '合成石:100;钱币:500000', '男子黄金铠甲', 2},
  ['男子黄龙鞋'] = {4, '合成石:100;钱币:500000', '男子黄金战靴', 2},
  ['黄金手套'] = {4, '合成石:100;钱币:500000', '狐狸手套', 2},
  ['新罗宝剑'] = {4, '合成石:100;钱币:500000', '龙光剑', 2},
  ['三叉戟'] = {4, '合成石:100;钱币:500000', '月光刀', 2},
  ['桂林竹枪'] = {4, '合成石:100;钱币:500000', '狼牙戟', 2},
  ['磐龙斧'] = {4, '合成石:100;钱币:500000', '炎帝火灵斧', 2},
  ['女子黄金头盔'] = {4, '合成石:100;钱币:500000', '女子妖华帽', 2},
  ['女子黄金护腕'] = {4, '合成石:100;钱币:500000', '女子妖华护腕', 2},
  ['女子黄金战靴'] = {4, '合成石:100;钱币:500000', '女子利齿鞋', 2},
  ['女子黄金铠甲'] = {4, '合成石:100;钱币:500000', '女子妖华袍', 2},
  ['男子黄金头盔'] = {4, '合成石:100;钱币:500000', '男子妖华帽', 2},
  ['男子黄金护腕'] = {4, '合成石:100;钱币:500000', '男子妖华护腕', 2},
  ['男子黄金战靴'] = {4, '合成石:100;钱币:500000', '男子利齿鞋', 2},
  ['男子黄金铠甲'] = {4, '合成石:100;钱币:500000', '男子妖华袍', 2},
  ['狐狸手套'] = {4, '合成石:100;钱币:500000', '九法手套', 2},
  ['龙光剑'] = {4, '合成石:100;钱币:500000', '三飞剑', 2},
  ['月光刀'] = {4, '合成石:100;钱币:500000', '半月刀', 2},
  ['狼牙戟'] = {4, '合成石:100;钱币:500000', '罗汉竹枪', 2},
  ['炎帝火灵斧'] = {4, '合成石:100;钱币:500000', '军神槌', 2},
  ['女子妖华帽'] = {4, '合成石:100;钱币:500000', '女子黑龙斗笠', 2},
  ['女子妖华护腕'] = {4, '合成石:100;钱币:500000', '女子黑龙护腕', 2},
  ['女子利齿鞋'] = {4, '合成石:100;钱币:500000', '女子黑龙战靴', 2},
  ['女子妖华袍'] = {4, '合成石:100;钱币:500000', '女子黑龙战甲', 2},
  ['男子妖华帽'] = {4, '合成石:100;钱币:500000', '男子黑龙斗笠', 2},
  ['男子妖华护腕'] = {4, '合成石:100;钱币:500000', '男子黑龙护腕', 2},
  ['男子利齿鞋'] = {4, '合成石:100;钱币:500000', '男子黑龙战靴', 2},
  ['男子妖华袍'] = {4, '合成石:100;钱币:500000', '男子黑龙战甲', 2},
  ['九法手套'] = {4, '合成石:100;钱币:500000', '太极手套', 2},
  ['三飞剑'] = {4, '合成石:100;钱币:500000', '太极日剑', 2},
  ['半月刀'] = {4, '合成石:100;钱币:500000', '太极月刀', 2},
  ['罗汉竹枪'] = {4, '合成石:100;钱币:500000', '太极神枪', 2},
  ['军神槌'] = {4, '合成石:100;钱币:500000', '太极斧', 2},
  ['女子黑龙斗笠'] = {4, '合成石:100;钱币:500000', '女子太极道冠', 2},
  ['女子黑龙护腕'] = {4, '合成石:100;钱币:500000', '女子太极护腕', 2},
  ['女子黑龙战靴'] = {4, '合成石:100;钱币:500000', '女子太极鞋', 2},
  ['女子黑龙战甲'] = {4, '合成石:100;钱币:500000', '女子太极道袍', 2},
  ['男子黑龙斗笠'] = {4, '合成石:100;钱币:500000', '男子太极道冠', 2},
  ['男子黑龙护腕'] = {4, '合成石:100;钱币:500000', '男子太极护腕', 2},
  ['男子黑龙战靴'] = {4, '合成石:100;钱币:500000', '男子太极鞋', 2},
  ['男子黑龙战甲'] = {4, '合成石:100;钱币:500000', '男子太极道袍', 2},
  ['太极手套'] = {4, '神兵图鉴:100;钱币:500000', '断铠手套', 2},
  ['太极日剑'] = {4, '神兵图鉴:100;钱币:500000', '霸王剑', 2},
  ['太极月刀'] = {4, '神兵图鉴:100;钱币:500000', '天王刀', 2},
  ['太极神枪'] = {4, '神兵图鉴:100;钱币:500000', '西域魔人枪', 2},
  ['太极斧 '] = {4, '神兵图鉴:100;钱币:500000', '帝王槌', 2},
  ['女子太极道冠'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人帽', 2},
  ['女子太极护腕'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人护腕', 2},
  ['女子太极鞋 '] = {4, '神兵图鉴:100;钱币:500000', '女子魔人战靴', 2},
  ['女子太极道袍'] = {4, '神兵图鉴:100;钱币:500000', '女子魔人道袍', 2},
  ['男子太极道冠'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人帽', 2},
  ['男子太极护腕'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人护腕', 2},
  ['男子太极鞋 '] = {4, '神兵图鉴:100;钱币:500000', '男子魔人战靴', 2},
  ['男子太极道袍'] = {4, '神兵图鉴:100;钱币:500000', '男子魔人道袍', 2},
  ['黄龙斗甲'] = {4, '神兵图鉴:100;钱币:500000', '四季甲胄', 2},
  ['黄龙弓'] = {4, '神兵图鉴:100;钱币:500000', '驱魔烈火弓', 2},
  ['四季甲胄'] = {4, '神兵图鉴:100;钱币:500000', '金丝斗甲', 2},
  ['驱魔烈火弓'] = {4, '神兵图鉴:100;钱币:500000', '北海连环弓', 2},
};


--升段合成配置
--鉴定装备
local _hcsd = {
  --允许合成的装备 对应材料ID
  Item = {
    --黄龙
    ['雕火龙套'] = 1,
    ['银狼破皇剑'] = 1,
    ['烈爪'] = 1,
    ['龙恨'] = 1,
    ['黄龙斧'] = 1,
    ['黄龙弓'] = 1,
    ['黄龙斗甲'] = {1, 1},
    ['男子黄龙弓服'] = 1,
    ['女子黄龙弓服'] = 1,
    ['男子黄龙斗笠'] = 1,
    ['女子黄龙斗笠'] = 1,
    ['男子黄龙护腕'] = 1,
    ['女子黄龙护腕'] = 1,
    ['男子黄龙鞋'] = 1,
    ['女子黄龙鞋'] = 1,
	--王灵
    ['黄金手套'] = 2,
    ['忍者剑'] = 2,
    ['日本刀'] = 2,
    ['三叉剑'] = 2,
    ['三叉戟'] = 2,
    ['桂林竹枪'] = 2,
    ['磐龙斧'] = 2,
    ['逐日弓'] = 2,
    ['黄巾刺'] = 2,
    ['狮吼剑'] = 2,
    ['新罗宝剑'] = 2,
    ['男子黄金铠甲'] = 2,
    ['女子黄金铠甲'] = 2,
    ['男子黄金头盔'] = 2,
    ['女子黄金头盔'] = 2,
    ['男子黄金护腕'] = 2,
    ['女子黄金护腕'] = 2,
    ['男子黄金战靴'] = 2,
    ['女子黄金战靴'] = 2,
	--狐狸
    ['狐狸手套'] = 3,
    ['月光刀'] = 3,
    ['龙光剑'] = 3,
    ['狼牙戟'] = 3,
    ['炎帝火灵斧'] = 3,
    ['驱魔烈火弓'] = 3,
    ['四季甲胄'] = 3,
    ['男子妖华袍'] = 3,
    ['女子妖华袍'] = 3,
    ['男子妖狐帽'] = 3,
    ['女子妖狐帽'] = 3,
    ['男子妖狐护腕'] = 3,
    ['女子妖狐护腕'] = 3,
    ['男子利齿靴'] = 3,
    ['女子利齿靴'] = 3,
	--极乐
    ['九法手套'] = 4,
    ['三飞剑'] = 4,
    ['半月刀'] = 4,
    ['罗汉竹枪'] = 4,
    ['军神槌'] = 4,
    ['男子黑龙战甲'] = 4,
    ['女子黑龙战甲'] = 4,
    ['男子白龙战甲'] = 4,
    ['女子白龙战甲'] = 4,
    ['男子黑龙头盔'] = 4,
    ['女子黑龙头盔'] = 4,
    ['男子黑龙护腕'] = 4,
    ['女子黑龙护腕'] = 4,
    ['男子黑龙战靴'] = 4,
    ['女子黑龙战靴'] = 4,
	--太极
    ['太极手套'] = 5,
    ['太极日剑'] = 5,
    ['太极月刀'] = 5,
    ['太极神枪'] = 5,
    ['太极斧'] = 5,
    ['太极神弓'] = 5,
    ['男子太极道袍'] = 5,
    ['女子太极道袍'] = 5,
    ['男子太极道冠'] = 5,
    ['女子太极道冠'] = 5,
    ['男子太极护腕'] = 5,
    ['女子太极护腕'] = 5,
    ['男子太极鞋'] = 5,
    ['女子太极鞋'] = 5,
	--帝王
    ['断铠手套'] = 6,
    ['霸王剑'] = 6,
    ['天王刀'] = 6,
    ['西域魔人枪'] = 6,
    ['帝王槌'] = 6,
    ['金丝斗甲'] = 6,
    ['北海连环弓'] = 6,
    ['男子魔人道袍'] = 6,
    ['女子魔人道袍'] = 6,
    ['男子魔人帽'] = 6,
    ['女子魔人帽'] = 6,
    ['男子魔人护腕'] = 6,
    ['女子魔人护腕'] = 6,
    ['男子魔人战靴'] = 6,
    ['女子魔人战靴'] = 6,
	--重返
    ['桂林大斧'] = 7,
    ['护国神剑'] = 7,
    ['男子百炼雨中客道袍'] = 7,
    ['女子百炼雨中客道袍'] = 7,
    ['男子紫金磐龙甲'] = 7,
    ['女子紫金磐龙甲'] = 7,
    ['真.男子紫金磐龙甲'] = 7,
    ['真.女子紫金磐龙甲'] = 7,
    ['男子百炼雨中客斗笠'] = 7,
    ['女子百炼雨中客斗笠'] = 7,
    ['真.男子紫金磐龙冠'] = 7,
    ['真.女子紫金磐龙冠'] = 7,
    ['男子紫金护腕'] = 7,
    ['女子紫金护腕'] = 7,
    ['真.男子紫金护腕'] = 7,
    ['真.女子紫金护腕'] = 7,
    ['真.男子紫金逐日靴'] = 7,
    ['真.女子紫金逐日靴'] = 7,
  },
  --合成装备最高段数
  Max = 4,
  --材料
  Mate = {
    --黄龙
    [1] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --王灵
    [2] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --狐狸
    [3] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --极乐
    [4] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --太极
    [5] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --帝王
    [6] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
    --重返
    [7] = {
      [1] = {'金元:1;钱币:1000', 100},
      [2] = {'金元:2;钱币:2000', 80},
      [3] = {'金元:3;钱币:3000', 60},
      [4] = {'金元:4;钱币:4000', 40},
    },
  },
};

local MainMenu =
[[
可以鉴定或合成升段装备^^
<『$00FFFF00| 开始 装备强化』/@jdzb>^
<『$00FFFF00| 查看 强化属性』/@ckjd>^
<『$00FFFF00| 清洗 强化属性』/@qxjd>^
<『$00FFFF00| 装备 升段』/@sd>^
]];

local CKQDMenu =
[[
请放入要查看的装备^
<『$00FFFF00| 已放入 查看鉴定』/@qrckjd>
]];

local QDMenu =
[[
请放入要鉴定的装备^
注意:每次鉴定需要一定的材料!!!^^
<『$00FFFF00| 好的 我要开始鉴定装备』/@ksqd>
]];

local QXMenu =
[[
鉴定的属性不满意^
可以使用 清洗石 清洗掉鉴定属性^
<『$00FFFF00| 好的 』/@xzqx>
]];

local SDMenu =
[[
升级装备只需要放入装备，不需要放入升段药^
附加材料框 可以放入增加成功率的药品^
草芥丹增加当前升段15%成功率
生死梦幻丹增加当前升段30%成功率
药材商出售升段药
^
<「游标.bmp」『$00FFFF00| 已放入,确认升段』/@qrsd>
]];

local HCMenu =
[[
请放入需要合成的装备^
^
<「游标.bmp」『$00FFFF00| 已放入,确认合成』/@qrhc>
]];

local SDHCMenu =
[[
3件同段的装备可合成下一段^
注意:合成后保留主装备鉴定属性^
如合成失败副装备以及材料消失^
^
<『$00FFFF00| 已放入,开始升段』/@kssdhc>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'fanhui' then
     P_MenuSay(uSource, MainMenu);
    return;
  end;
  
  --查看 装备鉴定属性
  if aStr == 'ckjd' then
    P_MenuSay(uSource, CKQDMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '查看装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  if aStr == 'qrckjd' then
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 59 then 
      P_MenuSay(uSource, '请放入查看装备');
      return;
	end;
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData.Name == '' or _qdzz.Item[ItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入装备或不能鉴定!');
      return;
	end;
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, Key);
	--判断鉴定次数
	if DiyTable['DiyNum'] < 0 then 
	  P_MenuSay(uSource, '装备未签定');
	 return;
	end;
	--查询数据
    local Data = M_GetMySqlDataSet(string.format('SELECT * FROM item_diy WHERE itemid=%d ORDER BY id DESC;', ItemData.Id));
    if Data == nil or type(Data[1]) ~= 'table' then
      P_MenuSay(uSource, '没有鉴定记录');
      return;
    end;
	local Str = ItemData.Name .. ' 鉴定属性:^';
	--显示当前属性
	local t ='';
	for key, value in pairs(DiyTable) do 
	  if tonumber(value) ~= 0 and AttribIndex[key] ~= nil then 
	    local n = 0;
	    if Data[1] ~= nil then 
	      n = tonumber(Data[1][key]) or 0;
	    end;
	    t = string.format('%s[%s:%d] (+%d) ', t, AttribIndex[key], value, value - n);
	  end
	end;
	if t == '' then 
	  t = '无属性';
	end
	Str = string.format('%s%d(当前属性): %s^', Str, DiyTable['DiyNum'], t);
    for i = 1, #Data do
	  if type(Data[i]) == 'table' then
	    local t ='';
	    for key, value in pairs(Data[i]) do 
	      if tonumber(value) ~= 0 and AttribIndex[key] ~= nil then 
		    local n = 0;
			if Data[i+1] ~= nil then 
			  n = tonumber(Data[i+1][key]) or 0;
			end;
	        t = string.format('%s[%s:%d] (+%d) ', t, AttribIndex[key], value, value - n);
	      end
	    end;
	    if t == '' then 
	      t = '无属性';
	    end
	    Str = string.format('%s%d: %s^', Str, Data[i].DiyNum, t);
	  end;
	end;
    Str = string.format('%s^<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);    
    return;
  end;
  
  --清洗鉴定装备
  if aStr == 'qxjd' then
    P_MenuSay(uSource, QXMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '清洗装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  --提示清洗
  if aStr == 'xzqx' then
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 59 then 
      P_MenuSay(uSource, '请放入需要清洗的装备');
      return;
	end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入需要清洗的装备!');
      return;
	end;
	--判断是否可以鉴定
	local Index = _qdzz['Item'][ItemData.Name];
	if Index == nil then
      P_MenuSay(uSource, string.format('%s 无法强化', ItemData.Name));
      return;
	end;
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, Key);
	--判断鉴定次数
	if DiyTable['DiyNum'] < 0 then 
	  P_MenuSay(uSource, '装备未强化');
	 return;
	end;
	--获取mysql里数据
	local tmp = {DiyNum = 0};
    local Data = M_GetMySqlDataSet(string.format('SELECT * FROM item_diy WHERE itemid=%d and DiyNum=%d ORDER BY id DESC LIMIT 1;', ItemData.Id, DiyTable['DiyNum'] - 1));
    if Data ~= nil and type(Data[1]) == 'table' then
      tmp = Data[1];
	  tmp['DiyNum'] = DiyTable['DiyNum'] - 1;
    end;
	--提示
	local Str = ItemData.Name .. ' 强化清洗:^';
    Str = string.format('%s清洗后强化次数: %d^', Str, tmp['DiyNum']);
    Str = string.format('%s清洗后强化属性: %s^', Str, _GetAttribInfo(tmp));
    Str = string.format('%s清洗需要材料: 清洗石*1^', Str);
    Str = string.format('%s^<『$00FFFF00| 确认清洗强化属性』/@ksqx>', Str);
    Str = string.format('%s^<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);   
    return;
  end;

  --开始清洗
  if aStr == 'ksqx' then
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 59 then 
      P_MenuSay(uSource, '请放入需要清洗的装备');
      return;
	end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入需要清洗的装备!');
      return;
	end;
	--判断是否可以鉴定
	local Index = _qdzz['Item'][ItemData.Name];
	if Index == nil then
      P_MenuSay(uSource, string.format('%s 无法强化', ItemData.Name));
      return;
	end;
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, Key);
	--判断鉴定次数
	if DiyTable['DiyNum'] < 0 then 
	  P_MenuSay(uSource, '装备未强化');
	 return;
	end;
	--判断道具
	if P_getitemcount(uSource, '清洗石') < 1 then 
      P_MenuSay(uSource, '需要清洗石*1');
	  return;
	end;
	--获取mysql里数据
	local tmp = {DiyNum = 0};
    local Data = M_GetMySqlDataSet(string.format('SELECT * FROM item_diy WHERE itemid=%d and DiyNum=%d ORDER BY id DESC LIMIT 1;', ItemData.Id, DiyTable['DiyNum'] - 1));
    if Data ~= nil and type(Data[1]) == 'table' then
      tmp = Data[1];
	  tmp['DiyNum'] = DiyTable['DiyNum'] - 1;
	  --删除mysql
	  M_DoMySql(string.format('DELETE FROM item_diy WHERE itemid=%d and DiyNum=%d ORDER BY id DESC LIMIT 1;', ItemData.Id, DiyTable['DiyNum'] - 1));
    end;
	--删除材料
	P_deleteitem(uSource, '清洗石', 1, '女铁匠');	
	--保存属性
    P_SetHaveItemDiyLifeData(uSource, Key, tmp);
    --组成输出字符
    P_MenuSay(uSource, '强化属性清洗成功');        		
    return;
  end;

  --合成升段
  if aStr == 'hcsd' then
    P_MenuSay(uSource, SDHCMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '主装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    P_ItemInputWindowsOpen(uSource, 1, '副装备1', '');
    P_setItemInputWindowsKey(uSource, 1, -1);
    P_ItemInputWindowsOpen(uSource, 2, '副装备2', '');
    P_setItemInputWindowsKey(uSource, 2, -1);
    return;
  end;
  
  --开始升段
  if aStr == 'kssdhc' then
    --判断放入物品
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段主装备');
      return;
	end;
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	if bKey < 0 or bKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local cKey = P_getItemInputWindowsKey(uSource, 2);
	if cKey < 0 or cKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	if aKey == bKey or aKey == cKey or bKey == cKey then 
      P_MenuSay(uSource, '不能放入相同装备');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData.Name == '' or _hcsd.Item[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入主装备或不能合成!');
      return;
	end;
	local bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	if bItemData.Name == '' or bItemData.Name ~= aItemData.Name or bItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备1 不符合条件');
      return;
	end;
	local cItemData = P_GetHaveItemInfoTabs(uSource, cKey);
	if cItemData.Name == '' or cItemData.Name ~= aItemData.Name or cItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备2 不符合条件');
      return;
	end; 
	--判断段数
	if aItemData.Upgrade >= _hcsd.Max then 
      P_MenuSay(uSource, '主装备 段数已满');
      return;
	end;
	--判断材料
	local Index = _hcsd.Item[aItemData.Name];
	local t = _hcsd.Mate[Index][aItemData.Upgrade + 1];
	if t == nil then 
      P_MenuSay(uSource, '主装备 不可升段');
      return;
	end; 
    --组成输出字符
    local Str = string.format('确认合成 %s(%d段)吗?^', aItemData.Name, aItemData.Upgrade + 1);
	Str = string.format('%s主装备:%s(%d段)^', Str, aItemData.Name, aItemData.Upgrade);
	Str = string.format('%s副装备1:%s(%d段)^', Str, bItemData.Name, bItemData.Upgrade);
	Str = string.format('%s副装备2:%s(%d段)^', Str, cItemData.Name, cItemData.Upgrade);
	Str = string.format('%s合成材料:%s^', Str, t[1]);
	Str = string.format('%s成功率:%d%%^', Str, t[2]);
    Str = string.format('%s^<『$00FFFF00| 确认合成』/@qrsddc>^', Str);
    Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);    
    return;
  end;
  
  --开始升段
  if aStr == 'qrsddc' then
    --判断放入物品
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段主装备');
      return;
	end;
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	if bKey < 0 or bKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	local cKey = P_getItemInputWindowsKey(uSource, 2);
	if cKey < 0 or cKey > 59 then 
      P_MenuSay(uSource, '请放入升段副装备1');
      return;
	end;
	if aKey == bKey or aKey == cKey or bKey == cKey then 
      P_MenuSay(uSource, '不能放入相同装备');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData.Name == '' or _hcsd.Item[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入主装备或不能合成!');
      return;
	end;
	local bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	if bItemData.Name == '' or bItemData.Name ~= aItemData.Name or bItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备1 不符合条件');
      return;
	end;
	local cItemData = P_GetHaveItemInfoTabs(uSource, cKey);
	if cItemData.Name == '' or cItemData.Name ~= aItemData.Name or cItemData.Upgrade ~= aItemData.Upgrade then
      P_MenuSay(uSource, '副装备2 不符合条件');
      return;
	end; 
	--判断段数
	if aItemData.Upgrade >= _hcsd.Max then 
      P_MenuSay(uSource, '主装备 段数已满');
      return;
	end;
	--判断材料
	local Upgrade = aItemData.Upgrade + 1;
	local Index = _hcsd.Item[aItemData.Name];
	local t = _hcsd.Mate[Index][Upgrade];
	if t == nil then 
      P_MenuSay(uSource, '主装备 不可升段');
      return;
	end; 
	--分解材料为table
	local _t = lua_Strtotable(t[1], ';');
    for i, v in pairs(_t) do
      _t[i] = lua_Strtotable(v, ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要 %s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '女铁匠');
      end
    end;
	--删除副装备
	P_DelHaveItemInfo(uSource, bKey, -1);
	P_DelHaveItemInfo(uSource, cKey, -1);
	--失败处理
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random(100);math.random(100);math.random(100);
	if math.random(100) > t[2] then 
      P_MenuSay(uSource, '很可惜,本次合成失败了');	
	  M_topmsg(string.format('女铁匠:很可惜 %s 合成 %s(%d段)失败', B_GetRealName(uSource), aItemData.Name, Upgrade), 33023);  
	 return;
	end;
	--改变主装备段数
	P_SetItemField(uSource, 0, 'rUpgrade', aKey, Upgrade);
	--提示
    P_MenuSay(uSource, string.format('%s 升段成功', aItemData.Name));
	--全服公告	
	M_topmsg(string.format('女铁匠:恭喜 %s 合成 %s(%d段) 成功', B_GetRealName(uSource), aItemData.Name, Upgrade), 33023);  
    return;
  end;

  --升段
  if aStr == 'sd' then
    P_MenuSay(uSource, SDMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '升段装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    P_ItemInputWindowsOpen(uSource, 1, '附加材料', '');
    P_setItemInputWindowsKey(uSource, 1, -1);
    return;
  end;
  
  --确认升段
  if aStr == 'qrsd' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入升段的装备');
      return;
	end;
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil or ItemData.Name == '' or _sd.item[ItemData.Name] == nil then
      P_MenuSay(uSource, '放入装备不可升段!');
      return;
	end;
	if ItemData.Upgrade >= _sd.item[ItemData.Name][2] then 
      P_MenuSay(uSource, '装备段数已满!');
      return;
	end;
    --判断附加材料
	local bKey = P_getItemInputWindowsKey(uSource, 1);
	local rItem = false;
	local bItemData = {};
	if bKey > -1 and bKey < 59 then 
      bItemData = P_GetHaveItemInfoTabs(uSource, bKey);
	  if bItemData == nil or bItemData.Name == '' or _sd.suss[bItemData.Name] == nil then
        P_MenuSay(uSource, '附加材料放入错误!');
        return;
	  end;
	  rItem = true;
	end;
	local Index = _sd.item[ItemData.Name][1];
	local t = _sd.mate[Index][ItemData.Upgrade + 1];
	--分解材料为table
	local _t = lua_Strtotable(t[1], ';');
    for i, v in pairs(_t) do
      _t[i] = lua_Strtotable(v, ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要材料%s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '女铁匠');
      end
    end;
	--成功率
	local m = t[2];
	--是否放入辅助道具
	if rItem then 
	  P_DelHaveItemInfo(uSource, bKey, 1);
	  m = m + math.floor(m * _sd.suss[bItemData.Name] // 100);
	end;
    --检测作弊
    local PlayCheat = P_GetCheatings(uSource);
    if PlayCheat > 0 then 
       m = m + PlayCheat;	
       P_SetCheatings(uSource, 0);
    end;
	--判断是否成功
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();math.random();math.random();
	--升段成功
    if math.random(0, 100) <= m then
	  --改变段数
	  P_SetItemField(uSource, 0, 'rUpgrade', aKey, ItemData.Upgrade + 1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 成功', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段成功!^^<『$00FFFF00|继续升段』/@sd>^^<『$00FFFF00|返 回』/@fanhui>');
      return;
    end;
    --失败降级处理
	if t[3] == 1 and math.random(0, 100) <= t[4] then 
	  --改变段数
	  P_SetItemField(uSource, 0, 'rUpgrade', aKey, ItemData.Upgrade - 1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败,装备已降级', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!已降级^^<『$00FFFF00|返 回』/@fanhui>');
	--失败删除处理
	elseif t[3] == 2 and math.random(0, 100) <= t[4] then 
	  --删除装备
	  P_DelHaveItemInfo(uSource, aKey, -1);
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败,装备已消失', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!已消失^^<『$00FFFF00|返 回』/@fanhui>');
	--失败无惩罚
	else
	  --公告
      M_topmsg(string.format('%s 升 %s %d段 失败', B_GetRealName(uSource), ItemData.Name, ItemData.Upgrade + 1), 11295231);
	  P_MenuSay(uSource, '装备升段失败!^^<『$00FFFF00|返 回』/@fanhui>');
	end
    return;
  end;

  --合成
  if aStr == 'hc' then
    P_MenuSay(uSource, HCMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '合成装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;
  
  --确认合成
  if aStr == 'qrhc' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 59 then 
      P_MenuSay(uSource, '请放入合成的装备');
      return;
	end;
	local ItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if ItemData == nil or ItemData.Name == '' or _hc[ItemData.Name] == nil then
      P_MenuSay(uSource, '放入装备不可合成!');
      return;
	end;
	--判断段数
	if ItemData.Upgrade ~= _hc[ItemData.Name][1] then 
      P_MenuSay(uSource, '放入装备段数不对!');
      return;
	end;
	--分解材料为table
	local _t = lua_Strtotable(_hc[ItemData.Name][2], ';');
	for m = 1, #_t do
	  _t[m] = lua_Strtotable(_t[m], ':');
	end
	--判断材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('需要材料%s*%d', v[1], v[2]));
          return;
        end;
      end
    end;
	--删除材料
    for i, v in pairs(_t) do
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '女铁匠');
      end
    end;
	--删除装备
	P_DelHaveItemInfo(uSource, aKey, -1);
	--给与合成后装备
	P_addItemUpgrade(uSource, _hc[ItemData.Name][3], 1, _hc[ItemData.Name][4], '女铁匠');
	--公告
	M_topmsg(string.format('%s 合成了 %s %d段', B_GetRealName(uSource), _hc[ItemData.Name][3], _hc[ItemData.Name][4]), 11295231);
	--提示
	P_MenuSay(uSource, '装备合成成功!');
    return;
  end;

  --鉴定装备
  if aStr == 'jdzb' then
     P_MenuSay(uSource, QDMenu, true);
    P_ItemInputWindowsOpen(uSource, 0, '鉴定装备', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  --开始鉴定
  if aStr == 'ksqd' then
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 59 then 
      P_MenuSay(uSource, '请放入需要鉴定的装备');
      return;
	end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请将你需要鉴定的装备放置物品栏第一格!');
      return;
	end;
	--判断是否可以鉴定
	local Index = _qdzz['Item'][ItemData.Name];
	if Index == nil then
      P_MenuSay(uSource, string.format('【%s】无法鉴定', ItemData.Name));
      return;
	end;
	--判断道具
	for i, v in pairs(_qdzz['Mate'][Index[1]]) do	
	  if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then 
          P_MenuSay(uSource, string.format('需要%d个%s', v[2], v[1]));
         return;
        end;
	  end
	end;	
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, Key);
	--判断鉴定次数
	if DiyTable['DiyNum'] >= Index[2] then 
	  P_MenuSay(uSource, '鉴定次数已满,无法鉴定');
	 return;
	end;
	--删除材料
	for i, v in pairs(_qdzz['Mate'][Index[1]]) do	
	  if type(v) == 'table' then
	    P_deleteitem(uSource, v[1], v[2], '女铁匠');
	  end
	end;		
	--获取随机数值
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random(100);math.random(100);math.random(100);
	--判断是否失败
	if math.random(100) < 30 then 
	  P_MenuSay(uSource, '很可惜,本次鉴定失败了!!^<『$00FFFF00| 继续鉴定』/@ksqd>');
  	  M_topmsg(string.format('女铁匠:[%s]鉴定[%s]失败了!!', B_GetRealName(uSource), ItemData.Name), 33023);    		
	 return;
	end;
	--记录当前次数属性   	 
	if DiyTable['DiyNum'] > 0 then 
      --写入MYSQL
	  local aStr = '';
	  local bStr = '';
      for key, value in pairs(DiyTable) do 
        if value ~= 0 and AttribIndex[key] ~= nil then 
	      aStr = string.format('%s%s,', aStr, key);
	      bStr = string.format('%s%d,', bStr, value);
        end
      end;	 
	  --去除一个,号
	  if #aStr > 0 then 
	    aStr = aStr:sub(1, -2);
	    bStr = bStr:sub(1, -2);
	  end;
	  --执行sql
	  M_DoMySql(string.format('INSERT item_diy (itemid,DiyNum,%s) VALUES (%d,%d,%s);', aStr, ItemData.Id, DiyTable['DiyNum'], bStr));	
	end;	 
    --获取随机属性
	local _ran = #_qdzz['Data'][Index[1]];
    local _tmp = _qdzz['Data'][Index[1]][math.random(_ran)];
	local _num = math.random(_tmp[2], _tmp[3]);
	--速度恢复取反
	if _tmp[1] == 'AttackSpeed' or _tmp[1] == 'recovery' then 
	  _num = 0 - _num;
	end;	
    --保存属性
    DiyTable[_tmp[1]] = DiyTable[_tmp[1]] + _num;
	--判断最小值
    if _tmp[1] == 'AttackSpeed' or _tmp[1] == 'recovery' then 
	  if DiyTable[_tmp[1]] > 0 then 
	    DiyTable[_tmp[1]] = 0;
	  end;
	else
	  if DiyTable[_tmp[1]] < 0 then 
	    DiyTable[_tmp[1]] = 0;
	  end;
	end;		
    --次数+1
    DiyTable['DiyNum'] = DiyTable['DiyNum'] + 1;    
    --保存属性
    P_SetHaveItemDiyLifeData(uSource, Key, DiyTable);
    --组成输出字符
    local Str = '鉴定成功,';
	Str = string.format('%s属性增加[%s:%d]^', Str, AttribIndex[_tmp[1]], _num);
    Str = string.format('%s^<『$00FFFF00| 继续鉴定』/@ksqd>^', Str);
    Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);    
    --公告
	--M_topmsg(string.format('女铁匠:[%s]鉴定[%s]属性增加[%s:%d]', B_GetRealName(uSource), ItemData.Name, AttribIndex[_tmp[1]], _num), 33023);    		
	M_topmsg(string.format('女铁匠:[%s]鉴定[%s]成功了!!', B_GetRealName(uSource), ItemData.Name), 33023);    
    return;
  end;

 return;
end

function _GetTableStr(t)
  if type(t) ~= 'table' then return '' end;
  local Str = '';
  for i, v in pairs(t) do
    if type(v) == 'table' then
      Str = string.format('%s[%d个%s]  ', Str, v[2], v[1]);
    end
  end;
  return Str;
end