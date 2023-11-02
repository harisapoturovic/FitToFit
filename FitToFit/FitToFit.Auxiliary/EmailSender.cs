using System.Net;
using System.Net.Mail;

namespace FitToFit.Auxiliary
{
    public class EmailSender : IEmailSender
    {
        private readonly string _mail = Environment.GetEnvironmentVariable("MAIL") ?? "fit.korisnik@gmail.com";
        private readonly string _password = Environment.GetEnvironmentVariable("PASS") ?? "snkzsribuyucusac";

        public EmailSender()
        {
        }

        public Task SendEmailAsync(string email, string subject, string message)
        {
            
            var client = new SmtpClient("smtp.gmail.com", 587) //587 465
            {
                EnableSsl = true,
                UseDefaultCredentials = false,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Credentials = new NetworkCredential(_mail, _password),
            };

            return client.SendMailAsync(
                new MailMessage(from: _mail,
                                to: email,
                                subject: subject,
                                body: message
                                ));
        }
    }
}
