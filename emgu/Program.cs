using System;
using Emgu.CV;
using System.Linq;
using System.Drawing;
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

                    var haarcascades = Directory.GetFiles(".", "haarcascade*.xml");
                    var classifiers = haarcascades.ToDictionary(xml => xml, x => {
                        Console.WriteLine($"Initialising face detector with {x}...");
                        return new CascadeClassifier(x);
                    });

                    List<KeyValuePair<Rectangle, string>> rects = new List<KeyValuePair<Rectangle, string>>();

                    foreach (var path in images)
                    {
                        Console.WriteLine($"Looking for faces in {path}...");

                        try
                        {
                            var img = CvInvoke.Imread(path);
                            var imgGray = new UMat();
                            CvInvoke.CvtColor(img, imgGray, ColorConversion.Bgr2Gray);
                            foreach (var detector in classifiers)
                            {
                                Console.WriteLine($"Detecting with {detector.Key}");
                                var results = detector.Value.DetectMultiScale(imgGray, 1.2, 10, new Size(20, 20), Size.Empty);

                                foreach (var face in results)
                                {
                                    rects.Add(new KeyValuePair<Rectangle, string>(face, detector.Key) );
                                }
                            }

                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Exception while processing {path}: {ex}");
                        }
                    }

                    foreach (var face in rects )
                    {
                        Console.WriteLine($" Found face: {face.Key.Left}, {face.Key.Top}, {face.Key.Width}, {face.Key.Height} [{face.Value}]");
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
