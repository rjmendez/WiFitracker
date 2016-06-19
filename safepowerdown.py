import RPi.GPIO as GPIO
import time
import os
GPIO.setmode(GPIO.BCM)
GPIO.setup(4, GPIO.IN )
prev_input = 0
while True:
  input = GPIO.input(4)
  if ((not prev_input) and input):
    os.system("shutdown -h now")
  prev_input = input
  time.sleep(0.1)
