<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    //亂數物件
    Random rnd = new Random(DateTime.Now.Millisecond);

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Expires = -1;
        // 產生圖片亂數值放入Session
        //取得字元
        string RenderText = GenRenderText();
        Session["RenderText"] = RenderText;

        // 建立記憶體區塊
        MemoryStream memStream = new MemoryStream();
        // 設定字型及大小
        const string FONT_NAME = "Arial";
        const int FONT_SIZE = 23;

        Bitmap bmp = null;
        Graphics g = null;

        try
        {
            //設定字型
            Font font = new Font(FONT_NAME, FONT_SIZE);
            //讀取底圖
            bmp = new Bitmap(Server.MapPath("~/Images/BackGround02.jpg"));
            g = Graphics.FromImage(bmp);

            // 設定圖片寬高
            int nHeight = 0;
            int nWidth = 0;

            //存4個字元各自的起始位置(X軸)
            int[] offsetPos = new int[RenderText.Length];

            for (int i = 0; i < RenderText.Length; i++)
            {
                // 根據字型大小計算印出字體的總寬高
                SizeF sSize = g.MeasureString(RenderText[i].ToString(), font);
                // 設定圖片寬高
                nHeight = (int)sSize.Height + FONT_SIZE / 4;
                offsetPos[i] = nWidth + (int)sSize.Width / 5; //10 20 30 40
                nWidth += (int)sSize.Width;
            }

            //產生適合文字大小的圖
            bmp = new Bitmap(bmp, nWidth + 10, nHeight);
            g = Graphics.FromImage(bmp);

            for (int i = 0; i < RenderText.Length; i++)
            {
                //字體轉換角度
                Matrix myMatrix = new Matrix();
                //印出亂數字串
                myMatrix.RotateAt(rnd.Next(-40, 41), new PointF(offsetPos[i], nHeight / 2), MatrixOrder.Append);
                g.Transform = myMatrix;
                //亂數字型大小
                Random fontRnd = new Random(rnd.Next(FONT_SIZE));
                g.DrawString(
                    RenderText.Substring(i, 1),
                    new Font(FONT_NAME, fontRnd.Next(FONT_SIZE - 15, FONT_SIZE + 1)),
                    new SolidBrush(Color.Black),
                    offsetPos[i], 6);
            }

            //g.DrawString(DateTime.Now.ToLongTimeString(), font, Brushes.Red, 10, 10);
            //g.DrawString(RenderText, font, Brushes.Red, 10, 10);

            //寫入串流
            bmp.Save(memStream, ImageFormat.Png);

            // 清除Buffer
            Response.Clear();

            // 設定Output的結果為Png圖片
            Response.ContentType = "IMAGE/PNG";

            // 產出圖片
            Response.BinaryWrite(memStream.ToArray());

            Response.End();

        }
        catch { }

        finally
        {
            // Clean up the GDI+ surface
            if (null != g)
                g.Dispose();

            // Clean up the Bitmap
            if (null != bmp)
                bmp.Dispose();
        }
    }

    private string GenRenderText(int chars = 4)
    {
        string code = "12346789ABCDEFGHKLMNPQRTWXYZ";
        // 設定預設圖片文字
        string RenderText = "";

        for (int i = 1; i <= chars; i++)
        {
            RenderText += code[rnd.Next(0, code.Length)];
        }
        return RenderText;
    }
</script>