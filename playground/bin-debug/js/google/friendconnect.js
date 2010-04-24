	// ------------------------- Init -------------------------
	
	google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
	google.friendconnect.container.loadOpenSocialApi({
	  site: '09412210533340333505', // Change this on your site
	  onload: function() { initFriendConnect(); }
	});
	
	var viewerContentID = "viewerContent";
	var dataContentID = "dataContent";
	
	function setViewerContent(html)
	{
		var content = document.getElementById(viewerContentID);
		content.innerHTML = html;
	}
	
	function setDataContent(html)
	{
		var content = document.getElementById(dataContentID);
		content.innerHTML = html;
	}
	
	// ------------------------- Authen ------------------------- 
	
	function initFriendConnect()
	{
		// debug
		// google.loader.ClientLocation = {"latitude":13.733,"longitude":100.5,"address":{"city":"Somdet Chao Phraya","region":"Bangkok","country":"Thailand","country_code":"TH"}};
		setViewerContent("initFriendConnect");
		
		// Create a request
		var req = opensocial.newDataRequest();
		
		// request viewer
		req.add(req.newFetchPersonRequest(opensocial.IdSpec.PersonId.VIEWER), 'viewer');
		
		// Sent the request
		req.send(onAuthenData);
		
		// call flash function dialog
		flashContent.onJSDialog('<question id="0">'
								+ '<![CDATA[JS init Please wait...]]>'
								+ '<answer src="js:signIn()"><![CDATA[Sign In]]></answer>'
								+ '</question>');
	}
	
	function onFail()
	{
		// debug
		setViewerContent("onFail");
		
		// Create the sign in link
		google.friendconnect.renderSignInButton({id:viewerContentID});
		
		// call flash function logOut
		flashContent.onJSSignOut();
	}
	
	var viewerResp;
	
	function onAuthenData(resp) 
	{
		// debug
		setViewerContent("onAuthenData");
		
		viewerResp = resp.get('viewer');
		
		if (!viewerResp.hadError()) 
		{
			var viewerData = viewerResp.getData();
			var viewerID = viewerData.getId();
			var viewerDisplayName = viewerData.getDisplayName();
			
			// say hi
			var html = 'Welcome, ('+ viewerID +')' + viewerDisplayName;
			html += '<br/><a href="#" onclick="loadData()">Load data</a>';
			html += '<br/><a href="#" onclick="saveData('+"'"+new Date().toString()+"'"+')">Save data</a>';
			html += '<br/><a href="#" onclick="signOut()">Sign out</a>';
			setViewerContent(html);
			
			// send data to flash 0.8 spec + custom data
			flashContent.onJSSignIn(viewerID, viewerDisplayName);
		}
		else
		{
			onFail();
		}
	}
	
	// ------------------------- Data -------------------------
	
	function loadData()
	{
		// debug
		setDataContent("loadData");
		
		// Create a request
		var req = opensocial.newDataRequest();
		
		// request data
		var idSpec = opensocial.newIdSpec({'userId':'VIEWER', 'groupId':'SELF'});
		req.add(req.newFetchPersonAppDataRequest(idSpec, 'time'), 'data');
		
		// Sent the request
		req.send(onPersonAppData);
	}
		
	function saveData(data)
	{
		alert(data);
		
		// debug
		setDataContent("saveData");
		
		// Create a request
		var req = opensocial.newDataRequest();
		
		// request data
  		req.add(req.newUpdatePersonAppDataRequest(opensocial.IdSpec.PersonId.VIEWER, 'time', data));
		
		// Sent the request
		req.send(onPersonAppData);
	}
	
	function onPersonAppData(resp) 
	{
		// debug
		// [{"id":"viewer","data":{"id":"04783282883872029118","thumbnailUrl":"http://www.google.com/friendconnect/profile/picture/1yFqxAW7ZhVUr_yeKb736QcaUIcqNcvHAhH0WfUFwIwLDXuJzVtqEQnyzYGVDUeeZs7P9zPgHdY5Sjx0JwQNmzdYr1iaLwbj0TErRRJevdHPmnJn9JDdjnW3NzAhZfORbkXSpcYCssufwkKLSbEkFxqwEwUKoiog0Dt59HQaHGlTpNvTEAnI28E94eEoYKZK-PIGstAdUezx9s5vT86FCBoQz0oCQyPqIHu0oJ_88_Nt5wtOoZOj0292_0VGFrb6OvIvdPR7VjbAziDcDQJ6ug","photos":[{"value":"http://www.google.com/friendconnect/profile/picture/1yFqxAW7ZhVUr_yeKb736QcaUIcqNcvHAhH0WfUFwIwLDXuJzVtqEQnyzYGVDUeeZs7P9zPgHdY5Sjx0JwQNmzdYr1iaLwbj0TErRRJevdHPmnJn9JDdjnW3NzAhZfORbkXSpcYCssufwkKLSbEkFxqwEwUKoiog0Dt59HQaHGlTpNvTEAnI28E94eEoYKZK-PIGstAdUezx9s5vT86FCBoQz0oCQyPqIHu0oJ_88_Nt5wtOoZOj0292_0VGFrb6OvIvdPR7VjbAziDcDQJ6ug","type":"thumbnail"}],"displayName":"katopz"}}]
		setDataContent("onPersonAppData");
		
		var dataResp = resp.get('data');
		
		if (!dataResp.hadError())
		{
			// got data?
			var viewerData = viewerResp.getData();
			var viewerID = viewerData.getId();
			
			var saveDatas = dataResp.getData();
			var saveData = saveDatas[viewerID];
			
			// default data template
			var currentSaveData = {'time':new Date().toString()};
			
			// parse
			if(saveData && saveData['time'])currentSaveData['time'] = saveData['time'];
			
			// output
			var html = '<br/>Last login : ' + currentSaveData['time'];
			setDataContent(html);
			
			// send data to flash 0.8 spec + custom data
			flashContent.onJSGetData(currentSaveData);
		}
		else
		{
			onFail();
		}
	}
	
	// ------------------------- Call from Flash -------------------------
	
	function signIn()
	{
		google.friendconnect.requestSignIn();
	}
	
	function signOut()
	{
		google.friendconnect.requestSignOut();
	}