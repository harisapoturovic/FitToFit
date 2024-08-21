using FitToFit.Services;
using FitToFit.Services.RezervacijeStateMachine;
using FitToFit.Services.AkcijeStateMachine;
using Microsoft.EntityFrameworkCore;
using FitToFit.Filters;
using FitToFit;
using Microsoft.AspNetCore.Authentication;
using Microsoft.OpenApi.Models;
using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using System.Text.Json;
using AutoMapper;
using FitToFit.Model.Requests;
using Quartz;
using FitToFit.CronJob;
using FitToFit.CronJobs;
using FitToFit.Services.Database;
using _200048Context = FitToFit.Services.Database._200048Context;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IVrsteTreningaService, VrsteTreningaService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<ITreneriService, TreneriService>();
builder.Services.AddTransient<ITreninziService, TreninziService>();
builder.Services.AddTransient<IAkcijeService, AkcijeService>();
builder.Services.AddTransient<ITerminiService, TerminiService>();
builder.Services.AddTransient<ITreninziClanarine, TreninziClanarineService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();
builder.Services.AddTransient<IMessageProducer, MessageProducer>();
builder.Services.AddTransient<IAkcijeTreninziService, AkcijeTreninziService>();
builder.Services.AddTransient<IClanarineService, ClanarineService>();
builder.Services.AddTransient<ISaleService, SaleService>();
builder.Services.AddTransient<IVjezbeService, VjezbeService>();
builder.Services.AddTransient<IVjezbeTreninziService, VjezbeTreninziService>();
builder.Services.AddTransient<IRezervacijaStavkeService, RezervacijaStavkeService>();
builder.Services.AddTransient<IKorisniciNovostiService, KorisniciNovostiService>();
builder.Services.AddTransient<IOcjeneService, OcjeneService>();
builder.Services.AddDbContext<_200048Context>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddTransient<AkcijeBaseState>();
builder.Services.AddTransient<InitialActionState>();
builder.Services.AddTransient<DraftActionState>();
builder.Services.AddTransient<ActiveActionState>();
builder.Services.AddTransient<ArchivedActionState>();

builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<InitialReservationState>();
builder.Services.AddTransient<DraftReservationState>();
builder.Services.AddTransient<ActiveReservationState>();
builder.Services.AddTransient<CanceledReservationState>();
builder.Services.AddTransient<RefusedReservationState>();
builder.Services.AddTransient<ArchivedReservationState>();

object value = builder.Services.AddQuartz(q =>
{
    q.UseMicrosoftDependencyInjectionJobFactory();

    q.ScheduleJob<CleanupRezervacijeJob>(trigger => trigger
        .WithIdentity("cleanupRezervacijeTrigger")
        .StartNow()
        .WithCronSchedule("0 0 * * * ?")); //svaki sat
    //.WithCronSchedule("0 * * * * ?"));  svake minute

    q.ScheduleJob<CleanupNovostiJob>(trigger => trigger
        .WithIdentity("cleanupNovostiTrigger")
        .StartNow()
        .WithCronSchedule("0 0 * * * ?"));
});
builder.Services.AddQuartzHostedService(q => q.WaitForJobsToComplete = true);

// Add services to the container.
builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });
    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<_200048Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();    
app.UseAuthorization();

// Specify the URLs to listen on
app.Urls.Add("http://0.0.0.0:5058");
app.Urls.Add("https://0.0.0.0:7058");

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<_200048Context>();
    context.Database.Migrate();
}

app.Run();
