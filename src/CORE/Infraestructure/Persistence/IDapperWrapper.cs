using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infraestructure.Persistence
{
    public interface IDapperWrapper
    {
        Task<IEnumerable<T>> QueryAsync<T>(string storedProcedure, object? parameters = null);
        Task<T?> QueryFirstOrDefaultAsync<T>(string storedProcedure, object? parameters = null);
        Task<(IEnumerable<T1> first, IEnumerable<T2> second)> QueryMultipleAsync<T1, T2>(string storedProcedure, object? parameters = null);
        Task<int> ExecuteAsync(string storedProcedure, object? parameters = null);
        Task<T> ExecuteScalarAsync<T>(string storedProcedure, object? parameters = null);
        Task<T> ExecuteInTransactionAsync<T>(Func<IDbTransaction, Task<T>> operation);
        Task ExecuteInTransactionAsync(Func<IDbTransaction, Task> operation);
        Task<IDbConnection> GetConnectionAsync();
    }
}
