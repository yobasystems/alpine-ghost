#!/bin/bash
cd /ghost/content

mkdir -p apps data images themes

sed -i "s|http://my-ghost-blog.com|$URL|g" /ghost/config.js

sed -i "s|http://localhost|$URL|g" /ghost/config.js

if [ "$CUSTOM_SMTP" == "True" ]; then
    cd /usr/local/etc
    sed -i -e "/mail: {},/r smtp.conf" \
           -e "/mail: {},/d" /ghost/config.js
    sed -i -e "s/<SERVICE>/$SERVICE/g" \
           -e "s/<USER>/$SMTP_USER/g" \
           -e "s/<PASS>/$SMTP_PASS/g" /ghost/config.js
fi

if [ ! -d /ghost/content/themes/casper ]; then
    cp -r /ghost/casper /ghost/content/themes/casper
else
    CASPER=`md5sum /ghost/casper/package.json | awk '{ print $1 }'`
    INSTALLED_CASPER=`md5sum /ghost/content/themes/casper/package.json | awk '{ print $1 }'`
    if [ "$CASPER" != "$INSTALLED_CASPER" ]; then
      rm -rf /ghost/content/themes/casper
      cp -r /ghost/casper /ghost/content/themes/casper
    fi
fi

if [ "$SYNTAX_HIGHLIGHTING" == "True" ] && [ ! -f /ghost/content/themes/casper/assets/js/prism.js ]; then
    cp /ghost/prismjs/$HIGHLIGHTER_COLOR/prism.css /ghost/content/themes/casper/assets/css
    cp /ghost/prismjs/$HIGHLIGHTER_COLOR/prism.js /ghost/content/themes/casper/assets/js
    cd /usr/local/etc
    sed -i -e "/Styles'n'Scripts/r prism.css.conf" \
           -e "/The main JavaScript file for Casper/r prism.js.conf" \
           /ghost/content/themes/casper/default.hbs
fi

chown -R $UID:$GID /ghost && cd /ghost
su-exec $UID:$GID npm start --production
