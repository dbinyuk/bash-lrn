#!/bin/bash

find / -type f -not -path "*/proc*" -perm -04000 -exec ls -o {} \; 