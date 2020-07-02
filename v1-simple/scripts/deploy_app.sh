#!/bin/sh
# Script to deploy a very simple web application.
# The web app has a customizable image and some text.

# Set default values
[[ -z $PREFIX ]] && PREFIX="Garfield"
[[ -z $PLACEHOLDER ]] && PLACEHOLDER="placekitten.com"
[[ -z $WIDTH ]] && WIDTH=400
[[ -z $HEIGHT ]] && HEIGHT=800

mkdir -p /usr/local/apache2/htdocs

cat << EOM > /usr/local/apache2/htdocs/index.html
<html>
  <head><title>Meow!</title></head>
  <body>
  <div style="width:800px;margin: 0 auto">

  <!-- BEGIN -->
  <center><img src="http://${PLACEHOLDER}/${WIDTH}/${HEIGHT}"></img></center>
  <center><h2>Meow World!</h2></center>
  <center>Welcome to ${PREFIX}'s Meowlicious app.</center>
  <!-- END -->

  </div>
  </body>
</html>
EOM

echo "Script complete."
