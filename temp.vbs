Const SAFT48kHz16BitStereo = 39
Const SSFMCreateForWrite = 3 ' Creates file even if file exists and so destroys or overwrites the existing file

Dim oFileStream, oVoice

Set oFileStream = CreateObject("SAPI.SpFileStream")
oFileStream.Format.Type = SAFT48kHz16BitStereo
oFileStream.Open "C:\Users\david\Desktop\code_stuff\discordbot\plugins\Sample.wav", SSFMCreateForWrite

Set oVoice = CreateObject("SAPI.SpVoice")
Set oVoice.AudioOutputStream = oFileStream

oVoice.Speak "ZeNyfh says, hijudsfihjfdsihjdsfihjfdsuihfdsiuhdfsuihfdsiuh"

oFileStream.Close
