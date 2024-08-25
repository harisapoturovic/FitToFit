using EasyNetQ;
using FitToFit;
using FitToFit.Auxiliary;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Connections;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHostedService<BackgroundWorkerService>();

// Add services to the container.

builder.Services.AddControllersWithViews();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
//builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
/*
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}*/

//app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseRouting();

app.UseAuthorization();

//app.MapControllers();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();

