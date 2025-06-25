#!/bin/bash
# This script is intended to be run once after cloning a Jekyll site repository.
# Display current Ruby version
echo "Ruby version"
ruby -v

# Display current Jekyll version
echo "Jekyll version"
jekyll -v
# Update gems
echo "bundle install"
bundle install
echo "bundle update"
bundle update

# Get the presumed value for the baseurl (this folder name) 
var=$(pwd)
BASEURL="$(basename $PWD)"

echo "Done configuring your Jekyll site! Here are the next steps:"
echo "1. Modify the baseurl and url in your _config.yml file:"
echo "    The baseurl is $BASEURL "
echo "    The url is https://razielgdn.github.io "
echo "2. Run Jekyll for the first time on your computer:"
echo "With VSCode:    bundle exec jekyll serve --livereload (default) "
echo " In terminal:  bundle exec jekyll serve --host 0.0.0.0 --port 4000 --baseurl "/risingembeddedmx" --livereload "
echo "    Look for the site at port 4000 (ex http://127.0.0.1:4000/)"
echo "    After testing, type CONTROL+C to stop Jekyll"
echo "3. Commit all your changes to Git locally"
echo "4. Publish your site to a new GitHub repo"
echo "5. In GitHub, enable GitHub Pages in the repo settings with branch  site "
echo "some gems are not compatible with github pages, site should be created locally with:"
echo " JEKYLL_ENV=production bundle exec jekyll build "
echo " run script publish.sh and test:"
echo "   https://razielgdn.github.io/$BASEURL"
echo "6. Continue developing locally and pushing changes to GitHub"
echo "    All your changes will publish to the website automatically after a few minutes"
