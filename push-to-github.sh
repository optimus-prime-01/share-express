#!/bin/bash

echo "🚀 Pushing ShareXpress to GitHub..."
echo ""

# Initialize git if not already
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📝 Adding files..."
git add .

# Show status
echo ""
echo "📋 Files to be committed:"
git status --short

# Commit
echo ""
echo "💾 Committing files..."
git commit -m "Initial commit: ShareXpress file sharing app"

# Add remote
echo ""
echo "🔗 Adding remote repository..."
git remote remove origin 2>/dev/null
git remote add origin https://github.com/optimus-prime-01/share-express.git

# Push
echo ""
echo "⬆️  Pushing to GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "✅ Done! Check your repo: https://github.com/optimus-prime-01/share-express"
