#!/bin/bash

docker run --rm bluet/proxybroker2 find --types HTTP HTTPS --countries US --strict -l 10