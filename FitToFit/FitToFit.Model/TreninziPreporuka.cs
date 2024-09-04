using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FitToFit.Model
{
    public class TreninziPreporuka
    {
        [KeyType(count: 11)]
        public uint TreningId { get; set; }

        [KeyType(count: 11)]
        public uint CoTreningId { get; set; }

        public float Label { get; set; }
    }
}
