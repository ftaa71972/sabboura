set -e
cd /tmp && rm -rf fdep && mkdir fdep && cd fdep
curl -fsSL "https://ftaa71972.github.io/sabboura/deploy/ld.html?v=$(date +%s)" -o ld.html
curl -fsSL "https://ftaa71972.github.io/sabboura/i18n.js?v=$(date +%s)" -o i18n.js
grep -q langSel ld.html && grep -q __I18N_D i18n.js
L=/var/www/site/sabboura-ld; S=/var/www/site/sabboura
sudo cp $L/index.html $L/index.html.bak
sudo cp ld.html $L/index.html
sudo cp $S/index.html $S/index.html.bak
sudo cp i18n.js $S/i18n.js
if ! grep -q 'src="i18n.js"' $S/index.html; then
  sudo python3 -c "
p='$S/index.html';s=open(p,encoding='utf-8').read();i=s.rfind('</body>');s=s[:i]+'<script src=\"i18n.js\"></script>\n'+s[i:];open(p,'w',encoding='utf-8').write(s)"
fi
if [ -f $S/sw.js ]; then
  sudo cp $S/sw.js $S/sw.js.bak
  sudo sed -i "s/const C='sabboura-v[0-9]*';/const C='sabboura-v3';/" $S/sw.js
  grep -q "i18n.js" $S/sw.js || sudo sed -i "s#'./apple-touch-icon.png'\]#'./apple-touch-icon.png','./i18n.js']#" $S/sw.js
fi
sudo chown -R root:root $L $S && sudo chmod -R a+rX $L $S
for u in sabboura/ sabboura/i18n.js sabboura-ld/; do curl -s -o /dev/null -w "$u %{http_code}\n" https://ftaa7alrashid.com/$u; done
curl -s https://ftaa7alrashid.com/sabboura/ | grep -c 'src="i18n.js"'
curl -s https://ftaa7alrashid.com/sabboura-ld/ | grep -c langSel
echo DEPLOY-DONE
