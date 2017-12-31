# bash-otp-gen
This tool allow you to manage OTP codes in shell. It is an alternative to Google Authenticator an similar apps.  
It works using jq (to parse json configuration file) and oathtool (one-time password tool)  
Just run it with the example file to check how it works. To use it with your codes, when you are asked to scan a QR code for your security device, look for the detailed view (usually a little arrow) in the website you are using, and copy/paste the generator string in the json configuration file.  
You can place the json configuration file anywhere, just reference it at the start of the script
