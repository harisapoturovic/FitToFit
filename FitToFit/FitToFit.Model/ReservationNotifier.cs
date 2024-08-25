using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class ReservationNotifier
    {
        public ReservationNotifier()
        {
        }
        public string Email { get; set; }
        public string Subject { get; set; }
        public string Content { get; set; }
    }
}
