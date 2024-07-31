using FitToFit.Database;
using Quartz;

namespace FitToFit.CronJobs
{
    public class CleanupNovostiJob : IJob
    {
        private readonly Ib200048Context _context;

        public CleanupNovostiJob(Ib200048Context context)
        {
            _context = context;
        }

        public async Task Execute(IJobExecutionContext context)
        {
            DateTime oneMonthAgo = DateTime.UtcNow.AddMonths(-1);

            var oldNovosti = _context.Novostis
                .Where(n => n.DatumObjave <= oneMonthAgo)
                .ToList();

            foreach (var novost in oldNovosti)
            {
                var relatedEntries = _context.KorisniciNovostis
                    .Where(kn => kn.NovostId == novost.NovostId)
                    .ToList();

                _context.KorisniciNovostis.RemoveRange(relatedEntries);
                _context.Novostis.Remove(novost);
            }
            await _context.SaveChangesAsync();
        }
    }
}
