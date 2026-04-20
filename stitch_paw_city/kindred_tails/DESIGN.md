# Design System Documentation: The Nurturing Atelier

## 1. Overview & Creative North Star
This design system is built upon the Creative North Star of **"The Nurturing Atelier."** 

We are moving away from the "utility-first" look of standard pet apps and toward a high-end editorial experience. The goal is to blend the warmth of a community hearth with the precision of a professional care management tool. We achieve this through **Organic Asymmetry**: breaking the rigid grid with overlapping image treatments, varying typography scales, and a rejection of traditional borders. This system should feel like a premium lifestyle magazine—airy, sophisticated, and deeply intentional.

## 2. Colors: Tonal Depth & Soul
Our palette transitions from "Paw-Pad Pinks" to "Friendly Blues" using the Material Design logic to ensure accessibility while maintaining a bespoke feel.

*   **Primary (`#ac2d5e`) & Secondary (`#00639f`):** These are our anchors. Use `primary` for moments of high emotional impact (love, care, community) and `secondary` for trustworthy utility (health records, schedules).
*   **The "No-Line" Rule:** We do not use 1px solid borders to define sections. Boundaries must be established through color blocking. For instance, a `surface_container_low` section should sit against a `surface` background to create a "well" effect.
*   **Surface Hierarchy & Nesting:** Think of the UI as physical layers. 
    *   Base: `surface`
    *   Sectioning: `surface_container`
    *   Floating Content: `surface_container_lowest` (pure white) to provide a "pop" against the background.
*   **The "Glass & Gradient" Rule:** To avoid a flat, "out-of-the-box" appearance, all primary CTAs and major hero headers should utilize a subtle linear gradient from `primary` to `primary_container`. For floating navigation or overlays, use **Glassmorphism**: apply a semi-transparent `surface` color with a 20px backdrop-blur to allow the vibrant pet photography to bleed through the UI.

## 3. Typography: The Editorial Voice
We utilize **Plus Jakarta Sans** across all tokens. It is modern, geometric, and friendly without being juvenile.

*   **High-Contrast Scale:** Use `display-lg` (3.5rem) for hero statements and community headlines. Pair these with `body-md` (0.875rem) for a sophisticated, editorial contrast that emphasizes hierarchy.
*   **The Title Narrative:** Use `title-lg` for pet names and health categories. This weight provides the "Trustworthy" pillar of the brand, acting as an authoritative yet approachable voice.
*   **Labels:** Use `label-sm` (all-caps with slight letter-spacing) for metadata like "VACCINATION STATUS" or "COMMUNITY POST" to provide a professional, organized structure to the playful aesthetics.

## 4. Elevation & Depth: Atmospheric Layering
Traditional shadows are too heavy for this system. We use **Tonal Layering** and **Ambient Light** to guide the eye.

*   **The Layering Principle:** Depth is achieved by stacking. A card should be `surface_container_lowest`. The container it sits in should be `surface_container_low`. This creates a soft, natural "lift" that feels premium and tactile.
*   **Ambient Shadows:** If a floating element requires a shadow (e.g., a "Create Post" button), use a diffused blur (20px-40px) at 6% opacity. The shadow color should be a tinted version of `on_surface` (a deep charcoal/blue) rather than pure black.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility (e.g., in high-contrast modes), use the `outline_variant` token at 15% opacity. Never use 100% opaque lines.
*   **Glassmorphism:** Use this for top-app bars and bottom navigation. This makes the app feel lightweight and integrated with the content behind it.

## 5. Components: Soft & Intentional
All components must adhere to the **Roundedness Scale**, defaulting to `DEFAULT` (1rem) for containers and `full` for interactive elements.

*   **Buttons:**
    *   *Primary:* Soft gradient from `primary` to `primary_container` with `on_primary` text. Use `full` roundedness.
    *   *Secondary:* `secondary_container` background with `on_secondary_container` text. No border.
*   **Cards & Pet Profiles:**
    *   No divider lines. Use `surface_container_highest` for a header strip or simply rely on vertical white space (use the 2rem or 3rem spacing tiers). 
    *   Images in cards should use `xl` (3rem) corner rounding on the top-left and bottom-right corners only to create a "signature" asymmetrical shape.
*   **Input Fields:**
    *   Background: `surface_container_high`. 
    *   State: On focus, the field should transition to `surface_container_lowest` with a subtle `primary` ghost-border (20% opacity).
*   **Chips:** Use `secondary_fixed` for filter chips with `on_secondary_fixed` text. These should always be `full` rounded.
*   **Pet-Specific Components:**
    *   *The Health Timeline:* A vertical sequence of events using `primary_container` dots. Do not use a solid line to connect them; use a dashed `outline_variant` line to maintain a light, "airy" feel.
    *   *Community Badges:* Small circular icons using `tertiary` (warm gold/brown) to represent "Top Contributor" or "Expert Caretaker."

## 6. Do’s and Don’ts

**Do:**
*   **Do** use asymmetrical layouts where a pet image overlaps the edge of a container.
*   **Do** use white space as a structural element. If you feel you need a line, try adding 16px of padding instead.
*   **Do** ensure all "friendly" blue accents (`secondary`) are used for functional, data-driven elements.

**Don’t:**
*   **Don’t** use pure black (#000000) for text or shadows. Use `on_background` or `on_surface`.
*   **Don’t** use sharp corners. Every element should have at least a `sm` (0.5rem) radius to maintain the "Friendly" brand pillar.
*   **Don’t** center-align long passages of text. High-end editorial design favors left-aligned text for readability and a modern "Swiss" feel.
*   **Don’t** use default Material Design shadows. They are too aggressive for the "Nurturing Atelier" aesthetic.