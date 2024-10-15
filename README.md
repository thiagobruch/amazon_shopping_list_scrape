# Amazon Shopping List Scraper
** This project is based on (https://github.com/jtbnz/amazon_shopping_list/) by https://github.com/jtbnz **
<br><br>If you want to use as a Home Assistant Addon, use the link below:<br>
https://github.com/thiagobruch/HA_Addons
<br><br>

The project scrapes the Amazon Shopping List page and add the items to the Home Assistant Shopping List (todo list) every 3 minutes (this can be changed in the file script.sh)
* This is a one-way sync only from Amazon List to Home Assistant and it only adds item to Home Assistant. It does not remove items from Home Assistant (even if removed from Amazon Shopping List)

### Important - Do not skip this step<BR>
You will need the Amazon Email and Password that you use to Login, the OTP Secret Key and the Home Assistant Webhook URL.
Please find the instructions on how to get the OTP Secret Key and the Home Assistant Webhook URL:

### How to get your OTP App Secret from Amazon <YOUR_OTP_APP_SECRET>:<BR>
### If you don't have 2-step verification enable:<BR>
1 - Login to Amazon https://www.amazon.com/<BR>
2 - Go to Your Account => Login & Security and click on "Turn On" under 2-step verification<BR>
3 - Select the Authentication App<BR>
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)<BR>
5 - Remove the spaces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")<BR>

### If you already have 2-step verification enable:<BR>
1 - Login to Amazon https://www.amazon.com/<BR>
2 - Go to Your Account => Login & Security and click on "Manage" under 2-step verification<BR>
3 - Under Authenticator App, click on Add New App<BR>
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)<BR>
5 - Remove the spaces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")<BR>

### How to get the Home Assistant Webhook URL:<BR>
1 - Go to your Home Assistant interface and go to Settings, Automations & Scenes, Automations<BR>
2 - Click on "+ Create Automation" and select "Create new automation"<BR>
3 - Click on Add Trigger and select Webhook<BR>
4 - Click on the copy symbol on the right to get the URL and save it (example: http://homeassistant.local:8123/api/webhook/-hA_THs-Yr5dfasnnkjfsdfsa)<BR>
You'll have to use the internal URL<br>
5 - Switch the view to YAML (three dots on the top right - Edit in YAML)<BR>
6 - Delete the line "action: []" and aste the following code:<BR>
* If you only mark the items as completed and want them added again, remove the line " - completed"<BR>
* Replace the entity "todo.shopping_list" with the entity in your environment.
```
action:
  - action: todo.get_items
    data:
      status:
        - needs_action
        - completed
    response_variable: todo
    target:
      entity_id: todo.shopping_list
  - if:
      - condition: template
        value_template: |-
          {{trigger.json.name not in todo['todo.shopping_list']['items'] |
                    map(attribute='summary') | list}}
    then:
      - data_template:
          item: "{{ trigger.json.name }}"
        target:
          entity_id: todo.shopping_list
        action: todo.add_item
mode: parallel
max: 100
```
7 - Click on Save and give a name to the Automation<BR>

Once you have the information above, you can use two methods:<BR>
1 - Docker Image already built<BR>
2 - Create your own Docker Image<BR>

## Docker Image Instructions:
Pull Image(around 800MB):
```
docker pull thiagobruch/amazon-scrape-tb
```
Start Image:
```
docker run -d \
  --name amazon-scraper \
  -e AMZ_LOGIN='<YOUR_AMAZON_EMAIL>' \ # your email address used to login at amazon in this format 'email@email.com' including single quotes.
  -e AMZ_PASS='<YOUR_AMAZON_PASSORD>' \ # your password used to login at amazon in this format 'mypassword1234' including single quotes.
  -e AMZ_SECRET='<YOUR_OTP_APP_SECRET>' \ # your OTP App Secret in this format 'mypassword1234' including single quotes. More instructions above.
  -e HA_WEBHOOK_URL='<HOME_ASSISTANT_WEBHOOK_URL' \ # your Home Assistant Webhook URL including single quotes. More instructions above.
  -e Amazon_Sign_in_URL='<Amazon_SIGNIN_URL>' \ # The Sign-In Page for your amazon Account. More instructions on the address below
  -e Amazon_Shopping_List_Page='<Amazon_SHOPPING_LIST_URL>' \ # The Shopping list Page for your amazon Account. More instructions on the address below
  -e polling_interval='180' \ # The pooling interval in seconds. We recommend using 180 seconds or more.
  -e delete_after_download=true \ # When set to true, the items will be delete from Amazon Shopping list once they are added to HA.
  thiagobruch/amazon-scrape-tb
```

## Create your Image Instructions:
1 - Save all the file in a single directory<BR>
2 - Run the following command:
```
docker build -t amazon-scrape-tb .
```
3 - It will take a while to create the image (around 850MB)<BR>
4 - Once it is completed, run the docker run command with the variables to start the container:
```
docker run -d \
  --name amazon-scraper \
  -e AMZ_LOGIN='<YOUR_AMAZON_EMAIL>' \ # your email address used to login at amazon in this format 'email@email.com' including single quotes.
  -e AMZ_PASS='<YOUR_AMAZON_PASSORD>' \ # your password used to login at amazon in this format 'mypassword1234' including single quotes.
  -e AMZ_SECRET='<YOUR_OTP_APP_SECRET>' \ # your OTP App Secret in this format 'mypassword1234' including single quotes. More instructions below.
  -e HA_WEBHOOK_URL='<HOME_ASSISTANT_WEBHOOK_URL' \ # your Home Assistant Webhook URL including single quotes. More instructions below.
  -e Amazon_Sign_in_URL='<Amazon_SIGNIN_URL>' \ # The Sign-In Page for your amazon Account. More instructions on the address below
  -e Amazon_Shopping_List_Page='<Amazon_SHOPPING_LIST_URL>' \ # The Shopping list Page for your amazon Account. More instructions on the address below
  -e polling_interval='180' \ # The pooling interval in seconds. We recommend using 180 seconds or more.
  -e delete_after_download=true \ # When set to true, the items will be delete from Amazon Shopping list once they are added to HA.
  amazon-scrape-tb
```

### * If you are not in the US and use Amazon in a different country, change the URLs below:
* Amazon_Sign_in_URL: Amazon URL to sign. You'll need to find the URL for your country:
```
e.g. United States: 
"https://www.amazon.com/ap/signin?openid.pape.max_auth_age=3600&openid.return_to=https%3A%2F%2Fwww.amazon.com%2Falexaquantum%2Fsp%2FalexaShoppingList%3Fref_%3Dlist_d_wl_ys_list_1&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=amzn_alexa_quantum_us&openid.mode=checkid_setup&language=en_US&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
e.g. Italy:
"https://www.amazon.it/ap/signin?openid.pape.max_auth_age=0&openid.return_to=https%3A%2F%2Fwww.amazon.it%2Fref%3Dnav_signin&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=itflex&openid.mode=checkid_setup&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
e.g. Germany:
"https://www.amazon.de/ap/signin?openid.pape.max_auth_age=3600&openid.return_to=https%3A%2F%2Fwww.amazon.de%2Falexaquantum%2Fsp%2FalexaShoppingList%3Fref_%3Dlist_d_wl_ys_list_1&openid.identity=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.assoc_handle=amzn_alexa_quantum_de&openid.mode=checkid_setup&language=de_DE&openid.claimed_id=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0%2Fidentifier_select&openid.ns=http%3A%2F%2Fspecs.openid.net%2Fauth%2F2.0"
```
* Amazon_Shopping_List_Page:
```
e.g. United States:
"https://www.amazon.com/alexaquantum/sp/alexaShoppingList?ref_=list_d_wl_ys_list_1"
e.g. Italy:
"https://www.amazon.it/alexaquantum/sp/alexaShoppingList?ref_=list_d_wl_ys_list_1"
e.g. Germany:
"https://www.amazon.de/alexaquantum/sp/alexaShoppingList?ref_=list_d_wl_ys_list_1"
```
## * Enable Debug Mode
Add the following to the "docker run" command:
```
-e debug_log=true -p 8888:8888
```


## * Extra - Clear Alexa Shopping List
Because this is a one way sync (from Amazon Shopping List to Home Assistant), I have an automation that clear Amazon Shopping list every night at midnight.
Here is the Automation in YAML:

```
description: ""
mode: single
trigger:
  - platform: time
    at: "00:00:00"
condition: []
action:
  - service: media_player.volume_set
    data:
      volume_level: 0.01
    target:
      entity_id: media_player.my_alexa
  - delay:
      hours: 0
      minutes: 0
      seconds: 3
      milliseconds: 0
  - service: media_player.play_media
    data:
      media_content_type: custom
      media_content_id: "clear my shopping list"
      enqueue: play
    target:
      entity_id: media_player.my_alexa
    enabled: true
  - delay:
      hours: 0
      minutes: 0
      seconds: 3
      milliseconds: 0
    enabled: true
  - service: media_player.play_media
    data:
      media_content_type: custom
      media_content_id: "yes"
      enqueue: play
    target:
      entity_id: media_player.my_alexa
    enabled: true
