namespace CardDataGenerater
{
    using ZxCard;
    using System;
    using System.IO;
    using System.Text;
    using ExileExcel;
    using System.Web.Script.Serialization;
    using System.Collections.Generic;

    class Program
    {
        static void Main(string[] args)
        {
            var options = new GeneraterOptions();
            var initRet = options.Assert(args);
            if (initRet!=0)
            {
                Console.WriteLine("Parameter error.");
                Environment.Exit(initRet);
            }

            var excel = new ExileParser<ZxCardInfo>();
            var util= new ExileUtils();
            var sheetCount = util.GetSheetCount(options.ImportFileName);

            var cardInfos = new List<ZxCardInfo>();
            for (var i = 0; i < sheetCount; i++)
            {
                var list = excel.Parse(options.ImportFileName, i);
                cardInfos.AddRange(list);
            }



            // output json
            if (options.OutputJSON)
            {
                File.WriteAllText(options.OutFileName+".json", new JavaScriptSerializer().Serialize(cardInfos));
            }
            
            // output html
            if (options.OutputHTML)
            {
                // undertake some data transformat
                foreach (var zx in cardInfos)
                {
                    zx.CardColor_En = Utility.ConvertColor(Utility.ColorMappingTable.ConvertFromCh, zx.CardColor_Ch, "cyan");
                }

                // file template
                // 0:编号 1:颜色_英 2:颜色_中 3:罕贵度 4:种族 5:种类 6:卡片名_中 7:卡片名_日 8:费用 9:力量 10:标记 11:能力_中 12:卡片描述_中 13:原捏他 14:颜色_图标
                var sb = new StringBuilder();
                sb.AppendLine("[float=left][img=240,335]http://www.zxtcg.com/images/carditem/{0}.png[/img][/float]");

                sb.AppendLine("[table=480,white][tr][td=3,1][b][color={1}][img]http://www.zxtcg.com/images/cardlist/ico_{14}.png[/img]（{2}） {0} {3}[/color][/b][float=right]{4} {5}[/float][/td][/tr]");
                sb.AppendLine("[tr][td=3,1][b][size=4]{6}[/size][/b]");
                sb.AppendLine("{7}[/td][/tr]");
                sb.AppendLine("[tr][td][align=center][color={1}]费用[/color][/align][/td][td][align=center][color={1}]力量[/color][/align][/td][td][align=center][color={1}]标记[/color][/align][/td][/tr]");
                sb.AppendLine("[tr][td][align=center][b][size=5]{8}[/size][/b][/align][/td][td][align=center][b][size=5]{9}[/size][/b][/align][/td][td][align=center]{10}[/align][/td][/tr]");
                sb.AppendLine("[tr][td=3,1]{11}[/td][/tr]");
                sb.AppendLine("[tr][td=3,1][i]{12}[/i][/td][/tr]");
                sb.AppendLine("[tr][td=3,1]{13}[/td][/tr]");
                sb.AppendLine("[/table]");
                sb.AppendLine("[hr]");

                var fileTemplate = sb.ToString();

                using (var fs = new FileStream(options.OutFileName+".txt", FileMode.OpenOrCreate, FileAccess.Write, FileShare.None))
                {
                    using (var sw = new StreamWriter(fs, Encoding.UTF8))
                    {
                        foreach (var zx in cardInfos)
                        {
                            // 预处理
                            var flagStr = zx.Icon;
                            var flagTemplate = string.Empty;
                            switch (flagStr.ToLower())
                            {
                                case "ig":
                                    flagTemplate =
                                        "[img]http://www.zxtcg.com/images/cardnum/ig/ig_{0}.png[/img]\r\n（点燃）";
                                    break;
                                case "es":
                                    flagTemplate =
                                        "[img]http://www.zxtcg.com/images/cardnum/ig/es.png[/img]\r\n（觉醒之种）";
                                    break;
                            }
                            if (!string.IsNullOrEmpty(flagTemplate))
                            {
                                flagStr = string.Format(flagTemplate, zx.CardColor_En);
                            }

                            var outLine = 
                                string.Format(
                                    fileTemplate, zx.SerialNo,      //0
                                    Utility.ConvertColor(Utility.ColorMappingTable.ConvertFromEn, zx.CardColor_En, ""),
                                    zx.CardColor_Ch,     //2
                                    zx.Rarity,             //3
                                    zx.Race,             //4
                                    zx.Type,        //5
                                    zx.CardName_Ch,          //6
                                    zx.CardName_Jp,          //7
                                    zx.Cost,             //8
                                    zx.Power,              //9
                                    flagStr,             //10
                                    zx.Ability_Ch,       //11
                                    zx.Description_Ch,   //12
                                    zx.Neta,             //13
                                    zx.CardColor_En      //14
                                    );
                            sw.WriteLine(outLine);
                        }

                    }
                }
            }
        }
    }
}
