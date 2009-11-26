using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace HelloSTD
{
    class Program
    {
        static void Main(string[] args)
        {
            TextReader tIn = Console.In;
            TextWriter tOut = Console.Out;

            tOut.Write("Hello World!");
        }
    }
}

/*
    using (Stream stdin = Console.OpenStandardInput())
    using (Stream stdout = Console.OpenStandardOutput())
    {
        byte[] buffer = new byte[2048];
        int bytes;
        while ((bytes = stdin.Read(buffer, 0, buffer.Length)) > 0) {
            stdout.Write(buffer, 0, bytes);
        }
    }
*/

/*
static class Program
{
    static int Main(string[] args)
    {
        // Maybe do some validation here
        string imgPath = args[0];

        // Create Method GetBinaryData to return the Image object you're looking for based on the path.
        Image img = GetBinaryData(imgPath);
        ShowImage(img);
    }
}
*/