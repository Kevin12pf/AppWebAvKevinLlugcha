using System;

namespace WebAppPoliMusicV2.Entities
{
    /// <summary>
    /// Entidad que representa una canción del catálogo.
    /// </summary>
    public class Song
    {
        public Song()
        {
        }

        public Song(int id, string name, string path, int plays, string artistName)
        {
            ID = id;
            Name = name;
            Path = path;
            Plays = plays;
            ArtistName = artistName;
        }

        public int ID { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
        public int Plays { get; set; }
        public string ArtistName { get; set; }
    }
}
