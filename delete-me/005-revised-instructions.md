### Revised SDC Implementation Instructions for activity-chart Component

Incorporating fixes from 004-sdc-validation.md to address accessibility, responsive design, data handling, and chart implementation issues.

#### Figma URL
https://www.figma.com/design/Q1nCfUKTjitE5qqGChhEX3/Dashboard-Finance-Bank-Fintech--Community-?node-id=114-604&m=dev

#### Design Breakdown
(Same as original)

#### SDC Mapping
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
              minimum: 0
              maximum: 100
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
- **Slots definition**: None.

#### Implementation Steps
1. **File structure requirements**:
   - Create a directory: `web/themes/custom/mytheme/components/activity-chart/`
   - Files:
     - `activity-chart.component.yml` (YAML config)
     - `activity-chart.twig` (Twig template)
     - `activity-chart.css` (Stylesheet)
     - `images/dropdown-arrow.svg` and `images/arrow-right.svg`

2. **YAML configuration**:
   ```yaml
   $schema: https://git.drupalcode.org/project/drupal/-/raw/HEAD/core/assets/schemas/v1/metadata.schema.json
   name: Activity Chart
   status: experimental
   props:
     # As above
   library:
     css:
       component:
         activity-chart.css: {}
   ```

3. **Twig template approach**:
   ```twig
   <div class="activity-chart"{{ attributes }}>
     <div class="activity-chart__header">
       <div class="activity-chart__dropdown">
         <span class="activity-chart__month">{{ month }}</span>
         <img src="{{ base_path ~ directory }}/images/dropdown-arrow.svg" alt="Dropdown arrow" />
       </div>
     </div>
     <h2 class="activity-chart__title">{{ title }}</h2>
     <figure class="activity-chart__chart">
       <div class="activity-chart__circle" aria-label="Activity breakdown: {{ data|map(item => item.label ~ ' ' ~ item.percentage ~ '%')|join(', ') }}">
         {% for item in data %}
           <div class="activity-chart__segment" style="background-color: {{ item.color }};"></div>
         {% endfor %}
         <div class="activity-chart__center">
           <span class="activity-chart__total">{{ data|length ? (data|map(item => item.percentage)|sum) : 0 }}%</span>
         </div>
       </div>
       <figcaption class="visually-hidden">Activity chart showing breakdown by category</figcaption>
       <div class="activity-chart__labels">
         {% for item in data %}
           <div class="activity-chart__label">
             <span class="activity-chart__percentage">{{ item.percentage }}%</span>
             <span class="activity-chart__label-text">{{ item.label }}</span>
           </div>
         {% endfor %}
       </div>
     </figure>
     <div class="activity-chart__footer">
       <a href="{{ view_all_url }}" class="activity-chart__view-all">
         View all activity
         <img src="{{ base_path ~ directory }}/images/arrow-right.svg" alt="Arrow right" />
       </a>
     </div>
   </div>
   ```

4. **CSS implementation**:
   ```css
   .activity-chart {
     max-width: 374px;
     width: 100%;
     height: auto;
     min-height: 415px;
     background-color: #1D1D41;
     border-radius: 20px;
     padding: 16px;
     box-sizing: border-box;
     position: relative;
     font-family: 'General Sans Variable', sans-serif;
     color: #FFFFFF;
     display: flex;
     flex-direction: column;
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
     flex-grow: 1;
   }
   .activity-chart__circle {
     width: 292px;
     height: 285px;
     border-radius: 50%;
     position: relative;
     background: conic-gradient({{ data|map(item => item.color ~ ' ' ~ (item.percentage / 100 * 360) ~ 'deg')|join(', ') }});
     display: flex;
     justify-content: center;
     align-items: center;
   }
   .activity-chart__segment {
     /* Removed, using conic-gradient instead */
   }
   .activity-chart__center {
     z-index: 1;
     background-color: #1D1D41;
     border-radius: 50%;
     width: 150px;
     height: 150px;
     display: flex;
     justify-content: center;
     align-items: center;
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
   .visually-hidden {
     position: absolute;
     width: 1px;
     height: 1px;
     padding: 0;
     margin: -1px;
     overflow: hidden;
     clip: rect(0, 0, 0, 0);
     white-space: nowrap;
     border: 0;
   }
   @media (max-width: 480px) {
     .activity-chart {
       padding: 8px;
       max-width: 100%;
     }
     .activity-chart__circle {
       width: 200px;
       height: 200px;
     }
     .activity-chart__center {
       width: 100px;
       height: 100px;
     }
   }
   ```

5. **JavaScript (if needed)**: No JS required for static display. For interactivity, add later with Drupal behaviors.

6. **Additional Notes**:
   - Added accessibility: `<figure>`, `aria-label`, `alt` attributes, `visually-hidden` figcaption.
   - Made responsive: `max-width`, `width: 100%`, media query.
   - Improved chart: Used `conic-gradient` for accurate donut.
   - Data validation: Added min/max to schema.