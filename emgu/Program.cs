using System;
using Emgu.CV;
using Emgu.CV.Structure;
using Emgu.Util;
using System.Drawing;
using System.Runtime.InteropServices;
using Emgu.CV.CvEnum;
using System.IO;
using System.Collections.Generic;

namespace EmguCVSample
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (args.Length != 1)
                {
                    Console.WriteLine("Pass a file or folder to scan for faces.");
                    return;
                }
                else
                {
                    var images = new List<string>();

                    if( Directory.Exists( args[0] ) )
                    {
                        var files = Directory.GetFiles(args[0]);
                        images.AddRange( files );
                    }
                    else if( File.Exists( args[0] ))
                    {
                        images.Add(args[0]);
                    }
                    else
                    {
                        Console.WriteLine($"No such file or directory: {args[0]}");
                        return;
                    }

                    Console.WriteLine("Initialising face detector....");
                    var faceDetector = new CascadeClassifier("haarcascade_frontalface_default.xml");

                    foreach (var path in images)
                    {
                        Console.WriteLine($"Looking for faces in {path}...");

                        try
                        {
                            var img = CvInvoke.Imread(path);
                            var imgGray = new UMat();
                            CvInvoke.CvtColor(img, imgGray, ColorConversion.Bgr2Gray);

                            var faces = faceDetector.DetectMultiScale(imgGray, 1.2, 10, new Size(20, 20), Size.Empty);

                            foreach (var face in faces)
                            {
                                Console.WriteLine($" Found face: {face.Left}, {face.Top}, {face.Width}, {face.Height}");
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Exception while processing {path}: {ex}");
                        }

                    }

                    Console.WriteLine("Complete - all images processed.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception: {ex}");
            }
        }
    }
}
