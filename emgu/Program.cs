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
        private class FaceResult
        {
            public Rectangle Rect { get; set; }
            public string Image { get; set; }
            public string Cascade { get; set; }
        }

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

                    List<FaceResult> rects = new List<FaceResult>();

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
                                var results = detector.Value.DetectMultiScale(imgGray, 1.2, 10, new Size(20, 20), Size.Empty);

                                foreach (var face in results)
                                {
                                    rects.Add( new FaceResult {
                                        Rect = face,
                                        Image = Path.GetFileName(path),
                                        Cascade = detector.Key
                                    } );
                                }
                            }

                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine($"Exception while processing {path}: {ex}");
                        }
                    }

                    foreach (var face in rects.OrderBy( x => x.Image ) )
                    {
                        Console.WriteLine($"Found face in {face.Image}: {face.Rect.Left}, {face.Rect.Top}, {face.Rect.Width}, {face.Rect.Height} [{face.Cascade}]");
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
