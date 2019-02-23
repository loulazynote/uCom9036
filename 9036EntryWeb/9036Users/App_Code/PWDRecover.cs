using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// PWDRecover 的摘要描述
/// </summary>
public class PWDRecover
{
    private Random rnd = new Random(DateTime.Now.Millisecond);

    public string RandonNum(int chars = 8)
    {
        string code = "12346789ABCDEFGHKLMNPQRTWXYZ";
        string RenderText = "";

        for (int i = 1; i <= chars; i++)
        {
            RenderText += code[rnd.Next(0, code.Length)];
        }
        return RenderText;
    }
}