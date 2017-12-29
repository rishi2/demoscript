# demoscript
script to execute all services in different terminal tabs

1. Update PATH for all services from your local machine in to start.sh
2. set `is_build_required` to `false` if no build required.
3. suppose don't want to start any server and just wants to go to specific folder for each service, might to to do git pull, or git stash.In such situation make `can_start_server' to 'false'
4. execute `./start.sh' from terminal.


5. There are 30 sec gap to start some services so, you have to login do gauth within 30 secs once you get gcloud auth page and it will return back to terminal.
6. Once conversation services is up and ngrok URL generated, within 30 secs have to update 'header.ejs' file with conversation's ngrok url in 'retailerwebdemo' services.

7. Once `retailerwebdemo` service is up and ngrok url created,need to whitelist it for both services: `conversation` and `retailerwebdemo`
8. add Webhooks into facebook developer page.
