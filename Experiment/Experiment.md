# Cài đặt hệ thống thu thập dữ liệu Sensor
### Đây là hệ thống được cài đặt trên Pi, với nhiệm vụ là thu thập dữ liệu như nhiệt độ, ánh sáng, độ ẩm, và được luư trữ tại cơ sở dữ liệu Time-series.
Sơ đồ hệ thống:

![sơ đồ ht](https://i.imgur.com/EpWVts9.png)

## Các thành phần phần cứng 
     - Raspberrypi
     - Senso
     - Dây nối
     ...
    
[Hướng dẫn kết nối DHT11 với Pi]("https://tutorials-raspberrypi.com/raspberry-pi-measure-humidity-temperature-dht11-dht22/")

Dưới đây là mô hình tham khảo:
![hinh1](https://i.imgur.com/75Ye1PR.jpg)
 
Chú ý cài đặt thư viện trước khi chạy chương trình với DHT11. 

## Các thành phần phần mềm gồm:
     - mosquitto: Broker (Message Oriented Middleware )
     - Publish, Subscribe lần lượt làm nhiệm vụ nhận dữ liệu từ sensor thu thập được đẩy đến 1 topic trong mosquitto, Subscribe liên tục nghe (Hứng) tại topic này rồi đẩy dữ liệu tới Database
     - Time-series database: Influxdb, một CSDL phù hợp cho lưu trữ dữ liệu dạng chuỗi thời gian

Hướng dẫn cài đặt các thành phần trên:

1. mosquitto
[Hướng dẫn cài đặt Mosquitto](https://randomnerdtutorials.com/how-to-install-mosquitto-broker-on-raspberry-pi/)

Chú ý: Sau khi enable ứng dụng, sử dụng câu lệnh:

      mosquitto -p 1884 // để thiết lập cổng cho ứng dụng 

2. Tạo các Clients

Cài đặt thư viện paho-mqtt, để tạo các client. 

[Cài đặt paho-mqtt](https://pypi.org/project/paho-mqtt/)

Tạo các client Publish và Subscribe tương tự [hướng dẫn cơ bản paho](http://www.steves-internet-guide.com/into-mqtt-python-client/).

    python SubData // nhận dữ liệu từ topic 
    python CollectData.py // thực thi lấy dữ liệu và gửi tới Broker

Publish sẽ nhận dữ liệu từ sensor, liên tục đẩy dữ liệu theo chu kì tới Topic tại Broker. Subscribe nhận dữ liệu và liên tục đẩy về Database. 

## 3. Cài đặt Influxdb 
Hướng dẫn có tại [Cài đặt Influxdb](http://blog.centurio.net/2018/10/28/howto-install-influxdb-and-grafana-on-a-raspberry-pi-3/), bỏ phần cài đặt Grafana. 
Tại cmd:
    
    >influx    //để vào influxdb
    >CREATE DATABASE [tên database]

Một số câu lệnh cơ bản khác có tại [Đây](https://docs.influxdata.com/influxdb/v1.7/introduction/getting-started/)
