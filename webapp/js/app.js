var gCognitoAuth;

function init() {
  gCognitoAuth = new AmazonCognitoIdentity.CognitoAuth(COGNITO_AUTH_DATA);

  gCognitoAuth.userhandler = {
    onSuccess: function(result) {
        console.log("COGNITO SUCCESS!", result);
        console.log("Token", result.accessToken.jwtToken);

        var xmlhttp = new XMLHttpRequest();
        var url = "/api/WeatherForecast";
        xmlhttp.open('GET', url);
        xmlhttp.setRequestHeader('Authorization', result.accessToken.jwtToken); 
        xmlhttp.withCredentials = false;
        xmlhttp.onload = function() {
          if (this.status == 200) {
            var data = this.responseText;
            console.log('Success & Data', data);

            document.getElementById('apiOut').textContent = data;
          } else {
            console.log('Success, but code != 200');
          }
        };
        xmlhttp.onerror = function(err) {
          console.log('Error', err);
        }
        xmlhttp.send();
    },
    onFailure: function(err) {
        console.log("COGNITO FAIL!", err);
    }
  };

  gCognitoAuth.parseCognitoWebResponse(location.href);

  checkLogin();

  document.getElementById('loggedInUser').textContent = gCognitoAuth.getUsername();
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
