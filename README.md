** This project is based on (https://github.com/jtbnz/amazon_shopping_list/) from https://github.com/jtbnz

The project scrapes the Amazon Shopping List page and add the items to the Home Assistant Shopping List (todo list).
* This is a one way sync only from Amazon List to Home Assistant and it only adds item to Home Assistant. It does not remove items from Home Assistant (even if removed from Amazon Shopping List)


Docker Instructions:
Pull Image(around 800MB):
docker pull thiagobruch:amazon-scraper-tb

Start Image
docker run -d -e AMZ_LOGIN=tbruch@gmail.com -e AMZ_PASS='zh584x*H$re$Mb' -e AMZ_SECRET='IEPFTCWDPC6SBQLBDMRFLAPZAJNZVE6IFCW6F77ZOF25LJO6VNKA' -e HA_WEBHOOK_URL='http://192.168.1.19:8123/api/webhook/-XG05J9oc6KpPq3RQ_k1m2GLs' --name amazon-scrape-tb amazon-scrape-tb


docker run -d \
  --name amazon-scraper \
  -e AMZ_LOGIN='<YOUR_AMAZON_EMAIL>' \ # replace by your email address used to login at amazon in this format 'email@email.com' including single quotes.
  -e AMZ_PASS='<YOUR_AMAZON_PASSORD>' \ # replace by your passord used to login at amazon in this format 'mypassword1234' including single quotes.
  -e AMZ_SECRET='<YOUR_OTP_APP_SECRET>' \ # replace by your OTP App Secret in this format 'mypassword1234' including single quotes. More instructions below.
  -e HA_WEBHOOK_URL='<HOME_ASSISTANT_WEBHOOK_URL' \ # replace by your Home Assistant Webhook URL including single quotes. More instructions below.
  thiagobruch:amazon-scrape-tb

How to get your OTP App Secret from Amazon <YOUR_OTP_APP_SECRET>:
If you don't have 2-step verification enable:
1 - Login to Amazon https://www.amazon.com/
2 - Go to Your Account => Login & Security and click on "Turn On" under 2-step verification
3 - Select the Authentication App
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)
5 - Remove the sapces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")

If you already have 2-step verification enable:
1 - Login to Amazon https://www.amazon.com/
2 - Go to Your Account => Login & Security and click on "Manage" under 2-step verification
3 - Under Authenticator App, click on Add New App
4 - Click on "Can't scan the barcode" and save the Key (13 sets of 4 characters each)
5 - Remove the sapces of the Key (you will have something like this "ASDMASDFMSKDMKSFMKLASDDADABB6JNRNF7WFEHQW23H238R7843")

How to get the Home Assistant Webhook URL:
1 - Go to your Home Assistant interface and go to Settings, Automations & Scenes, Automations
2 - Click on "+ Create Automation" and select "Create new automation"
3 - Click on Add Trigger and select Webhook
4 - Click on the copy symbol on the right to get the URL and save it (example: http://homeassistant.local:8123/api/webhook/-hA_THs-Yr5dfasnnkjfsdfsa)
5 - Click on Add Action and select If-Then
6 - Switch the view to YAML (three dots on the right - Edit in YAML(
7 - Paste the following code:
if:
  - condition: template
    value_template: >-
      {{ trigger.json.name not in state_attr('sensor.shoppinglist_api','list') |
      map(attribute='name') | list }}
then:
  - service: shopping_list.add_item
    data_template:
      name: "{{ trigger.json.name }}"
8 - Click on Save

