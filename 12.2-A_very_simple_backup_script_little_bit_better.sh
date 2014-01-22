 #!/bin/bash

    SRCD="/home/"
    TGTD="/var/backups/"
    OF=home-$(date +%Y%m%d).tgz
    tar -cZf $TGTD$OF $SRCD