# Frontend Development Best Practices

## Component Architecture

### Component Types

| Type | Location | Purpose |
|------|----------|---------|
| Page | `src/app/` | Route-level components |
| Layout | `src/app/layout.tsx` | Shared layout wrapper |
| Feature | `src/components/features/` | Feature-specific components |
| UI | `src/components/ui/` | Reusable base components |

### Component Guidelines

1. **Server Components by Default**
   - Use for data fetching, SEO
   - No interactivity

2. **Client Components When Needed**
   - Add 'use client' directive
   - Required for: useState, useEffect, event handlers

3. **Composition Over Inheritance**
   - Build complex components from simpler ones
   - Use children props for flexibility

## Styling with Tailwind

### Utility Classes

```tsx
// Prefer utility classes
<button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
  Click me
</button>

// Extract to component for reuse
const Button = ({ children }) => (
  <button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
    {children}
  </button>
);
```

### Responsive Design

```tsx
// Mobile-first approach
<div className="w-full md:w-1/2 lg:w-1/3">
  {/* Full width on mobile, half on md, third on lg */}
</div>
```

## State Management

### Local State
- Use useState for component-local state
- Keep state as close to where it's used as possible

### Server State
- Fetch in Server Components
- Pass down as props
- Revalidate on action

### URL State
- Use for shareable state (filters, pagination)
- Next.js searchParams for reading

## Form Handling

### Server Actions (Preferred)

```tsx
// actions.ts
'use server'
export async function submitForm(formData: FormData) {
  // Process form
}

// component.tsx
<form action={submitForm}>
  <input name="field" />
  <button type="submit">Submit</button>
</form>
```

### Client-Side Validation

```tsx
const [errors, setErrors] = useState({});

const handleSubmit = (e) => {
  e.preventDefault();
  const formData = new FormData(e.target);
  // Validate and submit
};
```

## Testing Requirements

### Must Browser Test
- New pages
- Form submissions
- Interactive components
- Authentication flows

### Can Unit Test
- Utility functions
- Data transformations
- Business logic

### Verification Commands

```bash
npm run lint   # Code quality
npm run build  # Production build
npm run test   # Unit tests (if available)
```

## Error Handling

### User-Facing Errors

```tsx
// Show friendly error messages
{error && (
  <div className="text-red-500">
    {error.message}
  </div>
)}
```

### API Errors

```typescript
try {
  const response = await fetch('/api/endpoint');
  if (!response.ok) throw new Error('Failed');
} catch (error) {
  // Handle gracefully
}
```

## Performance Best Practices

### 1. Code Splitting
- Use dynamic imports for large components
- Lazy load below-the-fold content

### 2. Image Optimization
- Use Next.js Image component
- Specify width and height

### 3. Caching
- Use React cache for data fetching
- Implement proper revalidation strategies

### 4. Bundle Size
- Analyze with @next/bundle-analyzer
- Remove unused dependencies
