# Rising Embedded MX

Welcome to my embedded systems engineering blog! This is where I document my journey through the world of microcontrollers, bootloaders, and embedded software development.

## About

**Rising Embedded MX** is my personal technical blog where I share:

- **Project Development Logs**: Real-time documentation of embedded projects, including challenges, solutions, and lessons learned
- **Technical Implementations**: Detailed walkthroughs of working with microcontrollers (STM32, AVR), bootloaders (OpenBLT), and embedded C/C++
- **Career Insights**: Honest reflections on the embedded systems industry, job market, and professional growth
- **Learning Journey**: Both successes and failures in embedded development projects

## What You'll Find Here

### Recent Projects
- **OpenBLT Bootloader Implementations**: Adapting OpenBLT for different platforms (STM32H53, Bluepill Plus, Nucleo-64)
- **STM32 Development**: Working with various STM32 microcontroller families
- **AVR Projects**: Exploring 8-bit microcontroller development
- **C++ Learning**: Object-oriented programming applied to embedded systems

### Content Style
This blog follows a "learning in public" approach - you'll see the complete development process, including:
- Time estimates and actual duration of projects
- Technical obstacles and how they were overcome
- Resource recommendations and lessons learned
- Personal reflections on the engineering journey

## Technical Details

- **Built with**: Jekyll static site generator
- **Theme**: TeXt theme (customized)
- **Deployment**: GitHub Actions (automated)
- **Hosting**: GitHub Pages

## Visit the Blog

🌐 **Live Site**: [razielgdn.github.io/risingembeddedmx](https://razielgdn.github.io/risingembeddedmx/)

## Repository Structure

```
risingembeddedmx/
├── _data/            # Site configuration and data files
├── _includes/        # Reusable template components
├── _layouts/         # Page layout templates
├── _sass/            # Custom SCSS/CSS styles
├── about/            # About pages with multi-language support
│   ├── en/           # English version
│   └── es/           # Spanish version
├── assets/           # Images, documents, and static files
├── contents/         # Organized content collections
│   ├── _3dprinting/  # 3D printing related content
│   ├── _data/        # Content-specific data files
│   ├── _posts/       # Blog posts in Markdown format
│   └── _projects/    # Individual project pages and tutorials
│       ├── en/       # English project pages
│       └── es/       # Spanish project pages
├── _config.yml       # Jekyll site configuration
├── Dockerfile        # Docker container configuration
├── Gemfile           # Ruby dependencies
└── README.md         # This file
```

### Key Directories
- **`contents/`**: Main content organization hub
  - **`_posts/`**: Blog entries documenting project progress, technical insights, and learning experiences
  - **`_projects/`**: Dedicated project pages with bilingual support (English/Spanish)
  - **`_3dprinting/`**: 3D printing projects and tutorials
  - **`_data/`**: Content-specific configuration and data
- **`about/`**: Personal and professional information with bilingual support (English/Spanish)
- **`assets/`**: All static content including circuit diagrams, code screenshots, and project photos

### Development Environment
- **`Dockerfile`**: Containerized development environment for consistent builds
- **`Gemfile`**: Ruby gem dependencies for Jekyll and plugins

## Development

### Running Locally
```bash
# Install dependencies
bundle install

# Serve the site locally
bundle exec jekyll serve --host 0.0.0.0 --port 4000 --livereload

# Build for production
JEKYLL_ENV=production bundle exec jekyll build
```

### Contributing
This is a personal blog, but if you notice any issues or have suggestions, feel free to open an issue or reach out!

## Connect

- **GitHub**: [@razielgdn](https://github.com/razielgdn)
- **LinkedIn**: [Professional Profile](https://https://www.linkedin.com/in/octaviorazielgdn/)
---
*"Every line of embedded code I write brings me one step closer to my own piece of land."*