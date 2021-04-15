-- This information is used by the Wi-Fi dongle to make a wireless connection to the router
-- change ssid and paassword to your wifi details
station_cfg={}
station_cfg.ssid="TELUS1949"
station_cfg.pwd=""
station_cfg.save=true

-- configure ESP as a station
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
wifi.sta.autoconnect(1)
