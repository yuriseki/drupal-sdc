# Fast SDC Generation Workflow (Token-Optimized)

## Goal
Generate SDC components from Figma designs using minimum tokens.

## What This Workflow Skips
- ❌ Task tracking (TaskCreate, TaskUpdate)
- ❌ Code-instruction documentation files
- ❌ Test report generation
- ❌ Component README files (unless requested)
- ❌ Verbose explanations and summaries
- ❌ Multiple validation rounds
- ❌ Re-reading files unnecessarily

## What This Workflow Does
- ✅ Extract Figma design (1 API call)
- ✅ Create component files directly (.yml, .twig, .css)
- ✅ Validate YAML syntax once
- ✅ Provide minimal status update

## Execution Steps

### 1. Extract Figma Design

**Step 1: Extract full file (includes styles):**
```bash
curl -s -H "X-Figma-Token: {API_KEY}" \
  "https://api.figma.com/v1/files/{FILE_ID}" > /tmp/figma-full-file.json
```

**Step 2: Extract component node data:**
```bash
curl -s -H "X-Figma-Token: {API_KEY}" \
  "https://api.figma.com/v1/files/{FILE_ID}/nodes?ids={NODE_ID}" > /tmp/figma-node.json
```

**Step 3: Extract style colors referenced by the component:**
```python
# From the node data, find style IDs in node.styles (e.g., 'fill': '6506:107886')
# From the full file, look up style name: data['styles']['6506:107886']['name'] = 'Green/Lighter'
# Fetch the style node to get actual color:
curl -s -H "X-Figma-Token: {API_KEY}" \
  "https://api.figma.com/v1/files/{FILE_ID}/nodes?ids={STYLE_ID}"
# Extract color.r, color.g, color.b and convert to hex
```

**CRITICAL: Extract style colors properly**
- Components reference styles by ID (found in node's `styles` property)
- Style definitions are in the full file's `styles` object with names like "Green/Lighter"
- Fetch each style node to get the actual RGB color values
- Convert RGB (0.0-1.0 range) to hex: `#{int(r*255):02x}{int(g*255):02x}{int(b*255):02x}`
- Add CSS comment with style name: `/* Green/Lighter from Figma */`

**CRITICAL: Analyze COMPLETE structure before implementing**

Parse JSON response for:
1. **Top-level component name** - This is the actual component name
2. **ALL direct children** - Don't focus on just one child
3. **Complete text hierarchy** - All text elements and their sizes/weights
4. **Layout structure** - Full grid/flex layout, not just parts
5. **All interactive elements** - Buttons, links, forms
6. **Images and backgrounds** - Background images, photos, icons

**If screenshot provided: Read it FIRST** to understand visual layout

**Common mistakes to avoid:**
- ❌ Seeing "breadcrumbs" child and assuming component is just breadcrumbs
- ❌ Analyzing only first child element
- ❌ Not reading the full text content hierarchy
- ❌ Missing background images or layout containers
- ✅ Analyze COMPLETE component structure before naming/implementing

### 2. Download Figma Images

**CRITICAL: Find actual IMAGE nodes, not component containers**

```python
# Find all nodes with IMAGE fills (actual images)
def find_image_nodes(node):
    results = []
    fills = node.get('fills', [])
    for fill in fills:
        if fill.get('type') == 'IMAGE':
            results.append({
                'id': node.get('id'),
                'name': node.get('name'),
                'imageRef': fill.get('imageRef')
            })
    for child in node.get('children', []):
        results.extend(find_image_nodes(child))
    return results
```

**Download each actual image:**
```bash
# Get image URL using the IMAGE NODE ID (not component ID!)
curl -H "X-Figma-Token: {API_KEY}" \
  "https://api.figma.com/v1/images/{FILE_ID}?ids={IMAGE_NODE_ID}&format=png&scale=2"

# Download to theme assets
mkdir -p web/themes/custom/mytheme/assets/images/{component-name}
curl "{IMAGE_URL}" -o web/themes/custom/mytheme/assets/images/{component-name}/{image-name}.png
```

**Common mistake:**
- ❌ Using component/container node ID → Downloads rendered component
- ✅ Using IMAGE node ID → Downloads actual image

**Image paths in component:**
- Store in: `web/themes/custom/mytheme/assets/images/{component-name}/`
- Reference as: `/themes/custom/mytheme/assets/images/{component-name}/{image-name}.png`
- Use in defaults: `default: /themes/custom/mytheme/assets/images/...`

### 3. Generate Component Files

**Create all 3 files in one pass:**

#### {name}.component.yml
```yaml
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
name: {Name}
status: stable
description: {Brief description from design}
props:
  type: object
  properties:
    # Derive props from design elements
    # ALWAYS include default values
slots:
  # Only if design has content areas
examples:
  - # Single example with realistic defaults
```

#### {name}.twig
```twig
{% set classes = ['component-name', modifiers] %}
<div{{ attributes.addClass(classes) }}>
  {# Minimal structure from design #}
</div>
```

#### {name}.css
```css
/* BEM structure, essential styles only */
.component-name { }
.component-name__element { }
.component-name--modifier { }
@media (max-width: 768px) { }
```

### 3. Validate & Done
```bash
# Single validation
python3 -c "import yaml; yaml.safe_load(open('component.yml'))"
```

If valid: Done. If error: Fix and re-validate once.

## Design Analysis Shortcuts

### Text Elements → Props with ACTUAL Figma Content as Defaults
- Heading text → `heading` prop (default: **EXACT text from Figma**)
- Body text → `supporting_text` prop (default: **EXACT text from Figma**)
- Button text → `button_text` prop (default: **EXACT text from Figma**)
- ALL text → Use actual Figma content, not "Default Text" or placeholders

### Visual Elements → Props with ACTUAL Figma Values
- Colors → Use EXACT hex values from Figma (e.g., #008a11, not "green")
- Font sizes → Use EXACT px values from Figma (e.g., 48px, not "large")
- Spacing → Use EXACT gap/padding from Figma
- Images → Use imageRef or actual image URLs from Figma
- Background colors → Extract from Figma styles:
  1. Check node's `styles` property for style IDs (e.g., `'fills': '6506:107886'`)
  2. Look up style name in full file: `styles[styleId]['name']` = "Green/Lighter"
  3. Fetch style node: `/nodes?ids={styleId}` to get RGB values
  4. Convert to hex: `#{int(r*255):02x}{int(g*255):02x}{int(b*255):02x}`
  5. Fallback: If no style, check `fills` array or `backgroundColor`
  6. If `backgroundColor.a == 0.0` → transparent

### Images and Assets
- Extract imageRef from Figma
- Store in `image_url` or `background_image` props
- Use actual image dimensions from Figma

### Content Areas → Slots
- Dynamic content → slots (with title/description)

### Layout → CSS with ACTUAL Figma Values

**CRITICAL: Extract exact layout properties from Figma JSON**
```python
# From node data, get:
layoutMode           # HORIZONTAL, VERTICAL, NONE
primaryAxisAlignItems     # CENTER, MIN, MAX
counterAxisAlignItems     # CENTER, MIN, MAX
itemSpacing          # Gap between children (px)
paddingLeft, paddingRight, paddingTop, paddingBottom  # Padding values
absoluteBoundingBox.width   # Element width
absoluteBoundingBox.height  # Element height
maxWidth, minWidth   # Width constraints
```

**Apply to CSS:**
- Layout mode → `display: flex` or `display: grid`
- Item spacing → `gap: [itemSpacing]px`
- Padding → `padding: [top]px [right]px [bottom]px [left]px`
- Width from absoluteBoundingBox → `width: [width]px` or `max-width: [width]px`
- Alignment → `align-items`, `justify-content` based on primary/counter axis

**Colors and typography:**
- Background colors - **MUST extract from Figma styles**:
  - Check node.styles for fill style IDs → Look up in full file → Fetch style node → Convert RGB to hex
  - Add CSS comment: `background-color: #f0fced; /* Green/Lighter from Figma */`
  - If `backgroundColor.a == 0.0` and no style, component is transparent (omit property)
- Font sizes/weights → EXACT values from Figma text styles
- Colors → EXACT hex values from Figma fills/strokes

**Responsive:**
- Primary breakpoint at max-width of component (e.g., 1440px)
- Mobile breakpoint typically 968px or below

## Props Best Practices (Token-Efficient)

**Always include:**
1. `type` and `title` (required)
2. `default` (CRITICAL for UI Patterns)

**Skip when possible:**
1. Verbose descriptions (keep to 1 line)
2. Examples section (use defaults instead)

**MANDATORY: String length check for EVERY string prop**

Drupal's `textfield` element defaults to `#maxlength: 128`. Any string default longer than 128 chars will throw a validation error. Before writing each string prop, count the default value's characters and add `maxLength` if needed:

```python
# Run this mental check for every string prop:
len("your default text here") > 128  # → if True, add maxLength
```

```yaml
# Short text (≤128 chars) — no maxLength needed
heading:
  type: string
  title: Heading
  default: Public Transit in the Bay Area

# Long text (>128 chars) — maxLength REQUIRED
description:
  type: string
  title: Description
  maxLength: 1000   # ← REQUIRED when default > 128 chars
  default: MVgo is a service of the Mountain View Transportation Management Association (MTMA), a nonprofit membership organization...

# Medium text (uncertain) — add maxLength to be safe
summary:
  type: string
  title: Summary
  maxLength: 500    # ← Safe default for any paragraph-length text
  default: ...
```

**Rules:**
- `len(default) > 128` → MUST add `maxLength`
- Paragraphs / body text → always use `maxLength: 1000`
- Subtitles / summaries → use `maxLength: 500`
- Titles / labels / URLs → no maxLength needed (always short)

**CRITICAL: Use ACTUAL Figma content, not placeholders:**
- ✅ `default: Public Transit in the Bay Area` (from Figma)
- ❌ `default: Heading Text` (placeholder)
- ✅ `default: #008a11` (exact color from Figma)
- ❌ `default: green` (generic)
- ✅ `default: 48` (exact font size from Figma)
- ❌ `default: large` (generic)

## Example: Complete Fast Workflow

**Input:** Figma URL for card component

**Output (3 files created in ~2000 tokens):**

```yaml
# card.component.yml
$schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
name: Card
status: stable
description: Card with image and text
props:
  type: object
  properties:
    heading:
      type: string
      title: Heading
      default: Card Title
    text:
      type: string
      title: Text
      default: Description text
    image_url:
      type: string
      title: Image
      default: ""
```

```twig
{# card.twig #}
{% set classes = ['card'] %}
<div{{ attributes.addClass(classes) }}>
  {% if image_url %}<img src="{{ image_url }}" alt="">{% endif %}
  <h3>{{ heading }}</h3>
  <p>{{ text }}</p>
</div>
```

```css
/* card.css */
.card { display: flex; gap: 16px; padding: 16px; }
.card img { width: 100px; height: 100px; border-radius: 8px; }
.card h3 { margin: 0; font-size: 18px; }
.card p { margin: 0; color: #666; }
@media (max-width: 768px) { .card { flex-direction: column; } }
```

**Status:** "✅ Card component created and validated"

## Token Savings

| Traditional Workflow | Fast Workflow | Savings |
|---------------------|---------------|---------|
| ~75,000 tokens | ~10,000 tokens | 87% |

**Breakdown:**
- Skip task tracking: -5,000 tokens
- Skip code-instruction files: -15,000 tokens
- Skip test reports: -10,000 tokens
- Skip README: -8,000 tokens
- Skip verbose explanations: -20,000 tokens
- Direct implementation: -7,000 tokens

## When to Use Traditional Workflow

Use full workflow only when:
- Complex component (10+ props, multiple slots)
- User explicitly requests documentation
- Component requires custom JavaScript
- Multiple component variants
- Team review needed before implementation

## When to Use Fast Workflow

Use for:
- Simple to medium components
- Rapid prototyping
- Iterative design implementation
- Standard patterns (cards, buttons, headers)
- User says "just implement it"

## Invocation

**User says:** "Implement this Figma design [URL]"

**Claude response:**
1. Fetch Figma data (1 API call)
2. Create 3 files (.yml, .twig, .css)
3. Validate YAML
4. Reply: "✅ {Name} component created"

Total: ~10,000 tokens vs ~75,000 tokens

## Critical Rules (Never Skip)

1. ✅ **Analyze COMPLETE component structure** - Don't jump to conclusions
2. ✅ **Read screenshot if provided** - Visual understanding before code
3. ✅ **Use correct component name** - From top-level Figma node or design intent
4. ✅ **Use ACTUAL Figma content as defaults** - Extract real text, colors, images from Figma data
5. ✅ **ALL props MUST have defaults** (with actual Figma values)
6. ✅ **COUNT characters in every string default** - If `len(default) > 128`, add `maxLength`. No exceptions.
   - Paragraphs / body text → `maxLength: 1000`
   - Summaries / subtitles → `maxLength: 500`
   - Titles / labels / URLs → no maxLength needed
7. ✅ **Extract colors from Figma styles** - Not just fills, fetch style nodes for accurate colors
8. ✅ Validate YAML syntax
9. ✅ Use BEM methodology
10. ✅ Include responsive styles (with exact Figma spacing/colors)
11. ✅ Follow existing component patterns
