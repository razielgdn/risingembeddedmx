# create the site with JEKYLL_ENV=production bundle exec jekyll build
mkdir ../siteToUpdate
cd ../siteToUpdate/
git clone -b site git@github.com:razielgdn/risingembeddedmx.git .
cd ../risingembeddedmx/
cp -r _site/* ../siteToUpdate/
cd ../siteToUpdate/
git add .
git commit -a
git push origin site
cd ../risingembeddedmx/