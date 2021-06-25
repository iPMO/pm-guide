Necessary Steps to start the first interactive PM Guide

1. fixt postgres permissions
	* execute /home/<user>/fix_postgresql
2. start postgres
   	* sudo -u postgres pg_ctlcluster 13 main status
   	* sudo -u postgres pg_ctlcluster 13 main start
3. start rackup ipmo web
