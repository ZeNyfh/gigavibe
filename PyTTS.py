text = "bruh"
import pyttsx3
ttsObject = pyttsx3.init()
ttsObject.setProperty("voice",ttsObject.getProperty('voices')[0].id)
ttsObject.setProperty("rate",160)
ttsObject.save_to_file(text,"plugins/TTS.mp3")
ttsObject.runAndWait()