namespace FitToFit.Model
{
    public partial class Treninzi
    {
        public int TreningID { get; set; }
        public string Naziv { get; set; }
        public string Opis { get; set; }
        public int MaxBrojClanova { get; set; }
        public int CijenaPoTerminu { get; set; }
        public int Trajanje { get; set; }
        public int ProsjecnaPotrosnjaKalorija { get; set; }
        public string Namjena { get; set; }
        public byte[] Slika { get; set; }
        public int VrstaID { get; set; }
    }
}