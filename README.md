#Branchster - Take Home Exercise for Solutions Engineer Position

Hi! I would like to walk you through the steps on how to setup your Branch Dashboard and then how to integrate it into your project. While we have plenty of documentation available, I will try to make this as seamless as possible to get you setup in a simple and timely manner.

Today we will be working with a Branch Monster Factory starter project written in Objective-C. Before we get started, let’s get you setup with your Branch Dashboard. 

Dashboard Setup:

For starters, the first thing you’ll want to do is setup basic integration - create a Branch account at Branch.io if you don’t already have one. Once you’re all setup on the Branch dashboard, you’re going to go to the left panel and select Account Settings. This section is going to provide you with some sensitive data you’re going to need to help jumpstart integration of Branch into your iOS application.

Find your `branch key` and copy it into a notepad as you’re going to need this shortly.

Under the Channels & Links section on the left panel, select Link Settings. From the dropdown for the URI Scheme Deep Link Mode, select the `Intelligent mode`. This is the recommended mode intended to use Branch data safely in order to use URI schemes everywhere.

On the Link Settings page, you can select the checkbox `I have an iOS app`. From there, you can enter a custom URI Scheme. This can typically be anything you want as long as it matches up in your Info.plist file in XCode. We will touch on this shortly. In this particular case, use `branchsters://`. For the Apple Store Search, search the Branch Monster Factory application as the path the user will take if the application is not installed on a users’ phone yet after link selection.

Branch Integration:

For the sake of this exercise, I have decided to use Cocoapods for integration. It is important to note that you can also integrate the SDK using Carthage or copy the framework directly into your project. For additional methods of integration, you can visit the documentation here: https://docs.branch.io/pages/apps/ios/

If you do not already use Cocoapods, you can install it by typing `gem install Cocoapods` in your project folder in your terminal. From there, you can initialize a Podfile in the project folder and type the command `pod init`. I would recommend using VIM to open to the Podfile from your terminal window and update it to include the Branch cocoapod. To do that, type `vi Podfile` and add the following code:



Type :wq to write and quit the file and type `pod install` in the same project folder. This will generate a xcworkspace file which you will now open in Xcode to see the full project with Branch SDK integration. You can do this by typing `open BranchMonsterFactory.xcworkspace` in the project folder of your terminal.

There are a few more tasks you will need to take care of before you can begin coding. The two main things you will need to update are the following:
Info.plist file
Capabilities tab (next to the General info tab of your application)

Info.plist:
Add properties for the following:
branch_key - the key copied earlier from the Dashboard located under your Account Settings
branch_app_domain - Scroll to the bottom of your Link Settings and copy the Default Link Domain
i.e. eg06.app.link
Under URL types > Item 0 > URL Schemes, Item 0 should be the `branchsters` URI Scheme title assigned on the dashboard

	The end result should look this like following:
	

Capabilities:
Next to the General tab of your project file, open ‘Capabilities’. Within this tab, there are several options to choose from. Turn Associated Domains ON. From here you are going to add the default link domain and the alternate link domain provided by Branch on the Link Settings Dashboard. In order for Universal Links to work properly in your project, you will need to prepend `applinks:` to your app link. See screenshot below for an example.


Finally, we will importing Branch into our project to setup to custom event tracking, link creation, and content sharing.
Open AppDelegate.m. Add #import "Branch/Branch.h" at the top of the file
Within your didFinishLaunchingWithOptions callback function, you will add a Branch callback function used for all deep link routing. See Step 3.
Branch provides a callback function to use within didFinishLaunchingWithOptions to allow it to handle deep links and observe the lifecycle of an iOS application once initialized.
Add the following code to your project:


Note: When a URL is clicked on, if the key `monster` is present in the deep link dictionary, it will check the parameters and instantiate the MonsterViewerViewController with the monster data being passed.
   
Once Branch is integrated, we can begin setting up Custom Events, Link Creation and Content Sharing!

Custom Events:
The first thing we want to be able to do is track that the user visited the monster edit page. We will call this event `monster_edit`.

Navigate to the MonsterCreatorViewController.m file and #import "Branch/Branch.h".
Add the following code below within viewDidLoad to send an action to the Branch server and create a custom event. Once you hit this action in your application, you will be able to see it listed with a timestamp on your Branch Dashboard under Linkview > filter by `custom event` on the dropdown menu:


Next, we’ll want to add the same code above to MonsterViewerViewController in viewDidLoad to track that the user visited the monster view page. We will call this event “monster_view”.

Navigate to the MonsterViewerViewController.m file and #import "Branch/Branch.h".
Again, add the following code to send an action to the Branch server and create a custom event, However, this time around you should pass in the state from the monsterMetadata to send to the server. monsterMetadata includes the additional state items associated with the action. After the event has been logged, you can also view this data column on your Branch Dashboard under Linkview > filter by `custom event` on the dropdown menu. From there, select `custom data` on the column filter to display that column to display. 

Link Creation:
The next thing we want to do is to be able to generate a shortUrl for our View. Once this URL is generated, it will be set to display to the user on the textview. To generate this, beneath the custom event tracking for the `monster_view` within MonsterViewerViewController.m, add the following:


What this function does is it generates a shortURL using the link domain provided to us on the Branch Dashboard. We send the prepareBranchDict (which is an NSDictionary of parameters to include in the link) along with the channel, feature and the URL returned from the callback. To keep things simple, we will keep the channel and feature attributes the same since this is just for displaying to the view. From there, we check if the callback returns an error and if not, we set the url returned to the urlTextView text to be displayed on the View and we hide the progressBar.

In the same file, the next thing we want to be able to be do is navigate to the cmdMessageClick IBAction and use the same getShortURLWithParams callback function. This time, the channel will be set to “sms” and we will update the smsViewController body. 

From there, we present the smsViewController only if there is no error returned from the callback. The SMS body text should be populated with the url and monsterName we provided.


Build and run the app and you should be able to create links, track custom events and have share functionality in your application! I hope this information was informative on getting up and running with Branch in your iOS application!

Thanks!
Mike Horn
