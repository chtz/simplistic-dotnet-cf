var gCognitoAuth;

function init() {
  gCognitoAuth = new AmazonCognitoIdentity.CognitoAuth(COGNITO_AUTH_DATA);

  gCognitoAuth.userhandler = {
    onSuccess: function(result) {
      console.log("COGNITO SUCCESS!", result);

      //... xmlhttp.setRequestHeader('Authorization', result.accessToken.jwtToken); ...
    },
    onFailure: function(err) {
        console.log("COGNITO FAIL!", err);
    }
  };

  gCognitoAuth.parseCognitoWebResponse(location.href);

  checkLogin();

  if (!gCognitoAuth.isUserSignedIn()) {
    document.getElementById('loggedInUser').textContent = "not logged in";
    document.getElementById('apiOut').textContent = "no api call";
  }
  else {
    //document.getElementById('loggedInUser').textContent = gCognitoAuth.getUsername();
    document.getElementById('loggedInUser').textContent = JSON.parse(atob(gCognitoAuth.getSignInUserSession().getIdToken().jwtToken.split('.')[1])).email; // FIXME ;-) there must be a better way

    var xmlhttp = new XMLHttpRequest();
    var url = "/api/WeatherForecast";
    xmlhttp.open('GET', url);
    xmlhttp.setRequestHeader('Authorization', gCognitoAuth.getSignInUserSession().getIdToken().jwtToken); 
    xmlhttp.withCredentials = false;
    xmlhttp.onload = function() {
      if (this.status == 200) {
        var data = this.responseText;
        console.log('API 200', data);

        document.getElementById('apiOut').textContent = data;
      } else {
        console.log('API != 200');
      }
    };
    xmlhttp.onerror = function(err) {
      console.log('Error', err);
    }
    xmlhttp.send();
  }
}


function checkLogin() {
  if (!gCognitoAuth.isUserSignedIn()) {
    gCognitoAuth.getSession();
  }
}

function logout() {
  if (gCognitoAuth.isUserSignedIn()) {
    gCognitoAuth.signOut();
  }
}
