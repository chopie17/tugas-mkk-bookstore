# Contributing to BookStore

Thank you for your interest in contributing to the BookStore project! This document provides guidelines and instructions for contributing.

## 📋 Code of Conduct

Be respectful and professional in all interactions with other contributors.

## 🐛 Reporting Bugs

### Before Submitting a Bug Report

- Check if the bug has already been reported in Issues
- Check if the issue is already fixed in the latest version

### How to Submit a Good Bug Report

Include the following:

1. **Title**: Clear, concise description
2. **Description**: What happened and what should have happened
3. **Steps to Reproduce**: How to reproduce the issue
4. **Environment**: 
   - OS (Windows, macOS, Linux)
   - PHP version
   - Node.js version
   - Browser version
5. **Screenshots**: If applicable
6. **Error Messages**: Full error traces and logs

Example:
```
Title: Login fails with incorrect email validation

Description: When I try to login with email containing plus sign (e.g., user+test@gmail.com), 
the form shows validation error even though it's a valid email.

Steps to Reproduce:
1. Go to http://localhost:3000/login
2. Enter "user+test@gmail.com" as email
3. Enter any password
4. Click login button

Expected: Should attempt login with valid email
Actual: Shows "Invalid email format" error

Environment:
- OS: Windows 11
- PHP: 8.2.0
- Node.js: 18.0.0
- Browser: Chrome 120
```

## 💡 Suggesting Enhancements

### Before Suggesting an Enhancement

- Check if enhancement has already been suggested
- Ensure the suggestion fits the scope of the project

### How to Submit a Good Enhancement Suggestion

1. **Title**: Clear, concise description
2. **Description**: Detailed explanation of the enhancement
3. **Motivation**: Why would this enhancement be useful?
4. **Examples**: Relevant examples from other applications
5. **Implementation Notes**: Any ideas on how to implement it

## 🔧 Development Setup

### Fork and Clone
```bash
# Fork the repository on GitHub

# Clone your fork
git clone https://github.com/YOUR_USERNAME/bookstore.git
cd sekolah

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/bookstore.git
```

### Create a Feature Branch
```bash
# Update main branch
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/your-feature-name
```

### Branch Naming Convention
- Feature: `feature/description`
- Bug fix: `fix/description`
- Documentation: `docs/description`
- Performance: `perf/description`

Example: `feature/add-wishlist-functionality`

## 💻 Code Style

### Backend (PHP/Laravel)

- Follow PSR-12 coding standard
- Use meaningful variable names
- Add comments for complex logic
- Keep methods focused and small

```php
// Good
public function updateUserProfile(Request $request): JsonResponse
{
    $user = auth()->user();
    
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users,email,' . $user->id,
    ]);
    
    $user->update($validated);
    
    return response()->json(['message' => 'Profile updated successfully']);
}

// Avoid
public function upd($r): JsonResponse
{
    $u = auth()->user();
    $u->update($r->only(['name', 'email']));
    return response()->json(['message' => 'OK']);
}
```

### Frontend (Vue/TypeScript)

- Use TypeScript for type safety
- Use meaningful component names
- Keep components focused (single responsibility)
- Use composables for reusable logic

```vue
<!-- Good -->
<template>
  <div class="product-card">
    <img :src="product.image" :alt="product.name" />
    <h3>{{ product.name }}</h3>
    <p class="price">Rp {{ formatPrice(product.price) }}</p>
    <button @click="addToCart">Add to Cart</button>
  </div>
</template>

<script setup lang="ts">
interface Product {
  id: number
  name: string
  price: number
  image: string
}

const props = defineProps<{ product: Product }>()
const emit = defineEmits<{ addToCart: [productId: number] }>()

const formatPrice = (price: number): string => {
  return new Intl.NumberFormat('id-ID').format(price)
}

const addToCart = () => {
  emit('addToCart', props.product.id)
}
</script>
```

## 📝 Commit Messages

Use clear, descriptive commit messages:

```
Format: [TYPE] Brief description

Types:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Code style
- refactor: Code refactoring
- perf: Performance improvement
- test: Testing
- chore: Build process, dependencies

Examples:
feat: Add wishlist functionality
fix: Correct email validation regex
docs: Update setup instructions
refactor: Extract product filter logic to composable
```

## ✅ Testing

### Backend Testing

```bash
cd backend/bookstore-api

# Run tests
php artisan test

# Run specific test
php artisan test tests/Unit/YourTest.php

# Run with coverage
php artisan test --coverage
```

### Frontend Testing

```bash
cd frontend/bookstore-web

# Run unit tests (if setup)
npm run test

# Run linting
npm run lint
```

## 📤 Submitting Pull Requests

### Before Submitting

1. Update your fork with latest upstream changes
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. Ensure your code follows style guidelines
3. Test thoroughly (no breaking changes)
4. Update documentation if needed
5. Add meaningful commit messages

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issues
Closes #(issue number)

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing Done
- [ ] Manual testing completed
- [ ] No breaking changes
- [ ] All tests pass

## Screenshots/Demo
If applicable, add screenshots or demo links

## Checklist
- [ ] Code follows style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Changes are tested locally
```

### PR Review Process

1. Maintainers will review your PR
2. Address feedback and make requested changes
3. Commits will be squashed and merged when approved

## 📚 Documentation

When contributing code, also update documentation:

1. **README.md**: Major features or setup changes
2. **Code Comments**: Complex logic
3. **Commit Messages**: Clear description of changes
4. **API Docs**: New endpoints

## 🚀 Release Process

Maintainers follow semantic versioning:
- Major (X.0.0): Breaking changes
- Minor (0.X.0): New features
- Patch (0.0.X): Bug fixes

## 📞 Questions?

- Check existing documentation
- Search closed issues/PRs
- Open a discussion in Issues

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to BookStore! 🎉
