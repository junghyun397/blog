#!/bin/bash

bind_address=`hostname -I | cut -d' ' -f1`

sudo hugo server --bind="$bind_address" --baseURL=http://"$bind_address":1313
