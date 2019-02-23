using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;

/// <summary>
/// MailAlert 的摘要描述
/// </summary>
public class MailAlert
{
    public void SendMail(string toAdr, string sub, string msgBody)
    {
        MailMessage msg = new MailMessage();

        msg.To.Add(toAdr);
        msg.From = new MailAddress("9036.UUU@gmail.com",
            "9036.Service", System.Text.Encoding.UTF8);
        msg.Subject = sub;
        //指定Subject的編碼
        msg.SubjectEncoding = System.Text.Encoding.UTF8;

        msg.Body = msgBody;
        msg.IsBodyHtml = true;
        msg.BodyEncoding = System.Text.Encoding.UTF8;

        SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);

        //寄件者的帳號密碼
        MySmtp.Credentials = new System.Net.NetworkCredential(
            "9036.UUU@gmail.com", "20190129");
        //啟用 SSL
        MySmtp.EnableSsl = true;
        MySmtp.Send(msg);
    }
}