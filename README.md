Introduction for application:

-I use record package to operate with microphone of the device and take value of sound so for each 10 second

-I store valueom of sound each 50 millisecond and in the tenth second

-I calculate average this in first part of code which operate with microphone and in part two I have average of sound Noice each 10 second

I display this value in two shape first shape as small circle progress and second shape as a line progress .

Record package:

-This package allow to operate with microphone of android and iOS and mac and window but not allow to operate with and web browser.

CircularProgressWithValue

function in Flutter is a custom widget that displays a circular progress indicator with a specific value. It extends the StatefulWidget class, indicating that it has mutable state that can change over time. And take value from 0 to 1. Accurecy:

The accuracy of the audio recording depends on various factors, including the capabilities of the recording hardware, the quality of the microphone, and the implementation of the recording functionality in the "record" package and in implementation in the code I don’t store the voice but just get value of sound each 1 second but this way will decrease the accuracy because if I speak and finished before the microphone take the value all this sound will not calculate. and I can fix this by Make the microphone take the value in a very small period but this way will consume more power.

Disadvanteges:

When sound noice become more than 70db the red flag will happen but it take 1 second to change color .
