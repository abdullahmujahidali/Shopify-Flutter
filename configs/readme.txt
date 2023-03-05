- Steps to upgrade FluxStore:
1. Download the latest version of FluxStore from CodeCanyon.
2. Unzip the source code.
3. Copy this configs folder to the unzipped folder.
4. Do all your customization in this configs folder.
- That's it.
- No need to update android/ios folder.
- Do not add empty lines or any special characters in the env.props config file. Just edit the value after the equal sign (=).
- Do not update project info (except Signing & Capabilities) in Xcode project.
- To override with your customized code, copy the customized source code to the configs/customized folder.
- If you have any issues, please create a ticket on our support center: https://support.inspireui.com

========================================================================================================================

# ENV.PROPS CONFIG EXPLANATION BELOW.
# (FOR REFERENCE ONLY. DO NOT COPY TO YOUR ENV.PROPS)

# The Envato purchase code (required). Invalid value can cause app crashing.
# Ref: https://help.market.envato.com/hc/en-us/articles/202822600-Where-Is-My-Purchase-Code
envatoPurchaseCode=put-your-envato-purchase-code-here

# Your app information.
appName=FluxStore
iosBundleId=com.cbii.quickers.flutter
iosBundleIdOneSignal=com.cbii.quickers.flutter.onesignal
iosAppGroups=group.com.cbii.quickers.flutter.onesignal
iosMerchantId=merchant.com.cbii.quickers.flutter
androidPackageName=com.inspireui.fluxstore

# For some native payments, push notification and Dynamic Links features (optional).
websiteUrl=https://inspireui.com
websiteDomain=inspireui.com
customScheme=fluxstore
iosApsEnvironment=development
firebaseDynamicUrl=fluxstoreinspireui.page.link

# Required for Firebase features. Invalid value can cause app crashing. Keep default value if not used.
# Can be taken from REVERSED_CLIENT_ID in GoogleService-Info.plist.
googleReversedClientId=com.googleusercontent.apps.412823237422-pf5dr3f75n6r201u24ocioin54u3cseq

# Used for Google Maps features (optional).
googleApiKeyAndroid=AIzaSyDSNYVC-8DU9BTcyqkeN9c5pgVhwOBAvGg
googleApiKeyIos=AIzaSyDnBpxFOfeG6P06nK97hMg01kEgX48JhLE

# Used for AdMob (optional). Invalid value can cause app crashing. Keep default value if not used.
adMobAppIdAndroid=ca-app-pub-7432665165146018~2664444130
adMobAppIdIos=ca-app-pub-7432665165146018~2664444130

# Used for Facebook Login (optional).
facebookAppId=430258564493822
facebookClientToken=9def0493cb40104fa311ee9e1086d264
facebookLoginProtocolScheme=fb430258564493822

# Android keystore information (old location: android/key.properties).
storePassword=123456
keyPassword=123456
keyAlias=key
storeFile=key.jks
