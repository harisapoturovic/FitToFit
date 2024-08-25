using EasyNetQ;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using FitToFit.Auxiliary;
using System.Text;
using System.Net.Mail;
using FitToFit.Auxiliary.Models;

public class BackgroundWorkerService : BackgroundService
{
    private IConnection _connection;
    private IModel _channel;

    private readonly string _host = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitmq";
    private readonly string _username = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
    private readonly string _password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";
    private readonly string _virtualhost = Environment.GetEnvironmentVariable("RABBITMQ_VIRTUALHOST") ?? "/";

    public BackgroundWorkerService()
    {
        InitRabbitMQ();
    }

    private void InitRabbitMQ()
    {
        var factory = new ConnectionFactory
        {
            HostName = _host,
            UserName = _username,
            Password = _password,
            VirtualHost = _virtualhost,
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
            RequestedHeartbeat = TimeSpan.FromSeconds(60),
            AutomaticRecoveryEnabled = true,
            NetworkRecoveryInterval = TimeSpan.FromSeconds(10),
        };

        factory.ClientProvidedName = "Rabbit Test Consumer";

        try
        {
            Console.WriteLine($"Connecting to RabbitMQ at {factory.HostName}:{factory.Port} with user {factory.UserName}");
            using (var connection = factory.CreateConnection())
            using (var channel = connection.CreateModel())
            {
                Console.WriteLine("Connected to RabbitMQ successfully.");

                string exchangeName = "ReservationAddedExchange";
                string routingKey = "reservation_added_queue";
                string queueName = "ReservationAdded";

                channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
                channel.QueueDeclare(queueName, true, false, false, null);
                channel.QueueBind(queueName, exchangeName, routingKey, null);

                var consumer = new EventingBasicConsumer(channel);

                consumer.Received += (sender, args) =>
                {
                    var body = args.Body.ToArray();
                    string message = Encoding.UTF8.GetString(body);

                    Console.WriteLine($"Message received: {message}");
                    EmailService emailService = new EmailService();
                    emailService.SendEmail(message);

                    channel.BasicAck(args.DeliveryTag, false);
                };

                channel.BasicConsume(queueName, false, consumer);

                Console.WriteLine("Waiting for messages. Press Q to quit.");

                // Sleep for a long time to keep the application running
                Thread.Sleep(Timeout.Infinite);

                // Close resources before exiting
                channel.Close();
                connection.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Connection to RabbitMQ failed: {ex.Message}");
            Console.WriteLine(ex.ToString());
        }
    }


   
    private void OnConsumerConsumerCancelled(object sender, ConsumerEventArgs e) { }
    private void OnConsumerUnregistered(object sender, ConsumerEventArgs e) { }
    private void OnConsumerRegistered(object sender, ConsumerEventArgs e) { }
    private void OnConsumerShutdown(object sender, ShutdownEventArgs e) { }
    private void RabbitMQ_ConnectionShutdown(object sender, ShutdownEventArgs e) { }

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        return Task.CompletedTask;
    }
}

