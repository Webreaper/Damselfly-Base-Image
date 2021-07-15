using System;
using Emgu.CV;
using Emgu.CV.Structure;
using Emgu.Util;
using System.Drawing;
using System.Runtime.InteropServices;
using Emgu.CV.CvEnum;

namespace EmguCVSample
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Starting....");

            try
            {
                string path = "./Oscars.jpeg";
                var img = CvInvoke.Imread(path);

                Console.WriteLine("Initialising face detector....");
                var faceDetector = new CascadeClassifier("haarcascade_frontalface_default.xml");

                Console.WriteLine("Initialising grayscale image....");
                Mat imgGray = null;
                CvInvoke.CvtColor(img, imgGray, Emgu.CV.CvEnum.ColorConversion.Bgr2Gray);

                Console.WriteLine("Detecting faces....");
                var faces = faceDetector.DetectMultiScale(imgGray, 1.1, 10, new Size(20, 20), Size.Empty);

                Console.WriteLine($"Processing {faces.Length} faces...");

                foreach (var face in faces)
                {
                    CvInvoke.Rectangle(img, face, new MCvScalar(255, 255, 255));
                    Console.WriteLine($"Found face: {face.Left} {face.Top} {face.Width} {face.Height}");
                }

                Console.WriteLine("Processing complete.");
            }
            catch ( Exception ex )
            {
                Console.WriteLine($"Exception: {ex}");
            }
        }
    }
}
