//using WebApi.Application.Configuration;
using API_CMB.src.API.WebApi.Middleware;
using Domain.DomainInterfaces;
using Domain.RepositoriesInterfaces;
using Infraestructure.Persistence;
using Infraestructure.Repositories;
using Microsoft.Extensions.DependencyInjection;
using WebApi.Application.Mapping;
using WebApi.Application.Services;

var builder = WebApplication.CreateBuilder(args);

AppContext.SetSwitch("Microsoft.AspNetCore.Mvc.ApiExplorer.EnableEnhancedModelMetadata", true);


// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddControllers();
//builder.Services.AddAutoMapper(typeof(Program).mapp);

builder.Services.AddAutoMapper(typeof(MappingProfile));



//Registro de Interfaces
builder.Services.AddScoped<IDapperWrapper, DapperWrapper>();
builder.Services.AddScoped<IArchivoDigitalRepository, ArchivoDigitalRepository>();
builder.Services.AddScoped<ICurrentArchivoDigital, CurrentArchivoDigitalService>();
builder.Services.AddScoped<IArchivoDigitalService, ArchivoDigitalService>();

var app = builder.Build();

app.UseSwagger(c =>
{
    c.RouteTemplate = "swagger/{documentName}/swagger.json";
});

app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Web API CMB");
    c.RoutePrefix = "swagger";
    c.DocumentTitle = "Web API CMB";
});

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

// Agregar middleware de manejo de errores globales
app.UseMiddleware<GlobalExceptionHandlingMiddleware>();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
