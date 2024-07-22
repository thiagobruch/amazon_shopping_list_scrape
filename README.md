# Amazon Shopping List Scraper
** This project is based on (https://github.com/jtbnz/amazon_shopping_list/) from https://github.com/jtbnz **

The project scrapes the Amazon Shopping List page and add the items to the Home Assistant Shopping List (todo list).
* This is a one way sync only from Amazon List to Home Assistant and it only adds item to Home Assistant. It does not remove items from Home Assistant (even if removed from Amazon Shopping List)

You will need the Amazon Email and Password that you use to Login, the OTP Secret Key and the Home Assistant Webhook URL.
Please find the instructions on how to get the OTP Secret Key and the Home Assistant Webhook URL:

### How to get your OTP App Secret from Amazon <YOUR_OTP_APP_SECRET>:<BR>
### If you don't have 2-step verification enable:<BR>
1 - Login to Amazon https://www.amazon.com/<BR>
2 - Go to Your Account => Login & Security and click on "Turn On" under 2-step verification<BR>
3 - Select the Authentication App<BR>
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)<BR>
5 - Remove the sapces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")<BR>

### If you already have 2-step verification enable:<BR>
1 - Login to Amazon https://www.amazon.com/<BR>
2 - Go to Your Account => Login & Security and click on "Manage" under 2-step verification<BR>
3 - Under Authenticator App, click on Add New App<BR>
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)<BR>
5 - Remove the sapces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")<BR>

### How to get the Home Assistant Webhook URL:<BR>
1 - Go to your Home Assistant interface and go to Settings, Automations & Scenes, Automations<BR>
2 - Click on "+ Create Automation" and select "Create new automation"<BR>
3 - Click on Add Trigger and select Webhook<BR>
4 - Click on the copy symbol on the right to get the URL and save it (example: http://homeassistant.local:8123/api/webhook/-hA_THs-Yr5dfasnnkjfsdfsa)<BR>
5 - Click on Add Action and select If-Then<BR>
6 - Switch the view to YAML (three dots on the right - Edit in YAML)<BR>
7 - Paste the following code:<BR>
```
if:
  - condition: template
    value_template: >-
      {{ trigger.json.name not in state_attr('sensor.shoppinglist_api','list') |
      map(attribute='name') | list }}
then:
  - service: shopping_list.add_item
    data_template:
      name: "{{ trigger.json.name }}"
```
8 - Click on Save

Once you have the information above, you can use two methods:<BR>
1 - Docker Image alredy built<BR>
2 - Create your own Docker Image<BR>

## Docker Image Instructions:
Pull Image(around 800MB):
```
docker pull thiagobruch:amazon-scraper-tb
```
Start Image:
```
docker run -d \
  --name amazon-scraper \
  -e AMZ_LOGIN='<YOUR_AMAZON_EMAIL>' \ # your email address used to login at amazon in this format 'email@email.com' including single quotes.
  -e AMZ_PASS='<YOUR_AMAZON_PASSORD>' \ # your passord used to login at amazon in this format 'mypassword1234' including single quotes.
  -e AMZ_SECRET='<YOUR_OTP_APP_SECRET>' \ # your OTP App Secret in this format 'mypassword1234' including single quotes. More instructions below.
  -e HA_WEBHOOK_URL='<HOME_ASSISTANT_WEBHOOK_URL' \ # your Home Assistant Webhook URL including single quotes. More instructions below.
  thiagobruch:amazon-scrape-tb
```

## Create your Image Instructions:
1 - Save all the file in a single directory
2 - Run the following command:
```
docker build -t amazon-scrape-tb .
```
3 - It will take a while to create the image (around 850MB)
4 - Once it is completed, run the docker run command with the variables to start the container:
```
docker run -d \
  --name amazon-scraper \
  -e AMZ_LOGIN='<YOUR_AMAZON_EMAIL>' \ # your email address used to login at amazon in this format 'email@email.com' including single quotes.
  -e AMZ_PASS='<YOUR_AMAZON_PASSORD>' \ # your passord used to login at amazon in this format 'mypassword1234' including single quotes.
  -e AMZ_SECRET='<YOUR_OTP_APP_SECRET>' \ # your OTP App Secret in this format 'mypassword1234' including single quotes. More instructions below.
  -e HA_WEBHOOK_URL='<HOME_ASSISTANT_WEBHOOK_URL' \ # your Home Assistant Webhook URL including single quotes. More instructions below.
  amazon-scrape-tb
```


