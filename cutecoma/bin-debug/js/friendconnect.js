   google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
   google.friendconnect.container.loadOpenSocialApi({
     site: '09412210533340333505', // Change this on your site
     onload: function() { initFriendConnect(); }
   });
   
	// ------------------------- Authen ------------------------- 

   function initFriendConnect() {
     // Create a request to grab the current viewer.
     var req = opensocial.newDataRequest();
     req.add(req.newFetchPersonRequest('VIEWER'), 'viewer_data');
     // Sent the request
     req.send(onAuthenData);
   }
   
   function onAuthenData(data) {
     // If the view_data had an error, then user is not signed in
     if (data.get('viewer_data').hadError()) {
       // Create the sign in link
       var options = {
         id: "content"
       };
       google.friendconnect.renderSignInButton(options);
     } else {
       var content = document.getElementById('content');
       // If the view_data is not empty, we can display the current user
       // Create html to display the user's name, and a sign-out link.
	
	var nick = data.get('viewer_data').getData().getDisplayName();
       var html = 'Welcome, ' + nick;
       html += '<br><a href="#" onclick="google.friendconnect.requestSignOut()">Sign out</a>';
       content.innerHTML = html;
	
	// call flash
	
     }
   }

// ------------------------- User data ------------------------- 
/*
  function addData() {
    var currentTime = new Date().toString();
    
    var req = opensocial.newDataRequest();
    req.add(req.newUpdatePersonAppDataRequest(opensocial.IdSpec.PersonId.VIEWER, 'time', currentTime));
    req.send(setTimeCallback);
  }
  
  function setTimeCallback(data) {
    if (data.hadError()) {
      var options = {
        id: "content"
      };
      google.friendconnect.renderSignInButton(options);
    } else {
      var content = document.getElementById('content');
      var html = 'The time has been stored. To view data, click below.<br/>';
      html += '<input type="button" onclick="onUserData();" value="Retrieve Data" /><br/>';
      html += '<input type="button" onclick="init();" value="Store Time Again" /><br/>';
      html += '<a href="#" onclick="google.friendconnect.requestSignOut()">Sign out</a>';
      content.innerHTML = html;
    }
  }
  
  function onUserData() {
    var req = opensocial.newDataRequest();
    var idspec = opensocial.newIdSpec({'userId':'VIEWER', 'groupId':'SELF'});
  
    req.add(req.newFetchPersonRequest(opensocial.IdSpec.PersonId.VIEWER), 'viewer');
    req.add(req.newFetchPersonAppDataRequest(idspec, 'time'), 'data');
    req.send(fetchAppDataHandler);
  }
  
  function fetchAppDataHandler(resp) {
    var viewerResp = resp.get('viewer');
    var dataResp = resp.get('data');
  
    if (!viewerResp.hadError() && !dataResp.hadError()) {
      var viewer = viewerResp.getData();
      var data = dataResp.getData();
  
      var viewerData = data[viewer.getId()];
  
      if (viewerData) {
        alert('The stored time is ' + viewerData['time']);
      }
    }
  }
  */