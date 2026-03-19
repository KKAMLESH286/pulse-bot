---
name: review-design
description: |
  Expert UI/UX designer reviewing Flutter applications for visual design quality, user experience patterns and design system consistency. Use this skill when reviewing screens, widgets, or entire features from a design perspective.

  Examples:
  - "Review the design of the login screen"
  - "Check the UX of the user management flow"
  - "Audit the dashboard for design consistency"
  - "Review the UI of this new feature"

allowed-tools: Read, Glob, Grep, Bash
---

# UI/UX Design Reviewer Skill

Expert UI/UX design reviewer for Flutter applications, focusing on visual design quality, user experience patterns, and design system adherence.

## When to Use This Skill

- After implementing new screens or widgets
- Before finalizing UI implementations
- When reviewing feature completeness from UX perspective
- To validate design system compliance
- When reviewing Figma-to-code implementations

## Review Categories

For every design review, findings are categorized into:

- **Critical Issue**: Severe UX problems, or major design inconsistencies
- **Design Improvement**: Visual enhancements that would improve the design quality
- **UX Enhancement**: User experience improvements for better usability
- **Praise**: Recognition for excellent design implementation

---

## Comprehensive Design Review Checklist

### 1. Design System Compliance

#### Color Usage
- [ ] All colors use `AppColors` constants (no raw `Color()` or `Colors.*`)
- [ ] Semantic colors used correctly (error, success, warning)
- [ ] Sufficient color contrast for text readability (WCAG AA: 4.5:1 for normal text, 3:1 for large text)
- [ ] Dark theme colors are consistent throughout
- [ ] Status colors match their semantic meaning

```dart
// CORRECT
color: AppColors.textPrimary
color: AppColors.error
color: AppColors.statusApproved

// WRONG - Flag these
color: Colors.red
color: Color(0xFF123456)
color: Colors.white.withOpacity(0.5)
```

#### Typography
- [ ] All text uses `AppTextStyles` (no inline `TextStyle()`)
- [ ] Text hierarchy is clear (headings > body > captions)
- [ ] Consistent font families (Outfit, Gilroy, Poppins per design)
- [ ] Appropriate font weights for emphasis
- [ ] Line heights support readability

```dart
// CORRECT
style: AppTextStyles.title2Bold
style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)

// WRONG - Flag these
style: TextStyle(fontSize: 16.sp)
style: TextStyle(fontWeight: FontWeight.bold)
```

#### ScreenUtil Usage
- [ ] `.w` for horizontal dimensions (width, horizontal padding/margin)
- [ ] `.h` for vertical dimensions (height, vertical padding/margin)
- [ ] `.sp` for font sizes only (already in AppTextStyles)
- [ ] `.r` for border radius
- [ ] Consistent spacing scale (8, 12, 16, 20, 24, 32, 48)

```dart
// CORRECT
padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
borderRadius: BorderRadius.circular(12.r)
SizedBox(height: 16.h)

// WRONG - Flag these
padding: EdgeInsets.all(16) // Missing .w/.h
height: 50 // Missing .h
```

### 2. Visual Hierarchy & Layout

#### Spacing & Alignment
- [ ] Consistent padding within cards/containers (typically 16.w, 20.w, 24.w)
- [ ] Consistent gaps between elements (8.h, 12.h, 16.h, 24.h)
- [ ] Proper alignment (start, center, spaceBetween as appropriate)
- [ ] Visual grouping of related elements
- [ ] Whitespace creates breathing room

#### Visual Hierarchy
- [ ] Clear primary action (most prominent button/element)
- [ ] Secondary actions are visually subordinate
- [ ] Important information stands out
- [ ] Progressive disclosure of complex information
- [ ] Visual weight distribution is balanced

#### Content Density
- [ ] Information is not too cramped
- [ ] Sufficient spacing for touch targets (minimum 44x44 logical pixels)
- [ ] Lists have appropriate item spacing
- [ ] Cards have adequate internal padding
- [ ] Screen doesn't feel overwhelming

### 3. Component Patterns

#### Cards
- [ ] Consistent card styling (`AppColors.cardBackground`, `AppColors.cardBorder`)
- [ ] Appropriate border radius (typically 12.r, 14.r, 16.r)
- [ ] Consistent shadow/elevation treatment
- [ ] Adequate internal padding
- [ ] Clear content hierarchy within cards

```dart
// Expected card pattern
Container(
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(color: AppColors.cardBorder),
  ),
  child: ...
)
```

#### Buttons
- [ ] Primary buttons are visually prominent
- [ ] Secondary/outline buttons are clearly secondary
- [ ] Consistent button sizing (height: 48.h typical)
- [ ] Loading states for async actions
- [ ] Disabled states are visually distinct
- [ ] Adequate touch target size

#### Input Fields
- [ ] Consistent input styling
- [ ] Clear label placement
- [ ] Visible focus states
- [ ] Error states are visually clear (red border, error message)
- [ ] Placeholder text is helpful but not mistaken for values
- [ ] Proper keyboard types for different inputs

#### Status Badges
- [ ] Use semantic status colors from `AppColors`
- [ ] Consistent badge sizing and styling
- [ ] Status is immediately recognizable
- [ ] Background/foreground color pairing is correct

```dart
// Status color pairings from AppColors
Approved: statusApproved / statusApprovedBg
Under Review: statusUnderReview / statusUnderReviewBg
Rejected: statusRejected / statusRejectedBg
Pending: statusPendingText / statusPendingBg
```

### 4. User Experience Patterns

#### Navigation & Wayfinding
- [ ] Current location is clear (active tab, breadcrumbs)
- [ ] Navigation is consistent across screens
- [ ] Back navigation is available where expected
- [ ] Deep links work correctly
- [ ] Tab bar highlights active state clearly

#### Loading States
- [ ] Loading indicators for async operations
- [ ] Skeleton screens for content loading (preferred over spinners)
- [ ] Progress feedback for long operations
- [ ] Loading doesn't cause layout shift

#### Empty States
- [ ] Meaningful empty state messages
- [ ] Helpful guidance or actions in empty states
- [ ] Visual illustration if appropriate
- [ ] Not just blank screen

#### Error States
- [ ] Clear error messages (user-friendly, not technical)
- [ ] Error recovery actions available
- [ ] Form validation shows inline errors
- [ ] Error boundaries prevent complete failure

#### Success States
- [ ] Confirmation for important actions
- [ ] Success feedback is visible but not intrusive
- [ ] Clear next steps after success

### 5. Responsive Design (Web)

#### Breakpoints
- [ ] Desktop layout works at 1280px+ width
- [ ] Tablet layout works at 768px-1279px
- [ ] No horizontal scrolling at any breakpoint
- [ ] Content reflows appropriately

#### Flexible Layouts
- [ ] Use of `Flexible`, `Expanded` appropriately
- [ ] Max-width constraints on content
- [ ] Grid layouts adjust column count
- [ ] Images scale appropriately

### 6. Micro-interactions & Polish

#### Animations
- [ ] Transitions are smooth (use Flutter curves)
- [ ] Duration is appropriate (150-300ms typical)
- [ ] Animations serve a purpose (feedback, state change)
- [ ] No jarring or excessive animations

#### Feedback
- [ ] Hover states for clickable elements (web)
- [ ] Press states provide visual feedback
- [ ] Form submission feedback
- [ ] Optimistic UI updates where appropriate

#### Visual Consistency
- [ ] Icon style is consistent (outlined, filled, size)
- [ ] Border radius is consistent within similar components
- [ ] Shadow/elevation is consistent
- [ ] Gradient usage is consistent

### 7. Dark Theme Specific

#### Dark Mode Colors
- [ ] Background colors use proper dark palette (`AppColors.background`, `AppColors.backgroundDark`)
- [ ] Text colors provide sufficient contrast on dark backgrounds
- [ ] Cards have subtle distinction from background
- [ ] Borders are visible but not harsh

#### Depth & Elevation
- [ ] Visual depth is maintained without shadows
- [ ] Overlays use appropriate opacity
- [ ] Glass effects use appropriate blur/opacity

---

## Review Process

### 1. First Impression
- Open the screen/widget being reviewed
- Note immediate visual impressions
- Identify any jarring elements or inconsistencies

### 2. Systematic Walkthrough
- Review against each checklist section
- Document specific findings with file:line references
- Capture screenshots or describe visual issues clearly

### 3. User Flow Analysis
- Walk through the intended user journey
- Identify friction points
- Check for missing states (loading, empty, error)

### 4. Technical Review
- Check code for design system compliance
- Verify ScreenUtil usage
- Check for hardcoded values

### 5. For Each Finding

Provide:
- **Location**: File path and line numbers, or visual description
- **Issue**: Specific description of the design problem
- **Impact**: How this affects users or design quality
- **Recommendation**: Concrete suggestion with code example if applicable
- **Category**: Critical / Design Improvement / UX Enhancement / Praise

---

## Summary Format

End each review with:

### Findings Count
- X Critical Issues
- Y Design Improvements
- Z UX Enhancements
- W Praise Items

### Overall Design Assessment
Brief summary of the design quality, strengths, and areas for improvement.

### Priority Recommendations
Top 3-5 most impactful improvements to make.

### Design System Compliance
- Colors: Compliant / Needs Work / Non-Compliant
- Typography: Compliant / Needs Work / Non-Compliant
- Spacing: Compliant / Needs Work / Non-Compliant
- Components: Compliant / Needs Work / Non-Compliant

---

## Common Design Anti-Patterns to Flag

```dart
// Raw colors (always flag)
color: Colors.red
color: Color(0xFF123456)
backgroundColor: Colors.white.withOpacity(0.1)

// Inline text styles (always flag)
style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)

// Missing responsive dimensions
padding: EdgeInsets.all(16)  // Should be 16.w or mixed
height: 50  // Should be 50.h
width: 200  // Should be 200.w

// Hardcoded border radius
borderRadius: BorderRadius.circular(12)  // Should be 12.r

// Poor touch targets
SizedBox(height: 30, width: 30)  // Too small, should be 44x44 minimum

// Missing loading/error/empty states
// Only happy path UI implemented

// Inconsistent spacing
// Mixed use of 8, 10, 12, 15, 16, 20, etc.
```

---

## Design System Quick Reference

### Color Palette
| Purpose | Color Constant |
|---------|---------------|
| Primary Background | `AppColors.background` |
| Card Background | `AppColors.cardBackground` |
| Primary Text | `AppColors.textPrimary` |
| Secondary Text | `AppColors.textSecondary` |
| Muted Text | `AppColors.textMuted` |
| Primary Action | `AppColors.primaryPurple` |
| Accent | `AppColors.accentPurple` |
| Success | `AppColors.success` |
| Error | `AppColors.error` |
| Border | `AppColors.cardBorder` |

### Typography Scale
| Purpose | Style |
|---------|-------|
| Large Title | `AppTextStyles.largeTitle` |
| Title | `AppTextStyles.title2Bold` |
| Section Header | `AppTextStyles.title3` |
| Headline | `AppTextStyles.headline` |
| Body Large | `AppTextStyles.bodyLarge` |
| Body Medium | `AppTextStyles.bodySemiBold` |
| Body Small | `AppTextStyles.bodySmall` |
| Caption | `AppTextStyles.caption` |
| Badge | `AppTextStyles.badgeLabel` |

### Spacing Scale
| Size | Value |
|------|-------|
| XS | 4.w / 4.h |
| S | 8.w / 8.h |
| M | 12.w / 12.h |
| L | 16.w / 16.h |
| XL | 20.w / 20.h |
| XXL | 24.w / 24.h |
| XXXL | 32.w / 32.h |

### Border Radius
| Component | Radius |
|-----------|--------|
| Small elements | 8.r |
| Cards | 12.r - 14.r |
| Large cards | 16.r - 20.r |
| Buttons | 12.r |
| Inputs | 12.r |

---

## Related Skills

- **review-code** - Technical code review
- **create-widget** - Fix widget implementation issues
- **figma-to-presentation** - Implement designs from Figma
- **create-screen** - Create properly structured screens

## Notes

This skill reviews Flutter applications from a UI/UX designer's perspective, focusing on visual design quality, user experience patterns, and design system adherence. It ensures implementations match design intent and provide an excellent user experience.
