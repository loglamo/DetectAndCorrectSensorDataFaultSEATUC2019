import Adafruit_DHT
import sys
from time import sleep

import paho.mqtt.client as paho
broker="127.0.0.1"
port=1884
def on_publish(client,userdata,result):             #create function for callback
    print("data published \n")
    pass
client = paho.Client("instance1")
client.connect(broker,port)
 
# Set sensor type : Options are DHT11,DHT22 or AM2302
sensor=Adafruit_DHT.DHT11
 
# Set GPIO sensor is connected to
gpio=17
 
# Use read_retry method. This will retry up to 15 times to
# get a sensor reading (waiting 2 seconds between each retry).

while True:
  humidity, temperature = Adafruit_DHT.read_retry(sensor, gpio)
 
# Reading the DHT11 is very sensitive to timings and occasionally
# the Pi might fail to get a valid reading. So check if readings are valid.
  if humidity is not None and temperature is not None:
   print('Temp={0:0.1f}*C  Humidity={1:0.1f}%'.format(temperature, humidity))
  else:
   print('Failed to get reading. Try again!')
  client.on_publish = on_publish    
  ret= client.publish("Sensor/Temp",temperature)  
  sleep(10)