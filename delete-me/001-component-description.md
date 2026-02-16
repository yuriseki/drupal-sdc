### Figma URL
https://www.figma.com/design/Q1nCfUKTjitE5qqGChhEX3/Dashboard-Finance-Bank-Fintech--Community-?node-id=114-604&m=dev

### Design Breakdown
- **Component structure and hierarchy**: This is a card-based component (Group 1000002310) representing an activity breakdown chart. It consists of:
  - A main container (Rectangle 64) with rounded corners (20px) and a dark background (#1D1D41).
  - A header section with a "Month" dropdown (Rectangle 69, text "Month", and a dropdown arrow SVG).
  - A title "Activity" at the top.
  - A central circular chart area (large Ellipse 1 as background, with smaller colored ellipses for segments: Ellipse 28 #6359E9, Ellipse 29 #64CFF6, Ellipse 25 #661EFF, Ellipse 26 #64CFF6).
  - Percentage texts (75% central, 55% and 20% below) and labels ("Daily payment", "Hobby").
  - A bottom section with "View all activity" text, an arrow SVG, and a border rectangle (Rectangle 70).
- **Visual elements**:
  - **Colors**: Background #1D1D41; text #FFFFFF; accents #AEABD8 (dropdown), #6359E9 (segment), #64CFF6 (segment), #661EFF (segment); borders rgba(140, 137, 180, 0.5) and #FFFFFF.
  - **Typography**: Font family "General Sans Variable". Sizes: 24px bold for title and central percentage; 18px medium for segment percentages; 16px regular for "View all"; 14px regular for labels; 12px regular for "Month".
  - **Spacing**: Card dimensions 374x415px. Header at top-right (277x19, 75x27). Chart area centered (37x106, 292x285). Bottom section at 37x348, 299x48. Absolute positioning used in Figma; translate to relative/flexbox in CSS.
  - **Other**: Rounded corners (20px main, 10px dropdown/border). SVGs for dropdown and arrow icons (downloaded as dropdown-arrow.svg and arrow-right.svg).

### SDC Mapping
- **Component name and description**: `activity-chart` - A reusable card component for displaying activity breakdowns with a donut-style chart, percentages, and a "view all" link. Suitable for finance dashboards.
- **Props definition (schema.props in YAML)**:
  ```yaml
  $schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
  name: Activity Chart
  status: experimental
  props:
    type: object
    properties:
      title:
        type: string
        title: Title
        description: The main title of the chart (e.g., "Activity").
        default: "Activity"
      month:
        type: string
        title: Month
        description: The selected month for the chart.
        default: "Month"
      data:
        type: array
        title: Chart Data
        description: Array of data points for the chart segments.
        items:
          type: object
          properties:
            label:
              type: string
              description: Label for the segment (e.g., "Daily payment").
            percentage:
              type: integer
              description: Percentage value (e.g., 55).
            color:
              type: string
              description: Hex color for the segment (e.g., "#6359E9").
      view_all_url:
        type: string
        title: View All URL
        description: URL for the "View all activity" link.
        default: "#"
  ```
- **Slots definition (schema.slots in YAML)**: No slots defined; the component is self-contained. If extensibility is needed (e.g., custom chart rendering), add a `chart` slot in future iterations.

### Implementation Steps
1. **File structure requirements**:
   - Create a directory: `themes/custom/YOUR_THEME/components/activity-chart/`
   - Files:
     - `activity-chart.component.yml` (YAML config)
     - `activity-chart.twig` (Twig template)
     - `activity-chart.css` (Stylesheet)
     - `images/dropdown-arrow.svg` and `images/arrow-right.svg` (copied from downloaded files in `/home/yuri/ssd2/project-files/Kalamuna/projects/drupal-11/code-instruction/images/`)

2. **YAML configuration**:
   - In `activity-chart.component.yml`, use the props schema above. Add library definition for CSS/JS if needed:
     ```yaml
     library:
       css:
         component:
           activity-chart.css: {}
     ```

3. **Twig template approach**:
   - Use the following Twig structure in `activity-chart.twig`:
     ```twig
     <div class="activity-chart">
       <div class="activity-chart__header">
         <div class="activity-chart__dropdown">
           <span class="activity-chart__month">{{ month }}</span>
           <img src="{{ base_path ~ directory }}/images/dropdown-arrow.svg" alt="Dropdown" />
         </div>
       </div>
       <h2 class="activity-chart__title">{{ title }}</h2>
       <div class="activity-chart__chart">
         <div class="activity-chart__circle">
           {% for item in data %}
             <div class="activity-chart__segment" style="background-color: {{ item.color }};"></div>
           {% endfor %}
           <div class="activity-chart__center">
             <span class="activity-chart__total">{{ data|length ? (data|map(item => item.percentage)|sum) : 0 }}%</span>
           </div>
         </div>
         <div class="activity-chart__labels">
           {% for item in data %}
             <div class="activity-chart__label">
               <span class="activity-chart__percentage">{{ item.percentage }}%</span>
               <span class="activity-chart__label-text">{{ item.label }}</span>
             </div>
           {% endfor %}
         </div>
       </div>
       <div class="activity-chart__footer">
         <a href="{{ view_all_url }}" class="activity-chart__view-all">
           View all activity
           <img src="{{ base_path ~ directory }}/images/arrow-right.svg" alt="Arrow" />
         </a>
       </div>
     </div>
     ```
     - Notes: The chart is simplified as a flex-based circle with segments (use CSS for donut effect). Positions are relative; adjust for responsiveness. Use `directory` Twig variable for paths.

4. **CSS implementation**:
   - In `activity-chart.css`, replicate styles:
     ```css
     .activity-chart {
       width: 374px;
       height: 415px;
       background-color: #1D1D41;
       border-radius: 20px;
       padding: 16px;
       box-sizing: border-box;
       position: relative;
       font-family: 'General Sans Variable', sans-serif;
       color: #FFFFFF;
     }
     .activity-chart__header {
       position: absolute;
       top: 19px;
       right: 19px;
     }
     .activity-chart__dropdown {
       display: flex;
       align-items: center;
       border: 1px solid rgba(140, 137, 180, 0.5);
       border-radius: 10px;
       padding: 5px 10px;
     }
     .activity-chart__month {
       font-size: 12px;
       margin-right: 8px;
     }
     .activity-chart__title {
       font-size: 24px;
       font-weight: 500;
       margin: 16px 0 0 0;
     }
     .activity-chart__chart {
       margin-top: 60px;
       display: flex;
       flex-direction: column;
       align-items: center;
     }
     .activity-chart__circle {
       width: 292px;
       height: 285px;
       border-radius: 50%;
       position: relative;
       background-color: #3A3A5A;
       display: flex;
       justify-content: center;
       align-items: center;
     }
     .activity-chart__segment {
       position: absolute;
       /* Use clip-path or pseudo-elements for donut segments; simplified here */
       width: 100%;
       height: 100%;
       border-radius: 50%;
       /* Dynamic segments based on data; requires JS or CSS calc for angles */
     }
     .activity-chart__center {
       z-index: 1;
     }
     .activity-chart__total {
       font-size: 24px;
       font-weight: 700;
     }
     .activity-chart__labels {
       margin-top: 20px;
       display: flex;
       justify-content: space-between;
       width: 100%;
     }
     .activity-chart__label {
       display: flex;
       flex-direction: column;
       align-items: center;
     }
     .activity-chart__percentage {
       font-size: 18px;
       font-weight: 500;
     }
     .activity-chart__label-text {
       font-size: 14px;
       margin-top: 4px;
     }
     .activity-chart__footer {
       position: absolute;
       bottom: 16px;
       left: 16px;
       right: 16px;
       border-top: 1px solid #FFFFFF;
       padding-top: 16px;
     }
     .activity-chart__view-all {
       display: flex;
       align-items: center;
       font-size: 16px;
       text-decoration: none;
       color: #FFFFFF;
     }
     .activity-chart__view-all img {
       margin-left: 8px;
     }
     ```
     - Notes: For accurate donut chart, use CSS `conic-gradient` or SVG paths based on `data` props. Add media queries for responsiveness.

5. **JavaScript (if needed)**: No JS required for static display. If interactivity (e.g., dropdown or animations) is added, include a `.js` file in the library and attach behaviors. Reference existing SDC patterns like `card` or `chart` components. If data is incomplete (e.g., exact segment angles), note limitations and suggest refinements.