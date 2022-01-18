---
title: 'Interfacing with an Espruino from c#'
author: ben-wendt
layout: post
template: article.pug
date: 2014-02-07
url: /2014/02/07/interfacing-with-an-espruino-from-c/
categories:
  - 'c#'
  - Javascript
tags:
  - espruino
---
Communication with an Espruino is done by sending JavaScript in string format over a serial port interface. This can be done in c# using the [`System.IO.Ports.SerialPort`](http://msdn.microsoft.com/en-us/library/system.io.ports.serialport%28v=vs.110%29.aspx) class. You can see the default serial port connection settings for [interfacing on the Espruino site][1].

<span class="more"></span>

The following code will check [abevigoda.com][2] to see if [Abe Vigoda][3] is still alive. If he is still alive, a blue light will turn on. If he has passed away, a red light will display.

<pre class="brush: csharp; title: ; notranslate" title="">using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO.Ports;
using System.IO;
using System.Net;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            WebClient client = new WebClient();

            Stream Abe = client.OpenRead("http://www.abevigoda.com/");
            StreamReader reader = new StreamReader(Abe);
            string HTML = reader.ReadToEnd();

            int LEDNumber;
            if (HTML.Contains("alive"))
            {
                LEDNumber = 3;
            }
            else
            {
                LEDNumber = 1;
            }

            SerialPort port = new SerialPort(
                "COM4",
                9600,
                Parity.None,
                8,
                StopBits.One
            );

            port.Open();
            port.Write("digitalWrite(LED" + LEDNumber + ", 1);n");
            port.Close();

        }
    }
}

</pre>

Here&#8217;s the current results:

![espruino with blue light][4]

 [1]: http://www.espruino.com/Interfacing
 [2]: http://www.abevigoda.com/
 [3]: http://en.wikipedia.org/wiki/Abe_Vigoda
 [4]: http://www.benwendt.ca/images/IMG_20140207_141030.jpg
