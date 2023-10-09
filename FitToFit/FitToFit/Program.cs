using FitToFit.Services;
using FitToFit.Services.Database;
using FitToFit.Services.RezervacijeStateMachine;
using FitToFit.Services.AkcijeStateMachine;
using Microsoft.EntityFrameworkCore;
using FitToFit.Filters;
using FitToFit;
using Microsoft.AspNetCore.Authentication;
using Microsoft.OpenApi.Models;

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

// Add services to the container.

builder.Services.AddControllers();

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
builder.Services.AddDbContext<Ib200048Context>(options =>
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

app.MapControllers();

app.Run();
