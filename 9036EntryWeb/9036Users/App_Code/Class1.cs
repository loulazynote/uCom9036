using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Class1 的摘要描述
/// </summary>
public class Human
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Sex { get; set; }
    public int oppositeSex_Id { get; set; } //配對的異性ID
}