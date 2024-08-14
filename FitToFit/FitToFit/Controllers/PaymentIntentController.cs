using FitToFit.Model;
using FitToFit.Model.Requests;
using FitToFit.Model.SearchObjects;
using FitToFit.Services;
using Microsoft.AspNetCore.Mvc;
using Stripe;

namespace FitToFit.Controllers
{
    [ApiController]
    public class PaymentIntentController : ControllerBase
    {

        [HttpPost("[controller]/createPaymentIntent")]
        public async Task<ActionResult<PaymentIntentResponse>> CreatePaymentIntent([FromBody] PaymentIntentRequest request)
        {
            var service = new PaymentIntentService();
            var options = new PaymentIntentCreateOptions
            {
                Amount = request.Amount,
                Currency = "BAM",
            };
            var paymentIntent = await service.CreateAsync(options);
            return new PaymentIntentResponse()
            {
                Id = paymentIntent.Id,
                ClientSecret = paymentIntent.ClientSecret
            };
        }


    }
}