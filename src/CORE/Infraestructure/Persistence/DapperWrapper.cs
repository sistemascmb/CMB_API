using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace Infraestructure.Persistence
{
    public class DapperWrapper : IDapperWrapper
    {
        private readonly IConfiguration configuration;
        private readonly string connectionStringKey;

        public DapperWrapper(IConfiguration configuration, string connectionStringKey = "ConnectionStrings:DefaultConnection")
        {
            this.configuration = configuration;
            this.connectionStringKey = connectionStringKey;
        }

        public async Task<IEnumerable<T>> QueryAsync<T>(string storedProcedure, object? parameters = null)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            return await connection.QueryAsync<T>(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
        }

        public async Task<T?> QueryFirstOrDefaultAsync<T>(string storedProcedure, object? parameters = null)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            return await connection.QueryFirstOrDefaultAsync<T>(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
        }

        public async Task<(IEnumerable<T1> first, IEnumerable<T2> second)> QueryMultipleAsync<T1, T2>(string storedProcedure, object? parameters = null)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            using SqlMapper.GridReader gridReader = await connection.QueryMultipleAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
            IEnumerable<T1> first = await gridReader.ReadAsync<T1>();
            IEnumerable<T2> second = await gridReader.ReadAsync<T2>();
            return (first, second);
        }

        public async Task<int> ExecuteAsync(string storedProcedure, object? parameters = null)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            return await connection.ExecuteAsync(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
        }

        public async Task<T> ExecuteScalarAsync<T>(string storedProcedure, object? parameters = null)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            return await connection.ExecuteScalarAsync<T>(storedProcedure, parameters, commandType: CommandType.StoredProcedure);
        }

        public async Task<T> ExecuteInTransactionAsync<T>(Func<IDbTransaction, Task<T>> operation)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            using IDbTransaction transaction = connection.BeginTransaction();
            try
            {
                T result = await operation(transaction);
                transaction.Commit();
                return result;
            }
            catch
            {
                transaction.Rollback();
                throw;
            }
        }

        public async Task ExecuteInTransactionAsync(Func<IDbTransaction, Task> operation)
        {
            using SqlConnection connection = await GetSqlConnectionAsync();
            using IDbTransaction transaction = connection.BeginTransaction();
            try
            {
                await operation(transaction);
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
                throw;
            }
        }

        public async Task<IDbConnection> GetConnectionAsync()
        {
            return await GetSqlConnectionAsync();
        }

        private async Task<SqlConnection> GetSqlConnectionAsync()
        {
            string connectionString = GetConnectionString();
            SqlConnection connection = new SqlConnection(connectionString);
            await connection.OpenAsync();
            return connection;
        }

        private string GetConnectionString()
        {
            string connectionString = configuration[connectionStringKey] ?? string.Empty;
            if (string.IsNullOrEmpty(connectionString))
            {
                throw new InvalidOperationException($"Connection string '{connectionStringKey}' not found or is empty");
            }
            return connectionString;
        }
    }
}
