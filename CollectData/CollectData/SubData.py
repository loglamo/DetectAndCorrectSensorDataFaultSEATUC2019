import paho.mqtt.client as paho
import subprocess
from influxdb import InfluxDBClient
import datetime

broker="127.0.0.1"
port=1884


client = paho.Client()
payload = ''
def on_message(client, userdata, message):
       payload = message.payload
       print("Message Recieved: "+message.payload.decode())
       

#client.on_message = on_message
client.connect(broker, port)
#client.subscribe("Sensor/Temp", qos=1)

client.loop_start() #start loop to process received messages
payload = ''
client.on_message = on_message
print(payload)
print("subscribing ")
client.subscribe("Sensor/Temp", qos=1)
dbClient = InfluxDBClient('localhost', 8086, 'root', 'root', 'temperature')
dbClient.switch_database('Temperature_data')
Point = [{
             "measurement": "temperature",
             "tags": {
                   "user":"root"
                    },
             "time": str(datetime.datetime.now()),
             "fields": {
             "temperature": "33"
                    }
                    }
             ]
dbClient = InfluxDBClient('localhost', 8086, 'root', 'root', 'temperature')
dbClient.switch_database('Temperature_data')
recentData = dbClient.query('SELECT temperature FROM temperature ORDER BY time DESC LIMIT 5;')
dbClient.write_points(Point)
print(Point)
client.disconnect() #disconnect
client.loop_stop() #stop loop

