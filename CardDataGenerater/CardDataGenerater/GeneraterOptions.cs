using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace CardDataGenerater
{
    class GeneraterOptions
    {
        public string ImportFileName { get; set; }
        public string OutFileName { get; set; }
        public bool OutputHTML { get; set; }
        public bool OutputJSON { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        /// <returns>sussess return 0</returns>
        public int Assert(string[] args)
        {
            for (int i = 0; i < args.Length; i++)
            {
                switch (args[i].ToLower())
                {

                    case "-i":
                        // input file
                        ImportFileName = args[i + 1].Trim();
                        i++;
                        break;
                    case "-o":
                        // out file
                        OutFileName = args[i + 1].Trim();
                        i++;
                        break;
                    case "-h":
                        // html flag
                        OutputHTML = true;
                        break;
                    case "-j":
                        // json db flag
                        OutputJSON = true;
                        break;
                }
            }

            if (string.IsNullOrEmpty(OutFileName))
            {
                OutFileName = Path.GetFileName(ImportFileName);
            }

            if (string.IsNullOrEmpty(ImportFileName))
            {
                return 1;
            }

            return 0;
        }

    }
}
