# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | FormAI |
| **Git URL** | git@github.com:asunnyboy861/FormAI.git |
| **Repo URL** | https://github.com/asunnyboy861/FormAI |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/FormAI/ | ✅ Active |
| Support | https://asunnyboy861.github.io/FormAI/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/FormAI/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/FormAI/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
FormAI/
├── FormAI/                    # iOS App Source Code
│   ├── FormAI.xcodeproj/     # Xcode Project
│   └── FormAI/               # Swift Source Files
│       ├── Views/
│       ├── Models/
│       ├── ViewModels/
│       ├── Services/
│       └── Assets.xcassets/
├── docs/                      # Policy Pages (GitHub Pages source)
│   ├── index.html             # Landing Page
│   ├── support.html           # Support Page
│   ├── privacy.html           # Privacy Policy
│   └── terms.html             # Terms of Use
├── .github/workflows/
│   └── deploy.yml             # GitHub Pages deployment
├── us.md                      # English Development Guide
├── keytext.md                 # App Store Metadata
├── capabilities.md            # Capabilities Configuration
├── icon.md                    # App Icon Details
├── price.md                   # Pricing Configuration
└── nowgit.md                  # This File
```
