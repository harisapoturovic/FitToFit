using FitToFit.Services;
using FitToFit.Services.Database;
using Quartz;

namespace FitToFit.CronJob
{
    public class CleanupRezervacijeJob : IJob
    {
        private readonly IRezervacijeService _rezervacijeService;
        private readonly _200048Context _context;

        public CleanupRezervacijeJob(IRezervacijeService rezervacijeService, _200048Context context)
        {
            _rezervacijeService = rezervacijeService;
            _context = context;
        }

        public async Task Execute(IJobExecutionContext context)
        {
            DateTime now = DateTime.UtcNow;
            int rezervacijaId=0;
            var expiredReservations = _context.Rezervacijes
                .Where(r => r.DatumIsteka <= now && r.StateMachine== "active")
                .ToList();

            foreach (var reservation in expiredReservations)
            {
                rezervacijaId = reservation.RezervacijaId;
                await _rezervacijeService.Archive(reservation.RezervacijaId);
            }

            var terminIds = _context.RezervacijaStavkes
                .Where(rs => rs.Rezervacija.RezervacijaId==rezervacijaId)
                .Select(rs => rs.TerminId)
                .Distinct()
                .ToList();

            foreach (var terminId in terminIds)
            {
                var termin = await _context.Terminis.FindAsync(terminId);
                if (termin != null)
                {
                    termin.BrojClanova = (byte)Math.Max(0, (termin.BrojClanova ?? 0) - 1);
                }
            }

            await _context.SaveChangesAsync();
        }
    }
}
