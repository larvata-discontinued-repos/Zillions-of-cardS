namespace CardDataGenerater.ZxCard
{
    using System;
    using System.Linq;

    internal static class Utility
    {

        internal static string ConvertColor(ColorMappingTable colorMapping, string colorValue, string defaultColorValue)
        {
            string[] mappingTable;
            switch (colorMapping)
            {
                case ColorMappingTable.ConvertFromCh:
                    mappingTable = new[] {"蓝|blue", "白|white", "黑|black", "绿|green","红|red","无|mu","龙|dragon"};
                    break;
                case ColorMappingTable.ConvertFromEn:
                    mappingTable = new[] {"black|DarkOrchid", "white|Orange","mu|Grey"};
                    break;
                default:
                    throw new ArgumentOutOfRangeException("colorMapping");
            }

            var ret = mappingTable.SingleOrDefault(c => c.Split('|').Contains(colorValue));
            if (ret == null&&string.IsNullOrEmpty(defaultColorValue))
            {
                ret = colorValue;
            }
            else if (ret == null)
            {
                ret = defaultColorValue;
            }
            else
            {
                ret = ret.Split('|')[1];
            }

            return ret;
        }

        internal enum ColorMappingTable
        {
            ConvertFromCh,
            ConvertFromEn
        }
    }
}
