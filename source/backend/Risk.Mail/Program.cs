using System;
using MailKit.Net.Proxy;
using MailKit.Net.Smtp;
using MimeKit;

namespace Risk.Mail
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("Información RISK", "informacion@risk.com.py"));
            message.To.Add(new MailboxAddress("Javier", "javier.meza@rama.com.py"));
            message.Subject = "How you doin'?";

            message.Body = new TextPart("plain")
            {
                Text = @"Hey Chandler,

I just wanted to let you know that Monica and I were going to go play some paintball, you in?

-- Joey"
            };

            using (var client = new SmtpClient())
            {
                // For demo-purposes, accept all SSL certificates (in case the server supports STARTTLS)
                // client.ServerCertificateValidationCallback = (s, c, h, e) => true;
                client.ProxyClient = new HttpProxyClient("svr0062", 8080);

                client.Connect("smtp.gmail.com", 465, true);

                // Note: only needed if the SMTP server requires authentication
                client.Authenticate("javier.meza.py@fpuna.edu.py", "rama.1212");

                client.Send(message);
                client.Disconnect(true);
            }
        }
    }
}
