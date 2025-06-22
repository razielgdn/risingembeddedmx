---
title: Dockerfile, practical examples of workspace
permalink: /notes/en/docker-jekyll-en
key: docker-en
modify_date: 2025-06-19
date: 2025-06-19  
lang: en 
---
In this article, a couple of examples using containers will be shown.
This site works using Jekyll with **TeXt Theme** modified to has custom color panel and visualizations. 
Only to give context Jekyll explanation will be added. 
# Jekyll topics
## What is Ruby?
Ruby is a high-level, general-purpose programming language designed for simplicity and productivity. It uses a clean and readable syntax that makes it beginner-friendly, but it's also powerful enough for large-scale applications. Ruby is the language behind the popular web framework Ruby on Rails, and it’s also what powers tools like Jekyll. To work with Jekyll, you'll need Ruby installed on your system to run commands and manage dependencies.

## What is Jekyll?
Jekyll is a static site generator written in Ruby. Instead of using a database like traditional content management systems (CMS) such as WordPress, Jekyll takes plain text files written in Markdown or HTML and transforms them into a complete, static website. It's especially popular for blogs and documentation sites because of its simplicity, speed, and seamless integration with GitHub Pages — allowing you to host your site for free directly from a GitHub repository. Jekyll supports layouts, themes, plugins, and custom configuration to make your site flexible and easy to maintain.

## What is a Jekyll theme?
A Jekyll theme is a pre-designed set of templates, layouts, stylesheets, and sometimes assets (like images and fonts) that define the overall appearance and structure of your site. Themes help you quickly set up a professional-looking website without designing it from scratch. They typically include standard templates for pages like the homepage, blog posts, archives, and more. There are many official and community-made themes available, and they’re often customizable through configuration options in your site’s _config.yml file.

## How can you use a Jekyll theme?
You can use a Jekyll theme in two main ways:
1. Remote Theme (GitHub Pages compatible):
   If you're hosting your site on GitHub Pages, you can use themes that are published as Ruby gems. Just add the theme name in your _config.yml file like this:
```yaml
theme: minima
```
   Then, Jekyll will automatically use that theme when building your site.
2. Custom or Local Theme:
   If you're working locally or need more customization, you can clone a theme into your project directory. This gives you full access to the theme’s files so you can modify layouts, styles, and includes directly.

# Creating a container with Docker
## Create the container 
Once installed, create a Dockerfile to run the site in a container.
The code is as follows:

```dockerfile

```

## Building and Running the Container

To build the Docker image:

```sh
docker build -t jekyll-site .
```

To run the container and mount your project directory:

```sh
docker run -it -p 4000:4000 -v $(pwd):/workspace jekyll-site
```
Docker is used to compile this site locally and generate a preview before releasing a post or article.
To use it with VS Code, you should add the following extensions:
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers){:target="_blank"}   
- [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers){:target="_blank"}



```dockerfile


```
## Using VSCode to use Jekyll 
In Visual Studio Code, you can use the container directly from the graphical interface. Once the extensions are installed and the Dockerfile is ready, follow these steps to run your environment from a container:

1. Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> to open the command palette and select **Open Folder in Container**.    
   ![](/assets/images/docker/image01.png)    
2. Select your project folder and click **Open**.
3. When prompted, select **Add configuration to user data folder** to work locally.
4. Choose **From Dockerfile** as the configuration source.
5. Click **OK** in the remaining tabs without changing any arguments.
6. Wait until the container is created and your environment is ready.
   
