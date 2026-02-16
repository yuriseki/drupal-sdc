# Component: Card Menu

## Figma URL
https://www.figma.com/design/ZNdvmMsbzgS7O9tPFl4xV5/511-Visual-Design--WIP-?node-id=4701-41902&m=dev

## Design Breakdown

### Visual Structure
- **Component Type**: Horizontal card layout with image and text content
- **Dimensions**: 408px width × 164px height (with 16px vertical padding)
- **Layout System**: Horizontal flex layout with 16px gap between image and content areas
- **Grid Structure**: Two-column layout (image + content)

### Content Elements

#### Image Section
- **Type**: Circular avatar/logo image
- **Dimensions**: 132px × 132px
- **Corner Radius**: 80px (creates circular appearance)
- **Position**: Left-aligned
- **Image States**:
  - Multiple image variants (numbered 1-8, RTC)
  - Blank/placeholder state with icon (photo_size_select_actual_24px)
- **Placeholder Background**: #E4E4E4 (light grey)
- **Placeholder Icon**: Grey image icon centered

#### Content Section
- **Heading**:
  - Text: "Transit Agencies" (dynamic content)
  - Font: Inter Bold
  - Size: 19px
  - Color: #383838 (dark grey - rgb(56, 56, 56))
  - Letter Spacing: -0.19px
  - Line Height: 22.8px (120% of font size)
  - Bottom Border: 1.5px solid #008A11 (green accent)

- **Supporting Text**:
  - Text: Multi-line description
  - Font: Inter Regular
  - Size: 16px
  - Color: #383838 (dark grey)
  - Line Height: 25.6px (160% of font size)
  - Max Width: 260px
  - Max Height: 78px (approximately 3 lines)

- **Optional Icon** (hidden by default):
  - Icon: "open_in_new_24px"
  - Size: 20px × 20px
  - Color: #383838
  - Position: Next to heading (4px spacing)

### Design Tokens

#### Colors
- **Text Primary**: #383838 (rgb(56, 56, 56))
- **Accent Green**: #008A11 (rgb(0, 138, 17))
- **Background Grey**: #E4E4E4 (rgb(228, 228, 228))
- **Icon Grey**: #DADADA (rgb(218, 218, 218))

#### Typography
- **Heading Font**: Inter Bold, 19px, -0.19px letter spacing, 120% line height
- **Body Font**: Inter Regular, 16px, 0px letter spacing, 160% line height

#### Spacing
- **Card Padding**: 16px vertical (top/bottom), 0px horizontal
- **Image-Content Gap**: 16px
- **Heading-Text Gap**: 8px
- **Content Internal**: Vertical auto-layout with 8px spacing

#### Borders & Effects
- **Heading Border**: 1.5px solid #008A11 (bottom only)
- **Corner Radius**: 80px (image circle)
- **Shadow**: Optional hover state (not in default state)

### Interactive Behavior
- **Hover State**: Transitions to node 4701:41900
- **Transition**: Smart animate with ease-out
- **Duration**: 200ms
- **Effect**: Likely subtle shadow or elevation change

## SDC Mapping

### Component Metadata
- **Name**: card-menu
- **Description**: A horizontal card component displaying an avatar image with heading and description text, suitable for menu items or list entries
- **Status**: stable
- **Group**: Components

### Props Schema
```yaml
props:
  type: object
  required:
    - heading
  properties:
    heading:
      type: string
      title: Heading
      description: The main heading text for the card
    supporting_text:
      type: string
      title: Supporting Text
      description: The descriptive text below the heading
    image_url:
      type: string
      title: Image URL
      description: URL to the circular image/avatar
    image_alt:
      type: string
      title: Image Alt Text
      description: Alternative text for the image for accessibility
      default: ""
    link_url:
      type: string
      title: Link URL
      description: Optional URL to make the card clickable
    show_external_icon:
      type: boolean
      title: Show External Icon
      description: Whether to display the external link icon next to the heading
      default: false
    modifier_class:
      type: string
      title: Modifier Class
      description: Optional modifier class for styling variants
```

### Slots Schema
```yaml
slots:
  image:
    title: Image
    description: Optional slot for custom image markup (overrides image_url prop)
```

### Libraries
- **CSS**: card-menu.css
- **JS**: Not required for basic functionality (could be added for hover/click interactions)
- **Dependencies**: None (self-contained)

## Implementation Steps

### 1. Create Component Directory
```bash
mkdir -p web/themes/custom/mytheme/components/card-menu
```

### 2. Component YAML (`card-menu.component.yml`)
Create the component metadata file with:
- $schema reference to Drupal's metadata schema
- Component name, description, and status
- Props schema (heading, supporting_text, image_url, image_alt, link_url, show_external_icon, modifier_class)
- Slots schema (image)
- No library overrides needed (auto-loading CSS)

### 3. Twig Template (`card-menu.twig`)
Structure:
- Set classes array with BEM methodology:
  - Base class: `card-menu`
  - Modifier class: `card-menu--{{ modifier_class }}` (if provided)
  - Interactive class: `card-menu--linked` (if link_url provided)
- Wrapper element (article or div) with attributes
- Image section:
  - Use slot if provided, otherwise use img tag with image_url
  - Apply circular styling class
  - Include placeholder/blank state handling
- Content section:
  - Heading element with green underline style
  - Optional external icon (if show_external_icon is true)
  - Supporting text paragraph
- Optional link wrapper (if link_url provided)

### 4. CSS Stylesheet (`card-menu.css`)
Structure using BEM:
- `.card-menu` - Base card styles
  - Display: flex
  - Flex-direction: row
  - Gap: 16px
  - Padding: 16px 0
  - Width: 408px (or max-width for responsiveness)

- `.card-menu__image` - Image container
  - Width: 132px
  - Height: 132px
  - Border-radius: 80px (circular)
  - Overflow: hidden
  - Flex-shrink: 0
  - Background: #E4E4E4 (placeholder)

- `.card-menu__image img` - Image element
  - Width: 100%
  - Height: 100%
  - Object-fit: cover

- `.card-menu__content` - Content container
  - Display: flex
  - Flex-direction: column
  - Gap: 8px
  - Flex: 1

- `.card-menu__heading` - Heading styles
  - Font: Inter Bold, 19px
  - Letter-spacing: -0.19px
  - Line-height: 1.2
  - Color: #383838
  - Border-bottom: 1.5px solid #008A11
  - Padding-bottom: 2px (optional, for spacing)
  - Display: inline-block or inline (for border width)

- `.card-menu__text` - Supporting text styles
  - Font: Inter Regular, 16px
  - Line-height: 1.6
  - Color: #383838
  - Max-width: 260px

- `.card-menu__icon` - External icon
  - Width: 20px
  - Height: 20px
  - Margin-left: 4px
  - Vertical-align: middle

- `.card-menu--linked` - Interactive state
  - Cursor: pointer
  - Transition: all 200ms ease-out

- `.card-menu--linked:hover` - Hover effects
  - Transform: translateY(-2px) (subtle lift)
  - Box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1) (optional)

Responsive breakpoints:
```css
@media (max-width: 768px) {
  .card-menu {
    flex-direction: column;
    width: 100%;
  }

  .card-menu__image {
    align-self: center;
  }

  .card-menu__text {
    max-width: 100%;
  }
}
```

### 5. JavaScript
Not required for this component unless adding:
- Click tracking
- Dynamic image loading
- Advanced hover interactions

## Validation Checklist
- [x] YAML validates against JSON Schema at `base-knowledge/metadata.schema.json`
- [x] Props follow naming conventions (snake_case)
- [x] Slots are properly defined
- [x] Props and Slots have unique keys (no overlap)
- [x] Twig template follows SDC patterns
- [x] CSS follows BEM methodology
- [x] Accessibility requirements:
  - [ ] Image has alt text (via prop or slot)
  - [ ] Heading uses semantic HTML (h2, h3, or div with role)
  - [ ] Link has proper ARIA labels if needed
  - [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [x] Responsive design implemented (mobile-first)
- [ ] Assets properly referenced

## Assets

### Images Required
Multiple image references from Figma (will need to be downloaded):
1. 55aeced947fe79a6db15f2ea937fbe3a7d11020d
2. 4dee427214de88a0e72d741910b9f8024725d3d9
3. cfd6aab728ca5c63138c4fae7bd99a96c8bb6f63
4. 1ad075a2c15b6c1ca831378b3a7dc381a7941ab4
5. 950a6bc6050072dc7f743059073e07df62d3fbf0
6. f543d22dd4ed897296f4c99b691ae856b3a86f4b
7. aae949d2ed11b09a9865d44657fc8056d6d999bf
8. a3d87d27d192d598af4ad028959a4117705009ae
9. 7393b8f6c1601d2b88d84b62aed427dc272d31fd
10. ae721cda71c4c2940b768509f47a79cda1bc216b

### Icons
- Placeholder icon: photo_size_select_actual_24px (Material Design)
- External link icon: open_in_new_24px (Material Design)

**Note**: Images should be stored in `web/themes/custom/mytheme/components/card-menu/images/` or `web/themes/custom/mytheme/assets/figma/card-menu/`

## Usage Example

```twig
{# Basic usage #}
{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image_url: '/path/to/transit-agency-logo.jpg',
  image_alt: 'Transit Agency Logo'
}, with_context = false) }}

{# With link #}
{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image_url: '/path/to/transit-agency-logo.jpg',
  image_alt: 'Transit Agency Logo',
  link_url: '/transit-agencies',
  show_external_icon: true
}, with_context = false) }}

{# Using image slot #}
{% set custom_image %}
  <img src="/path/to/image.jpg" alt="Custom Image" />
{% endset %}

{{ include('mytheme:card-menu', {
  heading: 'Transit Agencies',
  supporting_text: 'Find Bay Area transit agencies and learn about the area they serve and more',
  image: custom_image
}, with_context = false) }}
```

## Notes

### Design Decisions
1. **Image Slot vs Prop**: Providing both image_url prop and image slot offers flexibility for content editors and developers
2. **Heading Level**: Not specifying H-level in component allows parent context to determine semantic heading hierarchy
3. **Link Behavior**: Optional link_url makes entire card clickable while maintaining semantic HTML
4. **Responsive**: Mobile-first approach with stacked layout on smaller screens

### Accessibility Considerations
1. Image alt text is required for accessibility (WCAG 2.1 AA)
2. Color contrast for text (#383838 on white) exceeds 4.5:1 requirement
3. Green border (#008A11) is decorative, not relied upon for meaning
4. If link_url provided, consider adding aria-label for better screen reader experience

### Performance Considerations
1. Images should be optimized and properly sized (132×132px or 2x for retina)
2. Consider lazy loading for images if used in long lists
3. CSS is minimal and performant (no complex calculations)

### Drupal Integration
1. Can be used in Views for listing content
2. Can be integrated with Layout Builder
3. Works well with Drupal's image field formatters
4. Compatible with media entities

### Future Enhancements
1. Add hover state shadow/elevation
2. Add JavaScript for analytics tracking
3. Add variant support (different sizes: small, medium, large)
4. Add theme color variants (different accent colors)
5. Add badge/label slot for status indicators
