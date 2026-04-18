// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Track scroll position before Turbo visit; preserve it if only query params changed (filter toggle)
let lastPathname = window.location.pathname
let scrollBeforeVisit = 0

document.addEventListener("turbo:before-visit", () => {
  lastPathname = window.location.pathname
  scrollBeforeVisit = window.scrollY
})

document.addEventListener("turbo:render", () => {
  const samePath = window.location.pathname === lastPathname
  if (samePath) {
    // Same page, filter changed — keep scroll position
    window.scrollTo({ top: scrollBeforeVisit, behavior: "instant" })
  } else {
    // Different page — scroll to top
    window.scrollTo({ top: 0, behavior: "instant" })
  }
})
