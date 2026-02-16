# Card Menu Component

A horizontal card component displaying an avatar image with heading and description text, suitable for menu items or list entries.

## Features

- Circular avatar/logo image (132×132px)
- Heading with green accent underline
- Supporting descriptive text
- Optional external link icon
- Optional clickable link wrapper
- Responsive design (stacks vertically on mobile)
- Accessibility compliant (WCAG AA)
- Image placeholder state

## Component Details

- **File**: `card-menu`
- **Location**: `web/themes/custom/mytheme/components/card-menu/`
- **Figma Design**: [511 Visual Design](https://www.figma.com/design/ZNdvmMsbzgS7O9tPFl4xV5/511-Visual-Design--WIP-?node-id=4701-41902&m=dev)
- **Status**: Stable
- **Group**: Components

## Props

| Prop | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `heading` | string | Yes | - | The main heading text for the card |
| `supporting_text` | string | No | - | The descriptive text below the heading |
| `image_url` | string | No | - | URL to the circular image/avatar |
| `image_alt` | string | No | `""` | Alternative text for the image (accessibility) |
| `link_url` | string | No | - | Optional URL to make the card clickable |
| `show_external_icon` | boolean | No | `false` | Whether to display the external link icon |
| `modifier_class` | string | No | - | Optional modifier class for styling variants |

## Slots

| Slot | Description |
|------|-------------|
| `image` | Optional slot for custom image markup (overrides `image_url` prop) |

## Usage Examples

### Basic Card
```twig
{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image_url: '/path/to/transit-agency-logo.jpg',
  image_alt: 'Transit Agency Logo'
}, with_context = false) }}
```

### Card with Link
```twig
{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image_url: '/path/to/transit-agency-logo.jpg',
  image_alt: 'Transit Agency Logo',
  link_url: '/transit-agencies',
  show_external_icon: true
}, with_context = false) }}
```

### Card with Custom Image Slot
```twig
{% set custom_image %}
  <picture>
    <source srcset="/images/transit-agency-2x.webp 2x" type="image/webp">
    <img src="/images/transit-agency.jpg" alt="Transit Agency Logo" />
  </picture>
{% endset %}

{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image: custom_image
}, with_context = false) }}
```

### Using with Drupal Entities
```twig
{# In a node template #}
{% set image_url = file_url(node.field_image.entity.uri.value) %}

{{ include('mytheme:card-menu', {
  heading: node.label,
  supporting_text: node.field_description.value,
  image_url: image_url,
  image_alt: node.field_image.alt,
  link_url: path('entity.node.canonical', {'node': node.id})
}, with_context = false) }}
```

## Styling

The component uses BEM methodology for CSS classes:

- `.card-menu` - Base component class
- `.card-menu__image` - Image container
- `.card-menu__content` - Content wrapper
- `.card-menu__heading` - Heading element
- `.card-menu__text` - Supporting text
- `.card-menu__icon` - External link icon
- `.card-menu--linked` - Modifier for linked cards

## Responsive Behavior

- **Desktop (>768px)**: Horizontal layout with image on left
- **Mobile (≤768px)**: Vertical stack layout, centered alignment

## Accessibility

- ✅ WCAG AA compliant
- ✅ Keyboard accessible (when linked)
- ✅ Focus indicators on interactive elements
- ✅ Semantic HTML structure
- ✅ Image alt text support
- ✅ High color contrast (11.6:1)

## Browser Support

- Modern browsers (Chrome, Firefox, Safari, Edge)
- IE11+ (with autoprefixer)

## Performance

- Minimal CSS footprint (2.7KB)
- No JavaScript required
- Lazy loading images
- Print-optimized styles

## Customization

### Custom Modifier Classes

You can create custom variants by adding modifier classes:

```css
/* In your custom CSS */
.card-menu--featured {
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 24px;
}
```

Then use it:
```twig
{{ include('mytheme:card-menu', {
  heading: 'Featured Item',
  supporting_text: 'This is a featured card',
  modifier_class: 'featured'
}, with_context = false) }}
```

## Integration

### Views

Create a custom Views template and use the component to render rows:

```twig
{# views-view-unformatted--my-view.html.twig #}
{% for row in rows %}
  {{ include('mytheme:card-menu', {
    heading: row.content.title,
    supporting_text: row.content.body,
    image_url: row.content.image,
    link_url: row.content.path
  }, with_context = false) }}
{% endfor %}
```

### Layout Builder

The component can be integrated with Layout Builder through custom blocks or SDC Display module.

## Related Components

- `chip` - For smaller tag-like elements
- Future: `card-grid` - For displaying multiple cards in a grid layout

## Notes

- The heading border color (#008A11) matches the design system's green accent
- Images are automatically cropped to circle using CSS border-radius
- Component maintains aspect ratio on all screen sizes
- Print styles hide interactive effects for better printouts

## Version History

- **v1.0** (2026-02-16) - Initial implementation from Figma design
