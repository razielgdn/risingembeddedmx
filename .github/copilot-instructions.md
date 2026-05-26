# AI Coding Agent Instructions for Rising Embedded MX

## Project Overview
This is a Jekyll-based static site generator for a personal technical blog focused on embedded systems engineering. It uses the TeXt theme with a custom "remcustom" skin, supporting bilingual content (English/Spanish) and automated deployment to GitHub Pages.

## Architecture & Structure
- **Content Organization**: All content lives in `contents/` directory with collections: `_posts` (blog articles), `_projects` (tutorials), `_3dprinting`, `_notes`
- **Multilingual Support**: English content in root collections, Spanish in `es/` subdirectories
- **Collections Config**: Defined in `_config.yml` with output enabled; projects use numbered subdirs for series (e.g., `1-openblt/1.1-openblt-start.md`)
- **Layouts**: Primarily `article` layout with TOC sidebar; custom includes in `_includes/` for components like analytics, comments (Gitalk), sharing (AddToAny)

## Content Creation Patterns
- **Blog Posts**: `contents/_posts/YYYY-MM-DD-title.md` with front matter: `title`, `layout: article`, `tags: [tag1, tag2]`
- **Project Pages**: `contents/_projects/{en,es}/project-name/X.Y-title.md` with `permalink: /projects/{en,es}/project-name/title`, `key: unique-key`
- **Excerpts**: Use `<!--more-->` for post summaries
- **Images**: Store in `assets/images/`, reference with `{{ site.url }}{{ site.baseurl }}/assets/images/...`
- **About Pages**: `about/{en,es}/index.md` with custom navigation keys

## Development Workflow
- **Local Development**: `bundle exec jekyll serve` (port 4000, livereload enabled)
- **Production Build**: `JEKYLL_ENV=production bundle exec jekyll build`
- **Docker Alternative**: Use `docker-compose.yml` for containerized environment with volume mounting
- **Dependencies**: Ruby gems via `Gemfile`; install with `bundle install`
- **Deployment**: Automatic via GitHub Actions on `main` branch push; builds to `_site/`

## Key Conventions
- **Front Matter Defaults**: Posts get `sharing: true`, `license: CC-BY-NC-4.0`, `aside.toc: true`; projects disable license, enable date display
- **Navigation**: Controlled by `_data/navigation.yml`; projects use `nav_key: projects` (English) or `projects-spanish` (Spanish)
- **Markdown Enhancements**: Mermaid diagrams and charts enabled; MathJax disabled
- **Permalinks**: Date-based for posts; custom for projects
- **Exclusions**: Build excludes `Gemfile*`, `README*`, Docker files, etc.

## Integration Points
- **Comments**: Gitalk (GitHub issues-based) with repo `custom-application-test`
- **Analytics**: Google Analytics `G-P83G4T9J8J`
- **Sharing**: AddToAny provider
- **Search**: Default Jekyll search
- **External Links**: Use `{:target="_blank"}` for external references

## Common Tasks
- **Add Blog Post**: Create dated file in `contents/_posts/`, add tags, use `<!--more-->` for excerpt
- **Create Project Series**: Make subdir in `contents/_projects/en/`, number files sequentially, set permalinks
- **Update Navigation**: Edit `_data/navigation.yml` for menu changes
- **Customize Styling**: Modify `_sass/custom.scss` for theme overrides
- **Add Static Assets**: Place in `assets/` directory, reference via site variables

Reference: [_config.yml](_config.yml) for full configuration, [contents/_posts/](contents/_posts/) for post examples, [contents/_projects/en/1-openblt/](contents/_projects/en/1-openblt/) for project structure.</content>
<parameter name="filePath">/home/razielgdn/github-pages/risingembeddedmx/.github/copilot-instructions.md