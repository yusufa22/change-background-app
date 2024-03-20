using System.Runtime.InteropServices;

namespace ChangeBackground
{
    class backgroundChanger
    {
        // Used to set wallpaper
        public const int SPI_SETDESKWALLPAPER = 20;
        public const int SPIF_UPDATEINFILE = 1;
        public const int SPIF_SENDCHANGE = 2;


        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);

        static void Main(String[] args) 
        {
            Random random = new Random();
            var files = Directory.GetFiles($"{args[0]}\\");
            var path = files[random.Next(files.Length)];

            // Set wallpaper
            SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINFILE | SPIF_SENDCHANGE);
        }
    }
}