using EasyNetQ;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public class MessageProducer : IMessageProducer
    {
        private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitmq"; 
        private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
        private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

        public void SendingMessage(string message)
        {
            try
            {
                var factory = new ConnectionFactory
                {
                    HostName = _host,
                    UserName = _username,
                    Password = _password,
                    VirtualHost = _virtualhost,
                };

                using var connection = factory.CreateConnection();
                using var channel = connection.CreateModel();

                channel.QueueDeclare(queue: "reservation_added",
                                     durable: false,
                                     exclusive: false,
                                     autoDelete: false,
                                     arguments: null
                                  );


                var body = Encoding.UTF8.GetBytes(message);

                channel.BasicPublish(exchange: string.Empty,
                                     routingKey: "reservation_added",
                                     basicProperties: null,
                                     body: body);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while sending message to RabbitMQ: {ex.Message}");
            }
        }
        public void SendingObject<T>(T obj)
        {
            var factory = new ConnectionFactory
            {
                HostName = _host,
                UserName = _username,
                Password = _password,
                VirtualHost = _virtualhost,
            };

            factory.ClientProvidedName = "Rabbit Test";

            IConnection connection = factory.CreateConnection();
            IModel channel = connection.CreateModel();

            string exchangeName = "ReservationAddedExchange";
            string routingKey = "reservation_added_queue";
            string queueName = "ReservationAdded";

            channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
            channel.QueueDeclare(queueName, true, false, false, null);
            channel.QueueBind(queueName, exchangeName, routingKey, null);

            string emailModelJson = JsonConvert.SerializeObject(obj);
            byte[] messageBodyBytes = Encoding.UTF8.GetBytes(emailModelJson);
            channel.BasicPublish(exchangeName, routingKey, null, messageBodyBytes);
        }
    }
}
