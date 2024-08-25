using Newtonsoft.Json;
using System.Net.Mail;
using System.Net;

namespace FitToFit.Auxiliary
{
    public class EmailService
    {
        public class EmailModelToParse
        {
            public string Email { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }
        }
        public void SendEmail(string message)
        {
            try
            {
                string smtpServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
                int smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
                string fromMail = Environment.GetEnvironmentVariable("MAIL") ?? "fit.korisnik@gmail.com";
                string password = Environment.GetEnvironmentVariable("PASS") ?? "snkzsribuyucusac";

                var emailData = JsonConvert.DeserializeObject<EmailModelToParse>(message);
                var recipientEmail = emailData.Email;
                var subject = emailData.Subject;
                var content = emailData.Content;

                MailMessage MailMessageObj = new MailMessage();

                MailMessageObj.From = new MailAddress(fromMail);
                MailMessageObj.Subject = subject;
                MailMessageObj.To.Add(recipientEmail);
                MailMessageObj.Body = content;

                var smtpClient = new SmtpClient()
                {
                    Host = smtpServer,
                    Port = smtpPort,
                    Credentials = new NetworkCredential(fromMail, password),
                    EnableSsl = true
                };

                smtpClient.Send(MailMessageObj);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }
    }
}
