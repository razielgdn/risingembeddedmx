cp -r _site/* ../siteToUpdate/
cd ../siteToUpdate/
git add .
git commit -a
git push origin site
cd ../risingembeddedmx/