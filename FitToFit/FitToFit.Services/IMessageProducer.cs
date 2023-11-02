using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Services
{
    public interface IMessageProducer
    {
        public void SendingMessage(string message);
        public void SendingObject<T>(T obj);
    }
}
