# Template Repository - Quick Reference

This repository is configured as a GitHub template. Here's what you need to know:

## 🎯 Purpose

This is a **template repository** designed to help users quickly bootstrap new Robot Framework automation projects.

## 👥 Two Types of Users

### 1. Template Users (Most Common)
People who want to create their own automation project based on this blueprint.

**What they do:**
- Click "Use this template" button
- Create their own repository with a copy of all files
- Customize for their specific automation needs
- Work independently in their own repository

**Resources for them:**
- `README.md` - Main documentation with "Use this template" button
- `.github/TEMPLATE_SETUP.md` - Post-creation setup guide
- `.env.example` - Configuration template

### 2. Contributors
People who want to improve the template itself for all users.

**What they do:**
- Fork the blueprint repository
- Make improvements to the template
- Submit pull requests back to this repository

**Resources for them:**
- `CONTRIBUTING.md` - Contribution guidelines
- `.github/TEMPLATE_ADMIN_GUIDE.md` - Admin documentation
- `.github/TEMPLATE_CHECKLIST.md` - Quality checklist

## 📁 Template-Specific Files

### User-Facing Files
- `README.md` - Updated with template usage instructions
- `.env.example` - Environment configuration template
- `.github/TEMPLATE_SETUP.md` - Post-creation instructions

### Maintainer Files (can be kept or removed)
- `.github/TEMPLATE_ADMIN_GUIDE.md` - How to manage the template
- `.github/TEMPLATE_CHECKLIST.md` - Pre-publication checklist
- `.github/TEMPLATE_README.md` - This file
- `.github/BADGES.md` - Badge reference
- `.github/template.yml` - Template metadata

### Configuration Files
- `.github/template.yml` - Defines template metadata for GitHub
- `.gitignore` - Ensures secrets are never committed

## 🚀 Enabling Template Feature

**Repository Administrator Action Required:**

1. Go to repository **Settings**
2. Find **Template repository** section
3. Check the box ✅ **Template repository**
4. The "Use this template" button will appear

See `.github/TEMPLATE_ADMIN_GUIDE.md` for detailed instructions.

## 🔄 Workflow

```
┌─────────────────────────────────────┐
│   Robot Automation Blueprint        │
│   (This Template Repository)        │
└──────────────┬──────────────────────┘
               │
               │ User clicks "Use this template"
               │
               ▼
┌─────────────────────────────────────┐
│   User's New Repository             │
│   (Independent copy)                │
│   - Clean git history               │
│   - All template files              │
│   - Ready to customize              │
└─────────────────────────────────────┘
```

## 📋 Before Making Public

Use the checklist in `.github/TEMPLATE_CHECKLIST.md` to ensure:
- ✅ No hardcoded secrets or credentials
- ✅ All documentation is clear and accurate
- ✅ Setup scripts work correctly
- ✅ Example files are included
- ✅ Template feature is enabled in Settings

## 🔐 Security

**Critical:**
- Never commit `.env` files (handled by `.gitignore`)
- Use `.env.example` with placeholders only
- Review all files for sensitive information before publishing

## 📚 Documentation Updates

When updating the template:
1. Test changes thoroughly
2. Update README.md if user experience changes
3. Update TEMPLATE_SETUP.md if setup process changes
4. Consider version tagging for significant updates

## 🤝 Contributing Back

Template users who want to contribute improvements:
1. Fork the original blueprint repository
2. Make improvements
3. Submit PR to the blueprint (not their own repo)

See `CONTRIBUTING.md` for details.

## 📞 Support

For template-specific questions:
- Check `.github/TEMPLATE_ADMIN_GUIDE.md`
- See GitHub's [Template Repository Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)

For project/automation questions:
- See main `README.md`
- Check troubleshooting section
- Review best practices

---

**Last Updated**: November 26, 2025  
**Template Version**: 1.0
