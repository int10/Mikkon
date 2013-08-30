#include "stdio.h"
#include "bios.h"
#include "string.h"
#include "LEDTABLE.h"

const Uint16 led_status[]={STATUS_LED_0,STATUS_LED_1,STATUS_LED_2,STATUS_LED_3,STATUS_LED_4,STATUS_LED_5,STATUS_LED_6,STATUS_LED_7,
STATUS_LED_8,STATUS_LED_9,STATUS_LED_10,STATUS_LED_11,STATUS_LED_12,STATUS_LED_13,STATUS_LED_14,STATUS_LED_15,
STATUS_LED_16,STATUS_LED_17,STATUS_LED_18,STATUS_LED_19,STATUS_LED_20,STATUS_LED_21,STATUS_LED_22,STATUS_LED_23,
STATUS_LED_24,STATUS_LED_25,STATUS_LED_26,STATUS_LED_27,STATUS_LED_28,STATUS_LED_29,STATUS_LED_30,STATUS_LED_31,
STATUS_LED_32,STATUS_LED_33,STATUS_LED_34,STATUS_LED_35,STATUS_LED_36,STATUS_LED_37,STATUS_LED_38,STATUS_LED_39,
STATUS_LED_40,STATUS_LED_41,STATUS_LED_42,STATUS_LED_43,STATUS_LED_44,STATUS_LED_45,STATUS_LED_46,STATUS_LED_47,
STATUS_LED_48,STATUS_LED_49,STATUS_LED_50,STATUS_LED_51,STATUS_LED_52,STATUS_LED_53,STATUS_LED_54,STATUS_LED_55,
STATUS_LED_56,STATUS_LED_57,STATUS_LED_58,STATUS_LED_59,STATUS_LED_60,STATUS_LED_61,STATUS_LED_62,
STATUS_LED_63,STATUS_LED_64,STATUS_LED_65,STATUS_LED_66,STATUS_LED_67,STATUS_LED_68,STATUS_LED_69,STATUS_LED_70,
STATUS_LED_71,STATUS_LED_72,STATUS_LED_73,STATUS_LED_74,STATUS_LED_75,STATUS_LED_76,STATUS_LED_77,STATUS_LED_78,
STATUS_LED_79,STATUS_LED_80,STATUS_LED_81,STATUS_LED_82,STATUS_LED_83,STATUS_LED_84,STATUS_LED_85,
STATUS_LED_86,STATUS_LED_87,STATUS_LED_88,STATUS_LED_89,STATUS_LED_90,STATUS_LED_91,STATUS_LED_92,STATUS_LED_93,
STATUS_LED_94,STATUS_LED_95,STATUS_LED_96,STATUS_LED_97,STATUS_LED_98,STATUS_LED_99,STATUS_LED_100,STATUS_LED_101,
STATUS_LED_102,STATUS_LED_103,STATUS_LED_104,STATUS_LED_105,STATUS_LED_106,STATUS_LED_107,STATUS_LED_108,STATUS_LED_109,
STATUS_LED_110,STATUS_LED_111,STATUS_LED_112,STATUS_LED_113,STATUS_LED_114,STATUS_LED_115,STATUS_LED_116,STATUS_LED_117,
STATUS_LED_118,STATUS_LED_119,STATUS_LED_120,STATUS_LED_121,STATUS_LED_122,STATUS_LED_123,STATUS_LED_124,STATUS_LED_125,
STATUS_LED_126,STATUS_LED_END

};


const MODULE_ELEMENT  module_a0[] = {
{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TA},
{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},{STATUS_LED_58,TIME_CODE_TA},
{STATUS_LED_59,TIME_CODE_TA},{STATUS_LED_60,TIME_CODE_TA},{STATUS_LED_58,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TA},
{STATUS_LED_99,TIME_CODE_TA},{STATUS_LED_98,TIME_CODE_TA},{STATUS_LED_97,TIME_CODE_TA},{STATUS_LED_96,TIME_CODE_TA},{STATUS_LED_95,TIME_CODE_TA},{STATUS_LED_94,TIME_CODE_TA},
{STATUS_LED_93,TIME_CODE_TA},{STATUS_LED_92,TIME_CODE_TA},{STATUS_LED_91,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},
{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},
{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},
{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},
{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},
{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},
{STATUS_LED_61,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},
{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},
{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_91,TIME_CODE_TA},{STATUS_LED_92,TIME_CODE_TA},{STATUS_LED_93,TIME_CODE_TA},{STATUS_LED_94,TIME_CODE_TA},{STATUS_LED_95,TIME_CODE_TA},
{STATUS_LED_96,TIME_CODE_TA},{STATUS_LED_97,TIME_CODE_TA},{STATUS_LED_98,TIME_CODE_TA},{STATUS_LED_99,TIME_CODE_TA},{STATUS_LED_100,TIME_CODE_TA},{STATUS_LED_101,TIME_CODE_TA},
{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},
{STATUS_LED_108,TIME_CODE_TA},{STATUS_LED_109,TIME_CODE_TA},{STATUS_LED_110,TIME_CODE_TA},{STATUS_LED_111,TIME_CODE_TA},{STATUS_LED_112,TIME_CODE_TA},{STATUS_LED_113,TIME_CODE_TA},
{STATUS_LED_114,TIME_CODE_TA},{STATUS_LED_115,TIME_CODE_TA},{STATUS_LED_116,TIME_CODE_TA},{STATUS_LED_117,TIME_CODE_TA},{STATUS_LED_118,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},
{STATUS_LED_58,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},{STATUS_LED_58,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},{STATUS_LED_58,TIME_CODE_TA},{STATUS_LED_57,TIME_CODE_TA},
{STATUS_LED_58,TIME_CODE_TA},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_54,TIME_CODE_TA},{STATUS_LED_55,TIME_CODE_TA},{STATUS_LED_56,TIME_CODE_TA},{STATUS_LED_54,TIME_CODE_TA},
{STATUS_LED_55,TIME_CODE_TA},{STATUS_LED_56,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TA},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TA},
{STATUS_LED_END,TIME_CODE_END},
};


const MODULE_ELEMENT  module_a1[] = {
{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},
{STATUS_LED_92,TIME_CODE_TB},{STATUS_LED_93,TIME_CODE_TB},{STATUS_LED_94,TIME_CODE_TB},{STATUS_LED_95,TIME_CODE_TB},{STATUS_LED_96,TIME_CODE_TB},{STATUS_LED_97,TIME_CODE_TB},
{STATUS_LED_98,TIME_CODE_TB},{STATUS_LED_99,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TB},{STATUS_LED_101,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TB},
{STATUS_LED_99,TIME_CODE_TB},{STATUS_LED_98,TIME_CODE_TB},{STATUS_LED_97,TIME_CODE_TB},{STATUS_LED_96,TIME_CODE_TB},{STATUS_LED_95,TIME_CODE_TB},{STATUS_LED_94,TIME_CODE_TB},
{STATUS_LED_93,TIME_CODE_TB},{STATUS_LED_92,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_104,TIME_CODE_TB},
{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},
{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_104,TIME_CODE_TB},
{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},
{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},
{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},
{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_80,TIME_CODE_TB},{STATUS_LED_81,TIME_CODE_TB},{STATUS_LED_82,TIME_CODE_TB},{STATUS_LED_83,TIME_CODE_TB},
{STATUS_LED_84,TIME_CODE_TB},{STATUS_LED_85,TIME_CODE_TB},{STATUS_LED_86,TIME_CODE_TB},{STATUS_LED_87,TIME_CODE_TB},{STATUS_LED_88,TIME_CODE_TB},{STATUS_LED_89,TIME_CODE_TB},
{STATUS_LED_90,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},{STATUS_LED_92,TIME_CODE_TB},{STATUS_LED_93,TIME_CODE_TB},{STATUS_LED_94,TIME_CODE_TB},{STATUS_LED_95,TIME_CODE_TB},
{STATUS_LED_96,TIME_CODE_TB},{STATUS_LED_97,TIME_CODE_TB},{STATUS_LED_98,TIME_CODE_TB},{STATUS_LED_99,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TB},{STATUS_LED_101,TIME_CODE_TB},
{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},
{STATUS_LED_108,TIME_CODE_TB},{STATUS_LED_109,TIME_CODE_TB},{STATUS_LED_110,TIME_CODE_TB},{STATUS_LED_111,TIME_CODE_TB},{STATUS_LED_112,TIME_CODE_TB},{STATUS_LED_113,TIME_CODE_TB},
{STATUS_LED_114,TIME_CODE_TB},{STATUS_LED_115,TIME_CODE_TB},{STATUS_LED_116,TIME_CODE_TB},{STATUS_LED_117,TIME_CODE_TB},{STATUS_LED_118,TIME_CODE_TB},{STATUS_LED_57,TIME_CODE_TB},
{STATUS_LED_58,TIME_CODE_TB},{STATUS_LED_57,TIME_CODE_TB},{STATUS_LED_58,TIME_CODE_TB},{STATUS_LED_57,TIME_CODE_TB},{STATUS_LED_58,TIME_CODE_TB},{STATUS_LED_57,TIME_CODE_TB},
{STATUS_LED_58,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_54,TIME_CODE_TB},{STATUS_LED_55,TIME_CODE_TB},{STATUS_LED_56,TIME_CODE_TB},{STATUS_LED_57,TIME_CODE_TB},
{STATUS_LED_58,TIME_CODE_TB},{STATUS_LED_59,TIME_CODE_TB},{STATUS_LED_60,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},{STATUS_LED_62,TIME_CODE_TB},{STATUS_LED_61,TIME_CODE_TB},
{STATUS_LED_END,TIME_CODE_END},
};
const MODULE_ELEMENT  module_a2[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_a3[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_a4[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_a5[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_b0[] = {
{STATUS_LED_80,TIME_CODE_TB},{STATUS_LED_81,TIME_CODE_TB},{STATUS_LED_82,TIME_CODE_TB},{STATUS_LED_83,TIME_CODE_TB},{STATUS_LED_84,TIME_CODE_TB},{STATUS_LED_85,TIME_CODE_TB},
{STATUS_LED_86,TIME_CODE_TB},{STATUS_LED_87,TIME_CODE_TB},{STATUS_LED_88,TIME_CODE_TB},{STATUS_LED_89,TIME_CODE_TB},{STATUS_LED_90,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},
{STATUS_LED_92,TIME_CODE_TC},{STATUS_LED_93,TIME_CODE_TC},{STATUS_LED_94,TIME_CODE_TC},{STATUS_LED_95,TIME_CODE_TC},{STATUS_LED_96,TIME_CODE_TC},{STATUS_LED_97,TIME_CODE_TC},
{STATUS_LED_98,TIME_CODE_TC},{STATUS_LED_99,TIME_CODE_TC},{STATUS_LED_100,TIME_CODE_TC},{STATUS_LED_101,TIME_CODE_TC},{STATUS_LED_102,TIME_CODE_TC},{STATUS_LED_103,TIME_CODE_TB},
{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_108,TIME_CODE_TB},{STATUS_LED_109,TIME_CODE_TB},
{STATUS_LED_110,TIME_CODE_TB},{STATUS_LED_111,TIME_CODE_TB},{STATUS_LED_112,TIME_CODE_TB},{STATUS_LED_113,TIME_CODE_TB},{STATUS_LED_114,TIME_CODE_TB},{STATUS_LED_115,TIME_CODE_TB},
{STATUS_LED_116,TIME_CODE_TB},{STATUS_LED_117,TIME_CODE_TB},{STATUS_LED_118,TIME_CODE_TB},{STATUS_LED_80,TIME_CODE_TB},{STATUS_LED_81,TIME_CODE_TB},{STATUS_LED_82,TIME_CODE_TB},
{STATUS_LED_83,TIME_CODE_TB},{STATUS_LED_84,TIME_CODE_TB},{STATUS_LED_85,TIME_CODE_TB},{STATUS_LED_86,TIME_CODE_TB},{STATUS_LED_87,TIME_CODE_TB},{STATUS_LED_88,TIME_CODE_TB},
{STATUS_LED_89,TIME_CODE_TB},{STATUS_LED_90,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},{STATUS_LED_92,TIME_CODE_TB},{STATUS_LED_93,TIME_CODE_TB},{STATUS_LED_94,TIME_CODE_TB},
{STATUS_LED_95,TIME_CODE_TB},{STATUS_LED_96,TIME_CODE_TB},{STATUS_LED_97,TIME_CODE_TB},{STATUS_LED_98,TIME_CODE_TB},{STATUS_LED_99,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TB},
{STATUS_LED_101,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},
{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_108,TIME_CODE_TB},{STATUS_LED_109,TIME_CODE_TB},{STATUS_LED_110,TIME_CODE_TB},{STATUS_LED_111,TIME_CODE_TB},{STATUS_LED_112,TIME_CODE_TB},
{STATUS_LED_113,TIME_CODE_TB},{STATUS_LED_114,TIME_CODE_TB},{STATUS_LED_115,TIME_CODE_TB},{STATUS_LED_116,TIME_CODE_TB},{STATUS_LED_117,TIME_CODE_TB},{STATUS_LED_118,TIME_CODE_TB},
{STATUS_LED_80,TIME_CODE_TB},{STATUS_LED_81,TIME_CODE_TB},{STATUS_LED_82,TIME_CODE_TB},{STATUS_LED_83,TIME_CODE_TB},{STATUS_LED_84,TIME_CODE_TB},{STATUS_LED_85,TIME_CODE_TB},
{STATUS_LED_86,TIME_CODE_TB},{STATUS_LED_87,TIME_CODE_TB},{STATUS_LED_88,TIME_CODE_TB},{STATUS_LED_89,TIME_CODE_TB},{STATUS_LED_90,TIME_CODE_TB},{STATUS_LED_91,TIME_CODE_TB},
{STATUS_LED_92,TIME_CODE_TB},{STATUS_LED_93,TIME_CODE_TB},{STATUS_LED_94,TIME_CODE_TB},{STATUS_LED_95,TIME_CODE_TB},{STATUS_LED_96,TIME_CODE_TB},{STATUS_LED_97,TIME_CODE_TB},
{STATUS_LED_98,TIME_CODE_TB},{STATUS_LED_99,TIME_CODE_TB},{STATUS_LED_100,TIME_CODE_TB},{STATUS_LED_101,TIME_CODE_TB},{STATUS_LED_102,TIME_CODE_TB},{STATUS_LED_103,TIME_CODE_TB},
{STATUS_LED_104,TIME_CODE_TB},{STATUS_LED_105,TIME_CODE_TB},{STATUS_LED_106,TIME_CODE_TB},{STATUS_LED_107,TIME_CODE_TB},{STATUS_LED_108,TIME_CODE_TB},{STATUS_LED_109,TIME_CODE_TB},
{STATUS_LED_110,TIME_CODE_TB},{STATUS_LED_111,TIME_CODE_TB},{STATUS_LED_112,TIME_CODE_TB},{STATUS_LED_113,TIME_CODE_TB},{STATUS_LED_114,TIME_CODE_TB},{STATUS_LED_115,TIME_CODE_TC},
{STATUS_LED_END,TIME_CODE_END},
};

const MODULE_ELEMENT  module_b1[] = {
{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},
{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_90,TIME_CODE_TA},
{STATUS_LED_89,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_84,TIME_CODE_TA},
{STATUS_LED_83,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},
{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},
{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},
{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},
{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},
{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},
{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_90,TIME_CODE_TA},{STATUS_LED_89,TIME_CODE_TA},{STATUS_LED_88,TIME_CODE_TA},{STATUS_LED_87,TIME_CODE_TA},{STATUS_LED_86,TIME_CODE_TA},
{STATUS_LED_85,TIME_CODE_TA},{STATUS_LED_84,TIME_CODE_TA},{STATUS_LED_83,TIME_CODE_TA},{STATUS_LED_82,TIME_CODE_TA},{STATUS_LED_81,TIME_CODE_TA},{STATUS_LED_80,TIME_CODE_TA},
{STATUS_LED_108,TIME_CODE_TA},{STATUS_LED_109,TIME_CODE_TA},{STATUS_LED_110,TIME_CODE_TA},{STATUS_LED_111,TIME_CODE_TA},{STATUS_LED_112,TIME_CODE_TA},{STATUS_LED_113,TIME_CODE_TA},
{STATUS_LED_114,TIME_CODE_TA},{STATUS_LED_115,TIME_CODE_TA},{STATUS_LED_116,TIME_CODE_TA},{STATUS_LED_117,TIME_CODE_TA},{STATUS_LED_118,TIME_CODE_TA},{STATUS_LED_108,TIME_CODE_TA},
{STATUS_LED_109,TIME_CODE_TA},{STATUS_LED_110,TIME_CODE_TA},{STATUS_LED_111,TIME_CODE_TA},{STATUS_LED_112,TIME_CODE_TA},{STATUS_LED_113,TIME_CODE_TA},{STATUS_LED_114,TIME_CODE_TA},
{STATUS_LED_115,TIME_CODE_TA},{STATUS_LED_116,TIME_CODE_TA},{STATUS_LED_117,TIME_CODE_TA},{STATUS_LED_118,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},
{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},
{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},
{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},
{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_102,TIME_CODE_TA},{STATUS_LED_103,TIME_CODE_TA},{STATUS_LED_104,TIME_CODE_TA},{STATUS_LED_105,TIME_CODE_TA},
{STATUS_LED_106,TIME_CODE_TA},{STATUS_LED_107,TIME_CODE_TA},{STATUS_LED_106,TIME_CODE_TA},
{STATUS_LED_END,TIME_CODE_END},
};
const MODULE_ELEMENT  module_b2[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_b3[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_b4[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_b5[] = {{STATUS_LED_END,TIME_CODE_END},};

const MODULE_ELEMENT  module_c0[] = {
{STATUS_LED_1,TIME_CODE_T1},{STATUS_LED_2,TIME_CODE_T1},{STATUS_LED_3,TIME_CODE_T1},{STATUS_LED_4,TIME_CODE_T1},{STATUS_LED_5,TIME_CODE_T1},{STATUS_LED_6,TIME_CODE_T1},
{STATUS_LED_7,TIME_CODE_T1},{STATUS_LED_8,TIME_CODE_T1},{STATUS_LED_9,TIME_CODE_T1},{STATUS_LED_10,TIME_CODE_T1},{STATUS_LED_11,TIME_CODE_T1},{STATUS_LED_12,TIME_CODE_T1},
{STATUS_LED_13,TIME_CODE_T1},{STATUS_LED_14,TIME_CODE_T1},{STATUS_LED_15,TIME_CODE_T1},{STATUS_LED_16,TIME_CODE_T1},{STATUS_LED_17,TIME_CODE_T1},{STATUS_LED_18,TIME_CODE_T1},
{STATUS_LED_19,TIME_CODE_T1},{STATUS_LED_20,TIME_CODE_T1},{STATUS_LED_21,TIME_CODE_T1},{STATUS_LED_22,TIME_CODE_T1},{STATUS_LED_23,TIME_CODE_T1},{STATUS_LED_24,TIME_CODE_T1},
{STATUS_LED_25,TIME_CODE_T1},{STATUS_LED_26,TIME_CODE_T1},{STATUS_LED_27,TIME_CODE_T1},{STATUS_LED_28,TIME_CODE_T1},{STATUS_LED_29,TIME_CODE_T1},{STATUS_LED_30,TIME_CODE_T1},
{STATUS_LED_31,TIME_CODE_T1},{STATUS_LED_32,TIME_CODE_T1},{STATUS_LED_33,TIME_CODE_T1},{STATUS_LED_34,TIME_CODE_T1},{STATUS_LED_35,TIME_CODE_T1},{STATUS_LED_36,TIME_CODE_T1},
{STATUS_LED_37,TIME_CODE_T1},{STATUS_LED_38,TIME_CODE_T1},{STATUS_LED_39,TIME_CODE_T1},{STATUS_LED_40,TIME_CODE_T1},{STATUS_LED_41,TIME_CODE_T1},{STATUS_LED_42,TIME_CODE_T1},
{STATUS_LED_43,TIME_CODE_T1},{STATUS_LED_44,TIME_CODE_T1},{STATUS_LED_45,TIME_CODE_T1},{STATUS_LED_46,TIME_CODE_T1},{STATUS_LED_47,TIME_CODE_T1},{STATUS_LED_48,TIME_CODE_T1},
{STATUS_LED_49,TIME_CODE_T1},{STATUS_LED_50,TIME_CODE_T1},{STATUS_LED_51,TIME_CODE_T1},{STATUS_LED_52,TIME_CODE_T1},{STATUS_LED_53,TIME_CODE_T1},{STATUS_LED_54,TIME_CODE_T1},
{STATUS_LED_55,TIME_CODE_T1},{STATUS_LED_56,TIME_CODE_T1},{STATUS_LED_57,TIME_CODE_T1},{STATUS_LED_58,TIME_CODE_T1},{STATUS_LED_59,TIME_CODE_T1},{STATUS_LED_60,TIME_CODE_T1},
{STATUS_LED_61,TIME_CODE_T1},{STATUS_LED_62,TIME_CODE_T1},{STATUS_LED_80,TIME_CODE_T1},{STATUS_LED_81,TIME_CODE_T1},{STATUS_LED_82,TIME_CODE_T1},{STATUS_LED_83,TIME_CODE_T1},
{STATUS_LED_84,TIME_CODE_T1},{STATUS_LED_85,TIME_CODE_T1},{STATUS_LED_86,TIME_CODE_T1},{STATUS_LED_87,TIME_CODE_T1},{STATUS_LED_88,TIME_CODE_T1},{STATUS_LED_89,TIME_CODE_T1},
{STATUS_LED_90,TIME_CODE_T1},{STATUS_LED_91,TIME_CODE_T1},{STATUS_LED_92,TIME_CODE_T1},{STATUS_LED_93,TIME_CODE_T1},{STATUS_LED_94,TIME_CODE_T1},{STATUS_LED_95,TIME_CODE_T1},
{STATUS_LED_96,TIME_CODE_T1},{STATUS_LED_97,TIME_CODE_T1},{STATUS_LED_98,TIME_CODE_T1},{STATUS_LED_99,TIME_CODE_T1},{STATUS_LED_100,TIME_CODE_T1},{STATUS_LED_101,TIME_CODE_T1},
{STATUS_LED_102,TIME_CODE_T1},{STATUS_LED_103,TIME_CODE_T1},{STATUS_LED_104,TIME_CODE_T1},{STATUS_LED_105,TIME_CODE_T1},{STATUS_LED_106,TIME_CODE_T1},{STATUS_LED_107,TIME_CODE_T1},
{STATUS_LED_108,TIME_CODE_T1},{STATUS_LED_109,TIME_CODE_T1},{STATUS_LED_110,TIME_CODE_T1},{STATUS_LED_111,TIME_CODE_T1},{STATUS_LED_112,TIME_CODE_T1},{STATUS_LED_113,TIME_CODE_T1},
{STATUS_LED_114,TIME_CODE_T1},{STATUS_LED_115,TIME_CODE_T1},{STATUS_LED_116,TIME_CODE_T1},{STATUS_LED_117,TIME_CODE_T1},{STATUS_LED_118,TIME_CODE_T1},{STATUS_LED_1,TIME_CODE_T1},
{STATUS_LED_2,TIME_CODE_T1},{STATUS_LED_3,TIME_CODE_T1},{STATUS_LED_4,TIME_CODE_T1},{STATUS_LED_5,TIME_CODE_T1},{STATUS_LED_6,TIME_CODE_T1},{STATUS_LED_7,TIME_CODE_T1},
{STATUS_LED_8,TIME_CODE_T1},{STATUS_LED_9,TIME_CODE_T1},{STATUS_LED_10,TIME_CODE_T1},{STATUS_LED_11,TIME_CODE_T1},{STATUS_LED_12,TIME_CODE_T1},{STATUS_LED_13,TIME_CODE_T1},
{STATUS_LED_14,TIME_CODE_T1},{STATUS_LED_15,TIME_CODE_T1},{STATUS_LED_16,TIME_CODE_T1},{STATUS_LED_17,TIME_CODE_T1},{STATUS_LED_18,TIME_CODE_T1},{STATUS_LED_19,TIME_CODE_T1},
{STATUS_LED_20,TIME_CODE_T1},{STATUS_LED_21,TIME_CODE_T1},{STATUS_LED_22,TIME_CODE_T1},{STATUS_LED_23,TIME_CODE_T1},{STATUS_LED_24,TIME_CODE_T1},{STATUS_LED_25,TIME_CODE_T1},
{STATUS_LED_26,TIME_CODE_T1},{STATUS_LED_27,TIME_CODE_T1},{STATUS_LED_28,TIME_CODE_T1},{STATUS_LED_29,TIME_CODE_T1},{STATUS_LED_30,TIME_CODE_T1},{STATUS_LED_31,TIME_CODE_T1},
{STATUS_LED_32,TIME_CODE_T1},{STATUS_LED_33,TIME_CODE_T1},{STATUS_LED_34,TIME_CODE_T1},{STATUS_LED_35,TIME_CODE_T1},{STATUS_LED_36,TIME_CODE_T1},{STATUS_LED_37,TIME_CODE_T1},
{STATUS_LED_38,TIME_CODE_T1},{STATUS_LED_39,TIME_CODE_T1},{STATUS_LED_40,TIME_CODE_T1},{STATUS_LED_41,TIME_CODE_T1},{STATUS_LED_42,TIME_CODE_T1},{STATUS_LED_43,TIME_CODE_T1},
{STATUS_LED_44,TIME_CODE_T1},{STATUS_LED_45,TIME_CODE_T1},{STATUS_LED_46,TIME_CODE_T1},{STATUS_LED_47,TIME_CODE_T1},{STATUS_LED_48,TIME_CODE_T1},{STATUS_LED_49,TIME_CODE_T1},
{STATUS_LED_50,TIME_CODE_T1},{STATUS_LED_51,TIME_CODE_T1},{STATUS_LED_52,TIME_CODE_T1},{STATUS_LED_53,TIME_CODE_T1},{STATUS_LED_54,TIME_CODE_T1},{STATUS_LED_55,TIME_CODE_T1},
{STATUS_LED_56,TIME_CODE_T1},{STATUS_LED_57,TIME_CODE_T1},{STATUS_LED_58,TIME_CODE_T1},{STATUS_LED_59,TIME_CODE_T1},{STATUS_LED_60,TIME_CODE_T1},{STATUS_LED_61,TIME_CODE_T1},
{STATUS_LED_62,TIME_CODE_T1},{STATUS_LED_80,TIME_CODE_T1},{STATUS_LED_81,TIME_CODE_T1},{STATUS_LED_82,TIME_CODE_T1},{STATUS_LED_83,TIME_CODE_T1},{STATUS_LED_84,TIME_CODE_T1},
{STATUS_LED_85,TIME_CODE_T1},{STATUS_LED_86,TIME_CODE_T1},{STATUS_LED_87,TIME_CODE_T1},{STATUS_LED_88,TIME_CODE_T1},{STATUS_LED_89,TIME_CODE_T1},{STATUS_LED_90,TIME_CODE_T1},
{STATUS_LED_91,TIME_CODE_T1},{STATUS_LED_92,TIME_CODE_T1},{STATUS_LED_93,TIME_CODE_T1},{STATUS_LED_94,TIME_CODE_T1},{STATUS_LED_95,TIME_CODE_T1},{STATUS_LED_96,TIME_CODE_T1},
{STATUS_LED_END,TIME_CODE_END},
};

const MODULE_ELEMENT  module_c1[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_c2[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_c3[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_c4[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_c5[] = {{STATUS_LED_END,TIME_CODE_END},};

const MODULE_ELEMENT  module_d0[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_d1[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_d2[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_d3[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_d4[] = {{STATUS_LED_END,TIME_CODE_END},};
const MODULE_ELEMENT  module_d5[] = {{STATUS_LED_END,TIME_CODE_END},};


const Uint8  g_pattern01_list[]={0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,
	0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01};
const Uint8  g_pattern02_list[] = {0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x02,0x02,0x02,
	0x00,0x00,0x00,0x02,0x02,0x02,0x00,0x00,0x00,0x03,0x03,0x03,0x02,0x02,0x02,0x00,0x00,0x00,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x03,0x03,0x03,0x00,
	0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x02,0x02,0x02,0x00,0x00,0x00};
const Uint8  g_pattern03_list[] = {0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,
	0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x02,0x02,0x02,0x01,0x01};
const Uint8  g_pattern04_list[] = {0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x02,0x02,0x02,0x00,
	0x00,0x00,0x02,0x02,0x02,0x00,0x00,0x00,0x03,0x03,0x03,0x02,0x02,0x02,0x00,0x00,0x00,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,
	0x00,0x02,0x02,0x02,0x01,0x01,0x01,0x02,0x02,0x02,0x00,0x00,0x00};
const Uint8  g_pattern05_list[] = {0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0xB2,0xB2,0xB2,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0xB2,0xB2,0xB2,0x01,0x01,0x01,0x03,0x03,0x03,0x00,
	0x00,0x00,0x03,0x03,0x03,0x00,0x00,0x00,0x03,0x03,0x03,0xB2,0xB2,0xB2,0x00,0x00,0x00,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00,0xB2,0xB2,0xB2,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,
	0x00,0xB2,0xB2,0xB2,0x01,0x01,0x01,0x03,0x03,0x03,0x00,0x00,0x00};
const Uint8  g_pattern06_list[] = {0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,0x01,0x01};
const Uint8  g_pattern07_list[] = {0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00};
const Uint8  g_pattern08_list[] = {0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04};
const Uint8  g_pattern09_list[] = {0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04};
const Uint8  g_pattern10_list[] = {0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04};
const Uint8  g_pattern11_list[] = {0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04};
const Uint8  g_pattern12_list[] = {0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x01,
	0x00,0x01,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x01,0x00,0x01,0x00};

const Uint16 g_time_code_map[] = {2,4,6,8,16,24,32,40,48,80,160,240,480,720,960,1440,2400,0xffff};

Uint8 binbuf[1024*1024];

#define dw_h_index	1
#define dw_l_index	0
typedef union 
{
	Uint16 u_16;
	Uint8 u_8[2];
}dword_16_8;
int main()
{
	FILE *binfile;
	Uint8 *p;
	int i,j,filesize;
	Uint16 cy_addr_index = 0x08,st_addr_index = 0x0a,pa_addr_index=0x0c,mo_addr_index=0x0e;
	dword_16_8 cytable_addr,statable_addr,patttable_addr,modindex_addr;
	dword_16_8 mo_addr[5],dw_temp;
	binfile = fopen("ou.bin","wb");

	p = binbuf;
	*p = 0x95;			//sensor gate
	p++;
	*p = 0x00;
	p++;
	*p = 0xff;			//working counter
	p++;
	*p = 0xff;
	p++;
	
	*p = 0x00;			//reserve
	p++;
	*p = 0x00;
	p++;

	*p = 0x00;			//reserve
	p++;
	*p = 0x00;
	p++;

	
	p+=0x08;		//addr

	cytable_addr.u_16= (Uint16)(p-binbuf);
//	memcpy(p,g_time_code_map,sizeof(g_time_code_map));
//	p+=sizeof(g_time_code_map);
	for(i = 0;i<sizeof(g_time_code_map)/sizeof(Uint16);i++)
	{
		dw_temp.u_16 = g_time_code_map[i];
		*p = dw_temp.u_8[dw_h_index];
		p++;
		*p = dw_temp.u_8[dw_l_index];
		p++;
		if(dw_temp.u_16 == 0xffff)
			break;
			
	}

	statable_addr.u_16 =(Uint16)(p-binbuf);
//	memcpy(p,led_status,sizeof(led_status));
//	p+=sizeof(led_status);
	for(i = 0;i<(sizeof(led_status)/sizeof(Uint16));i++)
	{
		dw_temp.u_16 = led_status[i];
		*p = dw_temp.u_8[dw_h_index];
		p++;
		*p = dw_temp.u_8[dw_l_index];
		p++;
		
	}

	patttable_addr.u_16 = (Uint16)(p-binbuf);
	printf("g_pattern01_list=%x\n",(p-binbuf));
//	for(i = 0;i<(sizeof(g_pattern01_list)/sizeof(Uint8));i++)
//	{
//		*p = g_pattern01_list[i];
//		p++;
//	}
	printf("g_pattern01_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern01_list,sizeof(g_pattern01_list));
	p+=sizeof(g_pattern01_list);
	printf("g_pattern02_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern02_list,sizeof(g_pattern02_list));
	p+=sizeof(g_pattern02_list);
	printf("g_pattern03_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern03_list,sizeof(g_pattern03_list));
	p+=sizeof(g_pattern03_list);
	printf("g_pattern04_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern04_list,sizeof(g_pattern04_list));
	p+=sizeof(g_pattern04_list);
	printf("g_pattern05_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern05_list,sizeof(g_pattern05_list));
	p+=sizeof(g_pattern05_list);
	printf("g_pattern06_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern06_list,sizeof(g_pattern06_list));
	p+=sizeof(g_pattern06_list);
	printf("g_pattern07_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern07_list,sizeof(g_pattern07_list));
	p+=sizeof(g_pattern07_list);
	printf("g_pattern08_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern08_list,sizeof(g_pattern08_list));
	p+=sizeof(g_pattern08_list);
	printf("g_pattern09_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern09_list,sizeof(g_pattern09_list));
	p+=sizeof(g_pattern09_list);
	printf("g_pattern10_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern10_list,sizeof(g_pattern10_list));
	p+=sizeof(g_pattern10_list);
	printf("g_pattern11_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern11_list,sizeof(g_pattern11_list));
	p+=sizeof(g_pattern11_list);
	printf("g_pattern12_list=%x\n",(p-binbuf));
	memcpy(p,g_pattern12_list,sizeof(g_pattern12_list));
	p+=sizeof(g_pattern12_list);
	*p= 0xff;			//pattern end
	p++;
//	printf("%x %d\n",p-binbuf,(p-binbuf)%2);
	if(((p-binbuf)%2))
	{
		*p= 0xff;
		p++;
	}



	modindex_addr.u_16 = (Uint16)(p-binbuf);
	p+=sizeof(mo_addr);


	mo_addr[0].u_16 = (Uint16)(p-binbuf);
	for(i = 0;i<255;i++)
	{
		*p=module_a0[i].time_code;
		p++;
		if(module_a0[i].status_led == STATUS_LED_END)
		{
			*p = 0xff;
			p++;
			break;
		}
		for(j=0;j<255;j++)
		{
			if(module_a0[i].status_led==led_status[j])
			{
				*p= j;
				p++;
				break;
			}
		}
	}

	mo_addr[1].u_16 = (Uint16)(p-binbuf);
	for(i = 0;i<255;i++)
	{
		*p=module_a1[i].time_code;
		p++;
		if(module_a1[i].status_led == STATUS_LED_END)
		{
			*p = 0xff;
			p++;
			break;
		}
		for(j=0;j<255;j++)
		{
			if(module_a1[i].status_led==led_status[j])
			{
				*p= j;
				p++;
				break;
			}
		}
	}
	
	mo_addr[2].u_16 = (Uint16)(p-binbuf);
	for(i = 0;i<255;i++)
	{
		*p=module_b0[i].time_code;
		p++;
		if(module_b0[i].status_led == STATUS_LED_END)
		{
			*p = 0xff;
			p++;
			break;
		}
		for(j=0;j<255;j++)
		{
			if(module_b0[i].status_led==led_status[j])
			{
				*p= j;
				p++;
				break;
			}
		}
	}

	mo_addr[3].u_16 = (Uint16)(p-binbuf);
	for(i = 0;i<255;i++)
	{
		*p=module_b1[i].time_code;
		p++;
		if(module_b1[i].status_led == STATUS_LED_END)
		{
			*p = 0xff;
			p++;
			break;
		}
		for(j=0;j<255;j++)
		{
			if(module_b1[i].status_led==led_status[j])
			{
				*p= j;
				p++;
				break;
			}
		}
	}
	mo_addr[4].u_16 = (Uint16)(p-binbuf);
	for(i = 0;i<255;i++)
	{
		*p=module_c0[i].time_code;
		p++;
		if(module_c0[i].status_led == STATUS_LED_END)
		{
			*p = 0xff;
			p++;
			break;
		}
		for(j=0;j<255;j++)
		{
			if(module_c0[i].status_led==led_status[j])
			{
				*p= j;
				p++;
				break;
			}
		}
		if(j==255)
			printf("no match!!!\n");
	}

	filesize = p-binbuf;
#if 1
	p = binbuf+ cy_addr_index;
	*p = cytable_addr.u_8[dw_h_index];
	p++;
	*p = cytable_addr.u_8[dw_l_index];

	p=binbuf+st_addr_index;
	*p = statable_addr.u_8[dw_h_index];
	p++;
	*p = statable_addr.u_8[dw_l_index];

	p=binbuf+pa_addr_index;
	*p = patttable_addr.u_8[dw_h_index];
	p++;
	*p = patttable_addr.u_8[dw_l_index];

	p=binbuf+mo_addr_index;
	*p = modindex_addr.u_8[dw_h_index];
	p++;
	*p = modindex_addr.u_8[dw_l_index];

	p=binbuf+modindex_addr.u_16;
	for(i = 0;i<5;i++)
	{
		*p = mo_addr[i].u_8[dw_h_index];
		p++;
		*p = mo_addr[i].u_8[dw_l_index];
		p++;
	}
#endif
	
	fwrite(binbuf,filesize,1,binfile);
	

	//memset(binbuf,0,sizeof(binbuf));
	//binbuf[]
	fclose(binfile);


	printf("cytable_addr=%x  statable_addr=%x  patttable_addr=%x  modindex_addr=%x \n",cytable_addr.u_16,statable_addr.u_16,patttable_addr.u_16,modindex_addr.u_16);
	printf("%x  %x  %x  %x  %x\n",mo_addr[0].u_16,mo_addr[1].u_16,mo_addr[2].u_16,mo_addr[3].u_16,mo_addr[4].u_16);
	

	printf("end!!\n");	
	//printf("Hello world!\n");
//	getchar();
}

