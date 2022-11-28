---
title: 'Ardupilot Postmortem'
url: '/post/ardupilot-postmortem'
type: post
author: scottyob
date: 2022-11-27
tags:
 - rc
 - ardupilot
image: /post/ardupilot-postmortem/crash.jpg

---

***NOTE:  This post is expected to be edited once I have more opinions from the community and get closer to a concrete conclusion of what happened.***

So I took Monday-Wednesday off. Figured a 9 day weekend would give me a nice break. 

I spent a lot of time finishing an RC plane we had some replacement parts for. This one was going to be autonomous. I spent a few days soldering the flight controller and electronics, gluing the plane together, measuring and trimming everything perfectly. It was perfectly balanced, perfectly weighted. We finally took it out for a maiden flight today, Sunday November 27.  Sadly, this story ends in pieces.

This post is to try and perform a postmortem of the incident to piece together what happened.  I was flying using Ardupilot and had an SD card in recording the data, so, hopefully the "black box" telemetry data be able to figure out what went wrong here.

### Plane Hardware
* **Plane**: [Bixler 3](https://hobbyking.com/en_us/h-king-bixler-3-glider-1550-pnf.html)
* **Flight Controller**: [Holybro Kakute F7](https://ardupilot.org/copter/docs/common-holybro-kakutef7aio.html)
* **GPS, Compass**: [Beitian BN-880](https://ardupilot.org/copter/docs/common-beitian-gps.html)
* **Ardupilot**: Arduplane V4.3.1

### Tools & Files
* [UAV Logviewer](https://ardupilot.org/dev/docs/common-uavlogviewer.html)
* Ardupilot **[LOG FILE](/post/ardupilot-postmortem/log.bin)**

### Theories & Investigation

The flight controller has a BMP280 barometer for quick height sensing and a ICM20689 IMU for acceleration and gyro.  These, coupled with a slower GPS update time should give me fairly accurate height and position updates.  The plane acted erratic twice in the short two-minute flight.  I have pieced together the events and suspect two failures during this flights short duration.  The following is a timeline view of the events of the flight and findings at that time.

### Events

#### 1 Bad Altitude Readings Pre-Launch
The first thing to note, is that the Altitude readings are bogus.  I seem to be getting more realistic readings from the GPS.  Going forward, any screenshots will be from the GPS altitude.

<video width="100%" loop="true" controls autoplay muted>
    <source src="/post/ardupilot-postmortem/altitude.mp4" />
</video>

![altitude](/post/ardupilot-postmortem/Altitude.jpg)

The altitude readings are super interesting here.  You can tell even before I launch the plane, the GPS altitude readings are between -13m and 0m.  Not sure what this altitude is (above sea?  Above launch??)

More concerning, the Barometer altitude is between -10 and -70m in the ~1 minute before launch on the ground.  The calculated AHRS (Attitude Heading Reference System) altitude at somewhat similar, -9 and -80  🫤

The maiden launch itself in manual mode however was nominal.  You can hear me saying "Good luck little plane".  It needed more than luck it seems
<iframe width="560" height="315" src="https://www.youtube.com/embed/D03_c0LWJhM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

#### 2. Fly-By-Wire Test

At ~1 minute 22 seconds into the flight, I turned the flight mode from manual to [Fly by wire A](https://ardupilot.org/plane/docs/fbwa-mode.html), which should have had the effect of assisting the plane in straight line.  Looking at the radio stick input, I did not change the heading, but the autopilot sent this into a steep dive at this time.  A near miss where we avoided a crash here.

![FBW](/post/ardupilot-postmortem/fbw.jpg)

#### Theory 1 Reversed Elevator?
![nosedive](/post/ardupilot-postmortem/Nosedive1.jpg)
12:24 is interesting here, If we take the time we engage the autopilot, we can see the pitch heading down into the ground, before our roll even begins to change.  It ends up to a point where it's almost completely nose down before we save it with manual flight mode.

What's interesting, is that the pitch continues to fall, and the AETR Elevator gets more and more positive.  Is it possible that we're trying to correct the nose down and instead making it worse?  Could the elevator be reversed?


### Event 3.  Crash (elevator failure?)

This event makes me believe that I had an elevator failure during the flight, and, in a panic I "checked" my autopilot settings, and accidentally turned it on.

**Events:**
* Nominal flight approaching turn
* Banks left to enter turn
* Starts pitching down, control toggles are pulling back on the elevator, manual flight mode still engaged
* Plane is not responsive and is still pitching down
* After loosing much altitude, in a panic, RTL is engaged.
* Plane starts pitching nose down further once RTL is engaged (reversed elevator theory?) causing the epic crash with almost full speed, full nose down.

<video width="100%" controls autoplay muted>
    <source src="/post/ardupilot-postmortem/crash.mp4" />
</video>





### Lessons
* Don't fly with so much throttle.  Mistakes happen a *lot* faster than it could otherwise happen
* Test the FBWA modes on the ground.  Ensure that the elevator, ailerons and rudder is behaving as expected in relationship to pitch, roll movements.
* Be sure to glue in everything!  I'm not convinced a servo could have come loose during this flight, though unlikely considering it to be the elevator that's unresponsive.  Perhaps elevator could have been "stuck" or something?  Loose screw on the servo?  Who knows.
* When packing up a catastrophic crash, take stock of failed components, what servo is for what.  Re-create postmortem to analyze suspect failed components.



