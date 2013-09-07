namespace CardDataGenerater.ZxCard
{
    using ExileExcel.Attribute;

    [Exiliable("ZX卡片数据")]
    public class ZxCardInfo
    {
        [ExileProperty("收录卡包")]
        public string CardSet { get; set; }

        [ExileProperty("色")]
        public string CardColor_Ch { get; set; }
        public string CardColor_En { get; set; }

        [ExileProperty("编号")]
        public string SerialNo { get; set; }

        [ExileProperty("版本")]
        public string Version { get; set; }

        [ExileProperty("图片名后缀")]
        public string Img_Suffix { get; set; }

        [ExileProperty("卡片名_日")]
        public string CardName_Jp { get; set; }

        [ExileProperty("卡片名_中")]
        public string CardName_Ch { get; set; }

        //罕贵度等级:PR F C UC R SR Z/XR IGR CVR
        [ExileProperty("罕贵度")]
        public string Rarity { get; set; }

        [ExileProperty("种类")]
        public string Type { get; set; }

        [ExileProperty("种族")]
        public string Race { get; set; }

        [ExileProperty("COST")]
        public string Cost { get; set; }

        [ExileProperty("力量")]
        public string Power { get; set; }

        [ExileProperty("标记")]
        public string Icon { get; set; }

        [ExileProperty("能力_中")]
        public string Ability_Ch { get; set; }

        [ExileProperty("能力_日")]
        public string Ability_Jp { get; set; }

        [ExileProperty("卡片描述_中")]
        public string Description_Ch { get; set; }

        [ExileProperty("卡片描述_日")]
        public string Description_Jp { get; set; }

        [ExileProperty("原捏他")]
        public string Neta { get; set; }

        [ExileProperty("关联")]
        public string Relation { get; set; }

        [ExileProperty("画师")]
        public string Illustrator { get; set; }

        [ExileProperty("分类")]
        public string Tag { get; set; }

        [ExileProperty("俗称")]
        public string Nickname { get; set; }

        [ExileProperty("裁定")]
        public string Ruling { get; set; }

        [ExileProperty("居然没有位置吐槽这不科学〖风教练专座")]
        public string TsugKomi { get; set; }
    }

}
