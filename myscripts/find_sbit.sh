#!/bin/bash

sudo find / -perm -1000  ! -path '/proc/*' -exec  ls -ld {} \; -exec stat {} \;
