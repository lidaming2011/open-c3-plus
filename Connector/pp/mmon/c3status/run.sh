#!/bin/bash

date

/data/Software/mydan/Connector/pp/mmon/c3status/run > /data/Software/mydan/Connector/local/c3status.txt.temp && mv /data/Software/mydan/Connector/local/c3status.txt.temp /data/Software/mydan/Connector/local/c3status.txt
