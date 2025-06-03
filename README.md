# Readme
Hello, welcome to my site Repo, I am using TeXt theme and I modify the environment according with my projects. 
pass to my github repos to check my projects. 

Some notes: 
# create the site 
```bash 
    # create the site 
    JEKYLL_ENV=production bundle exec jekyll build
    #create a folder to work with the publication 
    mkdir ../siteToUpdate
    cd ../siteToUpdate/
    git clone -b site git@github.com:razielgdn/risingembeddedmx.git .
    # copy _site files
    cd ../risingembeddedmx/
    cp -r _site/* ../siteToUpdate/
    cd ../siteToUpdate/
    # push to github now a new branch is required to merge with 'site'
    git checkout -b <branch-to-do-pull-request> 
    git add .
    git commit -a
    git push origin <branch-to-do-pull-request> 
    cd ../risingembeddedmx/
    
```
