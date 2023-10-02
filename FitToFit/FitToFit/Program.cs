using FitToFit.Services;
using FitToFit.Services.Database;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddTransient<IKorisniciService, KorisniciService>();
builder.Services.AddTransient<IVrsteTreningaService, VrsteTreningaService>();
builder.Services.AddTransient<INovostiService, NovostiService>();
builder.Services.AddTransient<ITreneriService, TreneriService>();
builder.Services.AddTransient<ITreninziService, TreninziService>();
builder.Services.AddTransient<IAkcijeService, AkcijeService>();
builder.Services.AddTransient<IAdminService, AdminService>();
builder.Services.AddTransient<ITerminiService, TerminiService>();
builder.Services.AddTransient<ITreninziClanarine, TreninziClanarineService>();
builder.Services.AddTransient<IRezervacijeService, RezervacijeService>();

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<Ib200048Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
