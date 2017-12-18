# demoscript
script to execute all services in different terminal tabs

1. Update PATH for all services from your local machine in to start.sh
2. set is_build_required to false if no build required.
3. execute `./start.sh' from terminal.


4. There are 30 sec gap to start some services so, you have to login do gauth within 30 secs once you get gcloud auth page and it will return back to terminal.
5. Once conversation services is up and ngrok URL generated, within 30 secs have to update 'header.ejs' file with conversation's ngrok url in 'retailerwebdemo' services.

6. Once `retailerwebdemo` service is up and ngrok url created,need to whitelist it for both services: `conversation` and `retailerwebdemo`
7. add Webhooks into facebook developer page.
