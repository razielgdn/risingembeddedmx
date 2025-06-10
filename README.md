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

## About the Author

I'm Octavio Raziel, an embedded software engineer from Mexico with experience in:
- Microcontroller programming (STM32, AVR)
- Bootloader development and implementation
- C/C++ embedded programming
- Hardware-software integration

Currently based in Ocotlán de Morelos, Oaxaca, I'm passionate about embedded systems and sharing knowledge with the community.

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
├── _posts/           # Blog posts in Markdown format
├── _data/            # Site configuration and data files
├── _includes/        # Reusable template components
├── _layouts/         # Page layout templates
├── _sass/            # Custom SCSS/CSS styles
├── assets/           # Images, documents, and static files
│   ├── images/       # Project images and diagrams
│   └── documents/    # PDFs, datasheets, and resources
├── projects/         # Individual project pages and tutorials
├── about/            # About page and personal information
├── _config.yml       # Jekyll site configuration
├── Gemfile           # Ruby dependencies
└── README.md         # This file
```

### Key Directories
- **`_posts/`**: Blog entries documenting project progress, technical insights, and learning experiences
- **`projects/`**: Dedicated pages for major projects (OpenBLT implementations, STM32 tutorials, etc.)
- **`assets/`**: All static content including circuit diagrams, code screenshots, and project photos
- **`about/`**: Personal and professional information
  
## Development

### Running Locally
```bash
# Install dependencies
bundle install

# Serve the site locally
bundle exec jekyll serve

# Build for production
JEKYLL_ENV=production bundle exec jekyll build
```

### Contributing
This is a personal blog, but if you notice any issues or have suggestions, feel free to open an issue or reach out!


---

*"Documenting the journey through embedded systems, one project at a time."*