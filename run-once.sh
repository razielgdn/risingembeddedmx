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
echo ""
echo "\033[1;32m Done configuring your Jekyll site! Here are the next steps: \033[00m"
echo "1. Modify the baseurl and url in your _config.yml file:"
echo "    The baseurl is $BASEURL "
echo "    The url is https://https://razielgdn.github.io "
echo "2. Run Jekyll for the first time on your computer:"
echo "    bundle exec jekyll serve --livereload "
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
echo ""
echo "7. Optionally, create a README.md at the root of this folder to provide yourself"
echo "    and others with pertinent details for building and using the repo"
